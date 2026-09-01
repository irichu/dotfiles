#!/usr/bin/env bash

set -Eeuo pipefail

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles"
archive="$cache_dir/M_PLUS_2.zip"
font_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/M_PLUS_2"
mkdir -p "$cache_dir" "$font_dir"

# Download the latest M+ 2 font release
curl -fL --retry 3 -o "$archive" https://github.com/irichu/dotfiles/releases/download/v0.7.0/M_PLUS_2.zip

# Unzip the downloaded font
unzip -o "$archive" -d "$font_dir"

# Clean up the downloaded zip file
rm -f "$archive"

# Update only the user's font cache. A global refresh can fail when an
# unprivileged user encounters system font directories.
fc-cache -f "${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
