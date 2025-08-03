#!/usr/bin/env bash

cd "$HOME/.cache/dotfiles/"

LATEST_VERSION=$(curl -w "%{redirect_url}" -s -o /dev/null "https://github.com/obsidianmd/obsidian-releases/releases/latest" | grep -oP '\d+\.\d+\.\d+$')
wget "https://github.com/obsidianmd/obsidian-releases/releases/latest/download/obsidian_${LATEST_VERSION}_amd64.deb"
sudo apt install -y "./obsidian_${LATEST_VERSION}_amd64.deb"
rm "./obsidian_${LATEST_VERSION}_amd64.deb"

cd -
