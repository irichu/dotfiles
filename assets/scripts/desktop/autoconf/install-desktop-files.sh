#!/bin/bash

shopt -s nullglob

SCRIPT_DIR=$(
  cd "$(dirname "${BASH_SOURCE:-$0}")"
  pwd
)
cd "$SCRIPT_DIR"

mkdir -p "$HOME/.local/share/applications"

for f in *.desktop.in; do
  sed "s|@HOME@|$HOME|g" "$f" \
    > "$HOME/.local/share/applications/${f%.in}"
done

chmod +x "$HOME/.local/share/applications"/*.desktop

update-desktop-database "$HOME/.local/share/applications"

cd -
