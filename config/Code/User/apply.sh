#!/bin/bash

SCRIPT_DIR=$(
  cd "$(dirname "${BASH_SOURCE:-$0}")"
  pwd
)

if [ "$(uname)" == "Darwin" ]; then
  echo "macOS detected"
  mkdir -p ~/Library/Application\ Support/Code/User/

  # macOS specific commands
  cp "$SCRIPT_DIR/settings.json" ~/Library/Application\ Support/Code/User/
  cp "$SCRIPT_DIR/keybindings.json" ~/Library/Application\ Support/Code/User/
elif [ "$(uname)" == "Linux" ]; then
  echo "Linux detected"
  mkdir -p ~/.config/Code/User/

  # Linux specific commands
  cp "$SCRIPT_DIR/settings.json" ~/.config/Code/User/
  cp "$SCRIPT_DIR/keybindings.json" ~/.config/Code/User/
else
  echo "Unsupported OS"
  exit 2
fi

# Install extensions
"$SCRIPT_DIR"/myextensions/import-extensions.sh
