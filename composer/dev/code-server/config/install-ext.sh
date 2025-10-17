#!/usr/bin/env bash

# "adpyke.vscode-sql-formatter" "analytic-signal.preview-pdf" "bibhasdn.unique-lines"
VS_CODE_EXTS=(
  "aaron-bond.better-comments"
  "bierner.markdown-preview-github-styles" "charliermarsh.ruff" "donjayamanne.githistory" "eamodio.gitlens"
  "esbenp.prettier-vscode" "foxundermoon.shell-format" "ms-python.python" "mushan.vscode-paste-image"
  "pkief.material-icon-theme" "redhat.ansible" "redhat.vscode-xml" "redhat.vscode-yaml"
  "samuelcolvin.jinjahtml" "silofy.hackthebox" "streetsidesoftware.code-spell-checker"
  "streetsidesoftware.code-spell-checker-german" "tamasfe.even-better-toml" "timonwong.shellcheck"
  "wayou.vscode-todo-highlight" "yzane.markdown-pdf" "yzhang.markdown-all-in-one"
)

for vs_code_ext in "${VS_CODE_EXTS[@]}"; do
  echo "📌 install extionsion '$vs_code_ext'..."
  code-server --force --install-extension "$vs_code_ext" 1>/dev/null
done
