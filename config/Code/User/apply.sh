#!/bin/bash

if [ "$(uname)" == "Darwin" ]; then
  echo "macOS detected"
  # macOS specific commands
  cp settings.json ~/Library/Application\ Support/Code/User/
  cp keybindings.json ~/Library/Application\ Support/Code/User/
elif [ "$(uname)" == "Linux" ]; then
  echo "Linux detected"
  # Linux specific commands
  cp settings.json ~/.config/Code/User/
  cp keybindings.json ~/.config/Code/User/
else
  echo "Unsupported OS"
fi
