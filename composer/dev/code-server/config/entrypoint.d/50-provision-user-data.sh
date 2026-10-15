#!/bin/sh
set -eu

# Seed code-server's user-data dir on first boot only.
#
# Why not mount settings.json / keybindings.json straight into
# ~/.local/share/code-server/User with a swarm config: the daemon then creates
# the not-yet-existing parent dirs root-owned, and code-server itself dies with
#     EACCES: permission denied, mkdir
#       '/home/coder/.local/share/code-server/coder-logs'
# The named volume on /home/coder is seeded from the image and owned by uid
# 1000, so everything code-server creates below keeps that ownership instead.
# https://github.com/coder/code-server/issues/5177

USER_DIR="${HOME}/.local/share/code-server/User"
MACHINE_DIR="${HOME}/.local/share/code-server/Machine"
PROVISION_DIR="/etc/code-server/provision"
WORKSPACE="${WORKSPACE:-/home/coder/projects}"

# Fail fast when no credential is configured. code-server does NOT error in that
# case: it writes a random password into ~/.config/code-server/config.yaml and
# serves anyway, which quietly locks you out of an internet-facing instance
# instead of telling you what is wrong.
if [ -z "${PASSWORD:-}" ] && [ -z "${HASHED_PASSWORD:-}" ]; then
  echo "provision: neither PASSWORD nor HASHED_PASSWORD is set in .env" >&2
  echo "provision:   PASSWORD=change-me" >&2
  echo "provision: or, to keep the password out of 'docker service inspect':" >&2
  echo "provision:   echo -n 'your-password' | argon2 \"some-salt\" -e" >&2
  echo "provision:   HASHED_PASSWORD=\$\$argon2i\$\$v=19\$\$...   # doubled dollars" >&2
  # `exit 1` would NOT stop code-server: the image entrypoint runs this file
  # through `find -exec`, and find exits 0 even when the exec'd command fails,
  # so its `set -e` never sees it. Killing the find that invoked us makes it
  # die on a signal (exit 143), which DOES trip the entrypoint's `set -e`.
  kill -TERM "${PPID}" 2>/dev/null || exit 1
  exit 1
fi

mkdir -p "${USER_DIR}"
mkdir -p "${MACHINE_DIR}"
# Seed the workspace folder itself so the explorer opens on an existing,
# writable dir even with no storage override mounted.
mkdir -p "${WORKSPACE}"

# Seed the user settings/keybindings, but re-seed when the *shipped* copy changes,
# so editing config/settings.json in git actually reaches a running container.
#
# Plain "only if missing" is wrong here: settings are iterated on far more often
# than the volume is recreated, and a volume that already has settings.json would
# silently ignore every later change. Instead the shipped copy is stamped next to
# it, and a content change (not a mode/ownership change) overwrites. In-browser
# edits are preserved as long as config/settings.json itself does not change.
seed_if_changed() {
  _name="$1"
  _src="${PROVISION_DIR}/${_name}"
  _dst="${USER_DIR}/${_name}"
  _stamp="${USER_DIR}/.${_name}.provisioned"
  if [ ! -f "${_dst}" ]; then
    install -m 0644 "${_src}" "${_dst}"
  elif ! [ -f "${_stamp}" ] || ! cmp -s "${_src}" "${_stamp}"; then
    install -m 0644 "${_src}" "${_dst}"
  else
    # shipped copy unchanged: leave whatever the user has in the browser
    chmod 0644 "${_dst}"
  fi
  # remember what was shipped, read-only, so nothing rewrites it by accident
  install -m 0444 "${_src}" "${_stamp}"
}
seed_if_changed settings.json
seed_if_changed keybindings.json

# `keyboard.layout` is pinned in the MACHINE settings file, not the user one.
# The server merges them like this (vs/code/browser/workbench/workbench.js):
#   _localUserConfiguration.merge(_remoteUserConfiguration)
# where the "remote" of a code-server is the server itself, i.e.
# Machine/settings.json. Because merge lets the later model win,
# Machine/settings.json overrides User/settings.json for the same key - so a
# User setting can never take effect while a Machine one exists. The Machine
# file is created lazily by code-server (the GUI writes machine-scoped choices
# such as the status-bar layout there), so a volume that has been used once can
# pin `autodetect` forever while User/settings.json is edited in vain.
#
# `autodetect` itself is the second trap: the image registers
#   "keyboard.layout": { default: "autodetect" }
# and that branch calls setLayoutFromBrowserAPI(), i.e. it asks the browser,
# which reports "us" for a generic keyboard.
MACHINE_SETTINGS="${MACHINE_DIR}/settings.json"
if [ ! -f "${MACHINE_SETTINGS}" ]; then
  printf '{\n}\n' > "${MACHINE_SETTINGS}"
fi
chmod 0644 "${MACHINE_SETTINGS}"
# replace in place, otherwise insert after the opening brace; both keep the
# existing comma so a key that is last in the object gains no trailing comma
if grep -q '"keyboard.layout":' "${MACHINE_SETTINGS}"; then
  sed -i "s#\"keyboard.layout\": *\"[^\"]*\"#\"keyboard.layout\": \"${KEYBOARD_LAYOUT:-de}\"#" \
    "${MACHINE_SETTINGS}"
else
  sed -i "1a\\  \"keyboard.layout\": \"${KEYBOARD_LAYOUT:-de}\"," "${MACHINE_SETTINGS}"
fi

# Re-apply the layout once the workbench is actually running.
#
# The value above is correct on disk, but VS Code drops it at startup (this is an
# upstream ordering bug, verified in vs/code/browser/workbench/workbench.js):
#
#   l && l !== "autodetect" && this._factory.setKeyboardLayout(l)
#   setKeyboardLayout(e){ let t = this.keymapInfos.filter(i => Cde(i.layout) === e)
#                         t.length > 0 && this.setActiveKeymapInfo(t[0]) }
#
# Setting a concrete layout SKIPS the setLayoutFromBrowserAPI() call, so
# _activeKeymapInfo is still null when the layout is requested, and
# setUserKeyboardLayoutIfMatched() - the other path that could apply it - is
# gated on `_factory.activeKeymap` being truthy. Both no-op, and the status bar
# falls back to US. In autodetect mode the browser path runs and initialises it,
# which is why changing the setting afterwards always works.
#
# So we flip the value to force a change event, which re-runs setKeyboardLayout
# against a now-initialised factory. Runs in the background (a child survives
# the entrypoint's exec) and only rewrites the file, never the process, so a
# restart of code-server itself is not triggered. The file already holds the
# right value, so if this tail is killed at boot nothing is lost.
(
  sleep 15
  _pinned="$(grep -o '"keyboard.layout": *"[^"]*"' "${MACHINE_SETTINGS}")"
  printf '{\n  "keyboard.layout": "autodetect"\n}\n' > "${MACHINE_SETTINGS}"
  sleep 5
  printf '{\n  %s\n}\n' "${_pinned}" > "${MACHINE_SETTINGS}"
) >/dev/null 2>&1 &

# Extensions: only the ones that are missing. `--force` re-installs (and thus
# downloads) everything, which would stall every boot on network access.
INSTALLED="$(code-server --list-extensions 2>/dev/null || true)"

for ext in \
  aaron-bond.better-comments \
  bierner.markdown-preview-github-styles \
  charliermarsh.ruff \
  eamodio.gitlens \
  esbenp.prettier-vscode \
  foxundermoon.shell-format \
  ms-python.debugpy \
  ms-python.python \
  ms-python.vscode-python-envs \
  mushan.vscode-paste-image \
  pkief.material-icon-theme \
  redhat.ansible \
  redhat.vscode-xml \
  redhat.vscode-yaml \
  samuelcolvin.jinjahtml \
  silofy.hackthebox \
  streetsidesoftware.code-spell-checker \
  streetsidesoftware.code-spell-checker-german \
  tamasfe.even-better-toml \
  timonwong.shellcheck \
  wayou.vscode-todo-highlight \
  yzane.markdown-pdf \
  yzhang.markdown-all-in-one \
  ; do
  if ! printf '%s\n' "${INSTALLED}" | grep -qx "${ext}"; then
    echo "provision: installing extension '${ext}'"
    # Never fail the container over an unreachable marketplace - the entrypoint
    # runs every ENTRYPOINTD file under `set -e`, and a non-zero exit here
    # would abort the boot.
    code-server --force --install-extension "${ext}" >/dev/null 2>&1 ||
      echo "provision: WARN could not install '${ext}'" >&2
  fi
done
