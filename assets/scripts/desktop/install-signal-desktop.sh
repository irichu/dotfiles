#!/usr/bin/env bash

# Debian-based
# https://signal.org/download/linux/

cd "$HOME/.cache/dotfiles/"

# Install our official public software signing key
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg;
cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

# Add repository to the list of repositories:
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
  sudo tee /etc/apt/sources.list.d/signal-xenial.list

# Update your package database and install Signal
sudo apt update
sudo apt -y install signal-desktop

rm "./signal-desktop-keyring.gpg"

cd -
