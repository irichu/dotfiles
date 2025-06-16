#!/bin/bash

# Interface
dconf write /org/gnome/desktop/interface/icon-theme "'Yaru-purple'"
dconf write /org/gnome/desktop/interface/gtk-theme "'Yaru-purple-dark'"

# Workspace
dconf write /org/gnome/mutter/dynamic-workspaces false
dconf write /org/gnome/desktop/wm/preferences/num-workspaces 6

# Background
[ -f /usr/share/backgrounds/Mirror_by_Uday_Nakade.jpg ] &&
  dconf write /org/gnome/desktop/background/picture-uri-dark "'file:///usr/share/backgrounds/Mirror_by_Uday_Nakade.jpg'"

# Dock
dconf write /org/gnome/shell/extensions/dash-to-dock/dock-fixed true
dconf write /org/gnome/shell/extensions/dash-to-dock/dock-position "'LEFT'"
dconf write /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size 32
dconf write /org/gnome/shell/extensions/dash-to-dock/show-favorites true
dconf write /org/gnome/shell/extensions/dash-to-dock/show-mounts false
dconf write /org/gnome/shell/extensions/dash-to-dock/show-mounts-network false
dconf write /org/gnome/shell/extensions/dash-to-dock/show-mounts-only-mounted false
dconf write /org/gnome/shell/extensions/dash-to-dock/show-running true
dconf write /org/gnome/shell/extensions/dash-to-dock/show-trash true
