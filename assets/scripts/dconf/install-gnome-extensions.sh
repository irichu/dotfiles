#!/bin/bash

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
)

# Install gnome-extensions-cli
if [ ! -f "$HOME/.local/bin/gext" ]; then
  pip install gnome-extensions-cli
fi

# Install and enable extensions
for ext in "${EXT_IDS[@]}"; do
  "$HOME/.local/bin/"gext install "$ext"
  gnome-extensions enable "$ext"
done

# Ubuntu Dock
gnome-extensions enable ubuntu-dock@ubuntu.com
