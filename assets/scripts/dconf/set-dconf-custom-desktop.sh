#!/bin/bash

# Interface
dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
dconf write /org/gnome/desktop/interface/icon-theme "'Yaru-purple'"
dconf write /org/gnome/desktop/interface/gtk-theme "'Yaru-purple-dark'"

# Font
# 22.04 LTS
# dconf write /org/gnome/desktop/interface/font-name "'Ubuntu 11'"
# dconf write /org/gnome/desktop/interface/monospace-font-name "'Ubuntu Mono 12'"

# 24.04 LTS
# dconf write /org/gnome/desktop/interface/font-name "'Ubuntu Sans 10.5'"
# dconf write /org/gnome/desktop/interface/monospace-font-name "'Ubuntu Sans Mono 12'"
# dconf write /org/gnome/desktop/interface/font-name "'Noto Sans CJK JP 10'"
# dconf write /org/gnome/desktop/interface/monospace-font-name "'Noto Sans Mono CJK JP 12'"

# Custom
# dconf write /org/gnome/desktop/interface/font-name "'HackGen35 Console NF 11'"
# dconf write /org/gnome/desktop/interface/monospace-font-name "'HackGen35 Console NF 11'"

# Workspace
dconf write /org/gnome/mutter/dynamic-workspaces false
dconf write /org/gnome/desktop/wm/preferences/num-workspaces 6

# Background
[ -f /usr/share/backgrounds/Mirror_by_Uday_Nakade.jpg ] &&
  dconf write /org/gnome/desktop/background/picture-uri-dark "'file:///usr/share/backgrounds/Mirror_by_Uday_Nakade.jpg'"

[ -f /usr/share/backgrounds/Northan_lights_by_mizuno.webp ] &&
  dconf write /org/gnome/desktop/background/picture-uri-dark "'file:///usr/share/backgrounds/Northan_lights_by_mizuno.webp'"

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
