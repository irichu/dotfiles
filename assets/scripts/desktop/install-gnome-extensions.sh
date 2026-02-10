#!/usr/bin/env bash

sudo apt install -y gnome-shell-extension-manager pipx
#
# gir1.2-gtop-2.0 for Tophat
# sudo apt install -y gir1.2-gtop-2.0

# Install gnome extensions
EXT_IDS=(
  AlphabeticalAppGrid@stuarthayhurst
  blur-my-shell@aunetx
  compiz-alike-magic-lamp-effect@hermes83.github.com
  compiz-windows-effect@hermes83.github.com
  just-perfection-desktop@just-perfection
  space-bar@luchrioh
  tactile@lundal.io
  tophat@fflewddur.github.io
  undecorate@sun.wxg@gmail.com
  user-theme@gnome-shell-extensions.gcampax.github.com
  wsmatrix@martin.zurowietz.de
)

# Install gnome-extensions-cli
if [ ! -f "$HOME/.local/bin/gext" ]; then
  pipx install gnome-extensions-cli --system-site-packages
fi

# Install extensions
for ext in "${EXT_IDS[@]}"; do
  "$HOME/.local/bin/"gext install "$ext"

  SCHEMA_PATH="$HOME/.local/share/gnome-shell/extensions/$ext/schemas"
  if [ -d "$SCHEMA_PATH" ]; then
    glib-compile-schemas "$SCHEMA_PATH"
  fi
done

# Ubuntu Dock
gnome-extensions enable ubuntu-dock@ubuntu.com

# Ubuntu Appindicators
gnome-extensions disable ubuntu-appindicators@ubuntu.com

# Ubuntu Tiling Assistant
gnome-extensions enable tiling-assistant@ubuntu.com

# Desktop Icons NG (DING)
gnome-extensions disable ding@rastersoft.com

# Enable extensions
for ext in "${EXT_IDS[@]}"; do
  EXTENSION_DIR="$HOME/.local/share/gnome-shell/extensions/$ext"
  if [ ! -d "$EXTENSION_DIR" ]; then
    echo "Extension $ext not found in $EXTENSION_DIR"
    continue
  fi
  gnome-extensions enable "$ext"
done

# Create User Themes directory
mkdir -p "$HOME/.themes"
mkdir -p "$HOME/.local/share/icons" # for KDE
