# SETUP

## basic

> designed to work with traefik

### create your `secrets`:

```sh
sudo apt install pwgen argon2

# pick ONE of the following, they are alternatives:

# 1) plain - readable in cleartext by `docker service inspect`
pwgen -s 24 1 | sed 's/^/PASSWORD=/' >> .env

# 2) hashed - what `docker service inspect` cannot leak
PASS=$(pwgen -s 24 1)
printf '%s' "$PASS" | argon2 'code-server' -e \
  | sed 's/\$/$$/g' | sed 's/^/HASHED_PASSWORD=/' >> .env
echo "your password: $PASS"

# 3) hash a password you already picked instead (input stays hidden)
read -rs -p 'password: ' PW && echo
printf '%s' "$PW" | argon2 'code-server' -e \
  | sed 's/\$/$$/g' | sed 's/^/HASHED_PASSWORD=/' >> .env
unset PW
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=code.home.local
PROTOCOL=http
PORT=8080
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file
CERT_RESOLVER=certificates

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=4
RESOURCES_LIMITS_MEMORY=4g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=4.141.0-ubuntu

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
# folder the explorer opens on start
WORKSPACE=/home/coder/projects
# shut down after N idle seconds (>60); empty/omitted = never idle out
IDLE_TIMEOUT_SECONDS=
KEYBOARD_LAYOUT=de
```

#### example short `.env` (swarm)

```env
DOMAIN=code.home.local
```

#### example short `.env` (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=code.home.local
```

### deploy

```sh
# swarm
docker-swarm-compose code-server -f docker-compose.yaml

# with remote storage, name the volumes file too
docker-swarm-compose code-server -f docker-compose.yaml -f docker-compose.volumes.yaml
```

---

## Firefox: clipboard and right-click menu

This stack is served over **HTTPS** (Traefik + Let's Encrypt), so the browser
context is secure (`window.isSecureContext === true`). The Firefox clipboard /
context-menu problem below is **not** a TLS or Traefik issue - it reproduces on
a valid Let's Encrypt certificate and comes from an upstream VS Code Web bug:
[microsoft/vscode#237840](https://github.com/microsoft/vscode/issues/237840)
(file tree, editor and integrated terminal), tracked for code-server as
[coder/code-server#1106](https://github.com/coder/code-server/issues/1106).
Both are still open as of 2026-10; no compose or Traefik change fixes it.

Symptom: the first right-click shows Firefox's native **"Paste"** popup (greyed
out for a moment) instead of VS Code's context menu; you have to right-click a
second time. It is triggered by text that was copied _inside_ code-server; text
copied from outside code-server pastes normally.

### Workarounds

1. **Firefox `about:config` (what most users end up with)** - set
   `dom.events.testing.asyncClipboard` to `true`. This makes
   `navigator.clipboard.readText()` work without transient user activation,
   which is what VS Code Web needs.
   - Caveat (Mozilla): this is a **testing** pref that disables _all_ clipboard
     permission checks in Firefox - any page can read the clipboard without a
     prompt. It is global; Firefox's per-site "Add Site Value" (128+) does **not**
     work for this pref, because VS Code reads it without a site context.
   - Undo: flip it back to `false` when you stop using code-server.

2. **Scope the exception to the code-server origin** with the (third-party,
   unsigned) [Grant Clipboard](https://addons.mozilla.org/en-US/firefox/addon/grant-clipboard/)
   add-on - it allowlists origins and only grants clipboard access there. Same
   underlying mechanism, narrower blast radius. Trade-off: it holds
   `clipboardRead` + `<all_urls>` and is a single-author extension.

3. **Managed browser** - deploy the pref centrally via Firefox enterprise policy
   (`policies.json` → `Preferences: { "dom.events.testing.asyncClipboard": true }`).
   Same global effect as (1), just centrally managed.

4. **No-install, no-pref tricks** (Firefox native):
   - `Shift+Right-click` → Firefox's native context menu → "Paste" works.
   - `Shift+Insert` → native paste in the terminal.
   - Terminal only: remove VS Code's `workbench.action.terminal.paste`
     keybinding so `Ctrl+V` falls through to the browser's native paste into
     xterm's textarea. Does not fix the editor/explorer menu. Example entry in
     your user `keybindings.json`:

     ```json
     {
       "key": "ctrl+v",
       "command": "-workbench.action.terminal.paste",
       "when": "terminalFocus"
     }
     ```

5. **Use Chromium/Chrome (or a Chromium-based browser) for code-server.** The
   bug is Firefox-only; no pref, no extension, no security downgrade. Recommended
   if you are not tied to Firefox.

### Not a fix

- HTTPS / Let's Encrypt (this stack already serves HTTPS via Traefik) - does not
  change the behaviour; confirmed on wildcard Let's Encrypt certificates with
  `window.isSecureContext === true`.
- Traefik middlewares / Permissions-Policy changes - unrelated.

---

## References

- <https://coder.com/docs/code-server/install#docker>
- <https://hub.docker.com/r/codercom/code-server>
- image build recipe: <https://github.com/coder/code-server/blob/main/ci/release-image/Dockerfile>
- image entrypoint: <https://github.com/coder/code-server/blob/main/ci/release-image/entrypoint.sh>
