#!/bin/bash

# Create User Themes directory
mkdir -p "$HOME/.themes"
mkdir -p "$HOME/.icons"
mkdir -p "$HOME/.local/share/icons" # for KDE

CACHE_DIR="$HOME/.cache/dotfiles"
mkdir -p "$CACHE_DIR"

# Shell Theme
cd "$CACHE_DIR"
[ ! -d Marble-shell-theme ] &&
  git clone --depth=1 https://github.com/imarkoff/Marble-shell-theme.git
cd Marble-shell-theme

python3 install.py --blue

# gsettings set org.gnome.shell.extensions.user-theme name "Marble-blue-dark"
dconf write /org/gnome/shell/extensions/user-theme/name "'Marble-blue-dark'"

# GTK Theme
cd "$CACHE_DIR"
[ ! -d Flat-Remix-GTK ] &&
  git clone --depth=1 https://github.com/daniruiz/Flat-Remix-GTK.git
cd Flat-Remix-GTK/themes/Flat-Remix-GTK-Blue-Dark-Solid/

bash install.sh
# gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-GTK-Blue-Dark-Solid"

# Icon Theme
cd "$CACHE_DIR"
[ ! -d Flat-Remix ] &&
  git clone --depth=1 https://github.com/daniruiz/Flat-Remix.git
cd Flat-Remix

cp -r Flat-Remix-Blue-Dark/ "$HOME/.icons/"
#gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Blue-Dark"
dconf write /org/gnome/desktop/interface/icon-theme "'Flat-Remix-Blue-Dark'"
