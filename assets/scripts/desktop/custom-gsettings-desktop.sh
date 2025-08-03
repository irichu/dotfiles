#!/bin/bash

# Interface
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-purple'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-purple-dark'
gsettings set org.gnome.desktop.interface font-name 'Ubuntu Sans 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Sans Mono 13'

# Background
[ -f /usr/share/backgrounds/Mirror_by_Uday_Nakade.jpg ] &&
  gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/Mirror_by_Uday_Nakade.jpg'

[ -f /usr/share/backgrounds/Northan_lights_by_mizuno.webp ] &&
  gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/Northan_lights_by_mizuno.webp'

# Window
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

# Workspace
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 6

# Ubuntu Dock (dash-to-dock)
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'LEFT'
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32

gsettings set org.gnome.shell.extensions.dash-to-dock show-favorites true
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-network false
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-only-mounted false
gsettings set org.gnome.shell.extensions.dash-to-dock show-running true
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash true
# gsettings get org.gnome.desktop.interface icon-theme
# gsettings get org.gnome.desktop.interface gtk-theme
# gsettings get org.gnome.mutter dynamic-workspaces
# gsettings get org.gnome.desktop.wm.preferences num-workspaces

# Favorite apps
gsettings set org.gnome.shell favorite-apps "[\
  'google-chrome.desktop',\
  'firefox_firefox.desktop',\
  'thunderbird_thunderbird.desktop',\
  'org.gnome.Nautilus.desktop',\
  'gimp_gimp.desktop',\
  'pinta_pinta.desktop',\
  'vlc.desktop',\
  'code.desktop',\
  'code-insiders.desktop',\
  'alacritty_alacritty.desktop',\
  'obsidian.desktop',\
  'Waydroid.desktop',\
  'localsend_app.desktop',\
  'signal-desktop.desktop',\
  'rustdesk.desktop',\
  'zoom-client_zoom-client.desktop',\
  'org.gnome.Settings.desktop',\
  'gnome-control-center.desktop'\
]"

# Mouse
gsettings set org.gnome.desktop.peripherals.mouse natural-scroll false
gsettings set org.gnome.desktop.peripherals.mouse speed 1.0

# Files
gsettings set org.gtk.Settings.FileChooser sort-directories-first true
gsettings set org.gtk.Settings.FileChooser sort-order 'ascending'
gsettings set org.gtk.Settings.FileChooser show-hidden true
