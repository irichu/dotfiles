#!/usr/bin/env bash

cd "$HOME/.cache/dotfiles/"

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
xdg-settings set default-web-browser google-chrome.desktop
rm google-chrome-stable_current_amd64.deb

cd -
