#!/usr/bin/env bash

# Install Ulauncher
# https://ulauncher.io/#Download
sudo add-apt-repository universe -y
sudo add-apt-repository ppa:agornostal/ulauncher -y
sudo apt update
sudo apt install ulauncher -y

SCRIPT_DIR=$(
  cd "$(dirname "${BASH_SOURCE:-$0}")"
  pwd
)

# Copy autostart
if [ ! -d "$HOME/.config/autostart" ]; then
  mkdir -p "$HOME/.config/autostart"
fi

if [ "$XDG_SESSION_TYPE" = "x11" ]; then
  AUTOSTART_SRC="$SCRIPT_DIR/../../../config/autostart/ulauncher.desktop.x11"
else
  AUTOSTART_SRC="$SCRIPT_DIR/../../../config/autostart/ulauncher.desktop"
fi

if [ -f "$AUTOSTART_SRC" ]; then
  if ! cp -f "$AUTOSTART_SRC" "$HOME/.config/autostart/"; then
    echo "Failed to copy autostart file from '$AUTOSTART_SRC' to '$HOME/.config/autostart/'" >&2
  fi
else
  echo "Autostart file not found: '$AUTOSTART_SRC'" >&2
fi

# Copy config
if [ ! -d "$HOME/.config/ulauncher" ]; then
  mkdir -p "$HOME/.config/ulauncher"
fi

CONFIG_SRC_DIR="$SCRIPT_DIR/../../../config/ulauncher"

for cfg_file in extensions.json settings.json; do
  SRC_FILE="$CONFIG_SRC_DIR/$cfg_file"

  if [ -f "$SRC_FILE" ]; then
    if ! cp -f "$SRC_FILE" "$HOME/.config/ulauncher/"; then
      echo "Failed to copy Ulauncher config file from '$SRC_FILE' to '$HOME/.config/ulauncher/'" >&2
    fi
  else
    echo "Ulauncher config file not found: '$SRC_FILE'" >&2
  fi
done
