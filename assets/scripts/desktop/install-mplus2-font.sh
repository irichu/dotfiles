#!/usr/bin/env bash

cd "$HOME/.cache/dotfiles/"

# Download the latest M+ 2 font release
wget https://github.com/irichu/dotfiles/releases/download/v0.7.0/M_PLUS_2.zip

# Create the directory for the M+ 2 font if it doesn't exist
mkdir -p "$HOME/.local/share/fonts/M_PLUS_2"

# Unzip the downloaded font
unzip -o M_PLUS_2.zip -d "$HOME/.local/share/fonts/M_PLUS_2"

# Clean up the downloaded zip file
rm M_PLUS_2.zip

# Update the font cache
fc-cache -f

# Return to the previous directory
cd -
