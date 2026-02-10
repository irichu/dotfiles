#!/usr/bin/env bash

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

#--------------------------------------------------
# Compiz alike magic lamp effect
#--------------------------------------------------

dconf write /org/gnome/shell/extensions/ncom/github/hermes83/compiz-alike-magic-lamp-effect/effect "'default'"
dconf write /org/gnome/shell/extensions/ncom/github/hermes83/compiz-alike-magic-lamp-effect/duration 250.0
dconf write /org/gnome/shell/extensions/ncom/github/hermes83/compiz-alike-magic-lamp-effect/x-tiles 8.0
dconf write /org/gnome/shell/extensions/ncom/github/hermes83/compiz-alike-magic-lamp-effect/y-tiles 8.0

#--------------------------------------------------
# Compiz windows effect
#--------------------------------------------------

dconf write /org/gnome/shell/extensions/com/github/hermes83/compiz-windows-effect/friction 7.5
dconf write /org/gnome/shell/extensions/com/github/hermes83/compiz-windows-effect/spring-k 7.5
dconf write /org/gnome/shell/extensions/com/github/hermes83/compiz-windows-effect/speedup-factor-divider 6.0
dconf write /org/gnome/shell/extensions/com/github/hermes83/compiz-windows-effect/mass 70.0

dconf write /org/gnome/shell/extensions/com/github/hermes83/compiz-windows-effect/x-tiles 5.0
dconf write /org/gnome/shell/extensions/com/github/hermes83/compiz-windows-effect/y-tiles 5.0

dconf write /org/gnome/shell/extensions/com/github/hermes83/compiz-windows-effect/maximize-effect true
dconf write /org/gnome/shell/extensions/com/github/hermes83/compiz-windows-effect/resize-effect true

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
# WSMatrix
#--------------------------------------------------

# General
dconf write /org/gnome/shell/extensions/wsmatrix/num-columns 3
dconf write /org/gnome/shell/extensions/wsmatrix/num-rows 2
dconf write /org/gnome/shell/extensions/wsmatrix/wraparound-mode "'next-previous'"

# Popup
dconf write /org/gnome/shell/extensions/wsmatrix/popup-timeout 500
dconf write /org/gnome/shell/extensions/wsmatrix/scale 0.8
dconf write /org/gnome/shell/extensions/wsmatrix/enable-popup-workspace-hover false
dconf write /org/gnome/shell/extensions/wsmatrix/show-thumbnails true
dconf write /org/gnome/shell/extensions/wsmatrix/show-workspace-names false

# Overview
dconf write /org/gnome/shell/extensions/wsmatrix/show-overview-grid true
