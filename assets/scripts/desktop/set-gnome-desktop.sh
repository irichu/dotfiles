#!/bin/bash

SCRIPT_DIR=$(
  cd "$(dirname "${BASH_SOURCE:-$0}")"
  pwd
)

echo "$SCRIPT_DIR"

"$SCRIPT_DIR/"install-gnome-extensions.sh
"$SCRIPT_DIR/"set-dconf-custom-desktop.sh
"$SCRIPT_DIR/"set-dconf-custom-extensions.sh
"$SCRIPT_DIR/"set-dconf-custom-keybindings.sh
