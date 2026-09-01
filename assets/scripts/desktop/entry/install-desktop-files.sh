#!/usr/bin/env bash

set -Eeuo pipefail

shopt -s nullglob

SCRIPT_DIR=$(
  cd "$(dirname "${BASH_SOURCE:-$0}")"
  pwd
)
cd "$SCRIPT_DIR"

mkdir -p "$HOME/.local/share/applications"

for f in *.desktop.in; do
  tmp=$(mktemp)
  sed "s|@HOME@|$HOME|g" "$f" > "$tmp"

  execline=$(grep -m1 '^Exec=' "$tmp" || true)
  execline=${execline#Exec=}
  # get first token (command) and strip desktop field codes like %U
  cmd=${execline%% *}
  cmd=${cmd%%%*}

  # skip if no Exec or empty command
  if [ -z "$cmd" ]; then
    rm -f "$tmp"
    continue
  fi

  # If command is a path (contains '/'), check that the path after substitution exists.
  # Otherwise, fall back to checking PATH (command -v).
  if [[ "$cmd" == */* ]]; then
    if [ ! -e "$cmd" ]; then
      rm -f "$tmp"
      continue
    fi
  else
    if ! command -v "$cmd" >/dev/null 2>&1; then
      rm -f "$tmp"
      continue
    fi
  fi

  mv "$tmp" "$HOME/.local/share/applications/${f%.in}"
done

desktop_files=("$HOME/.local/share/applications"/*.desktop)
if [ "${#desktop_files[@]}" -gt 0 ]; then
  chmod +x "${desktop_files[@]}"
fi

update-desktop-database "$HOME/.local/share/applications"

cd -
