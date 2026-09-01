#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR=$(
  cd "$(dirname "${BASH_SOURCE:-$0}")"
  pwd
)

declare -A installed_extensions=()
failed_extensions=()

while IFS= read -r extension; do
  [ -n "$extension" ] && installed_extensions["${extension,,}"]=1
done < <(code --list-extensions)

while IFS= read -r extension || [ -n "$extension" ]; do
  extension="${extension//$'\r'/}"
  [ -z "$extension" ] && continue

  if [ -n "${installed_extensions[${extension,,}]:-}" ]; then
    echo "Skip $extension (already installed)."
    continue
  fi

  echo "Install $extension ..."
  if code --install-extension "$extension"; then
    installed_extensions["${extension,,}"]=1
  else
    failed_extensions+=("$extension")
  fi
done <"$SCRIPT_DIR/code-extensions.txt"

if [ "${#failed_extensions[@]}" -gt 0 ]; then
  printf 'Failed to install VS Code extension: %s\n' "${failed_extensions[@]}" >&2
  exit 1
fi
