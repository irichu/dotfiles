#!/bin/bash

#--------------------------------------------------
# Tophat
#--------------------------------------------------

# General
dconf write /org/gnome/shell/extensions/tophat/meter-fg-color "'rgb(87,227,137)'"
dconf write /org/gnome/shell/extensions/tophat/show-icons false

# CPU
dconf write /org/gnome/shell/extensions/tophat/show-cpu true
dconf write /org/gnome/shell/extensions/tophat/cpu-display "'both'"
dconf write /org/gnome/shell/extensions/tophat/cpu-show-cores true

# MEM
dconf write /org/gnome/shell/extensions/tophat/show-mem true
dconf write /org/gnome/shell/extensions/tophat/mem-display "'both'"

# DISK
dconf write /org/gnome/shell/extensions/tophat/show-disk false
dconf write /org/gnome/shell/extensions/tophat/disk-display "'both'"

# NET
dconf write /org/gnome/shell/extensions/tophat/show-net true

#--------------------------------------------------
# Blur my Shell
#--------------------------------------------------

# Dock
dconf write /org/gnome/shell/extensions/blur-my-shell/dash-to-dock/blur true
dconf write /org/gnome/shell/extensions/blur-my-shell/dash-to-dock/brightness 0.8
dconf write /org/gnome/shell/extensions/blur-my-shell/dash-to-dock/customize true
dconf write /org/gnome/shell/extensions/blur-my-shell/dash-to-dock/sigma 160
dconf write /org/gnome/shell/extensions/blur-my-shell/dash-to-dock/override-background true
dconf write /org/gnome/shell/extensions/blur-my-shell/dash-to-dock/unblur-in-overview true

# Panel
dconf write /org/gnome/shell/extensions/blur-my-shell/panel/blur true
dconf write /org/gnome/shell/extensions/blur-my-shell/panel/static-blur true
dconf write /org/gnome/shell/extensions/blur-my-shell/panel/customize true
dconf write /org/gnome/shell/extensions/blur-my-shell/panel/brightness 0.8
dconf write /org/gnome/shell/extensions/blur-my-shell/panel/sigma 160

# Overview
dconf write /org/gnome/shell/extensions/blur-my-shell/overview/blur true
dconf write /org/gnome/shell/extensions/blur-my-shell/overview/brightness 0.8
dconf write /org/gnome/shell/extensions/blur-my-shell/overview/customize true
dconf write /org/gnome/shell/extensions/blur-my-shell/overview/sigma 160
