#!/bin/bash

#--------------------------------------------------
# Tophat
#--------------------------------------------------

# Genaral
gsettings set org.gnome.shell.extensions.tophat meter-fg-color 'rgb(87,227,137)'
gsettings set org.gnome.shell.extensions.tophat show-icons false

# CPU
gsettings set org.gnome.shell.extensions.tophat show-cpu true
gsettings set org.gnome.shell.extensions.tophat cpu-display 'both'
gsettings set org.gnome.shell.extensions.tophat cpu-show-cores true

# MEM
gsettings set org.gnome.shell.extensions.tophat show-mem true
gsettings set org.gnome.shell.extensions.tophat mem-display 'both'

# DISK
gsettings set org.gnome.shell.extensions.tophat show-disk false
gsettings set org.gnome.shell.extensions.tophat disk-display 'both'

# NET
gsettings set org.gnome.shell.extensions.tophat show-net true

#--------------------------------------------------
# Blur my Shell
#--------------------------------------------------

# Dash to Dock
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock brightness 0.8
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock customize true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock sigma 160
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock override-background true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock unblur-in-overview true

# Panel
gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.panel static-blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.panel customize true
gsettings set org.gnome.shell.extensions.blur-my-shell.panel brightness 0.8
gsettings set org.gnome.shell.extensions.blur-my-shell.panel sigma 160

# Overview
gsettings set org.gnome.shell.extensions.blur-my-shell.overview blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.overview brightness 0.8
gsettings set org.gnome.shell.extensions.blur-my-shell.overview customize true
gsettings set org.gnome.shell.extensions.blur-my-shell.overview sigma 160
