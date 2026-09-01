#!/usr/bin/env bash

set -Eeuo pipefail

# Debian-based
# https://signal.org/download/linux/

ARCH="$(uname -m)"
#readonly ARCH

if [[ "$ARCH" == "x86_64" ]]; then
  ARCH="amd64"
elif [[ "$ARCH" == "aarch64" ]]; then
  ARCH="arm64"
  echo "Signal Desktop is not officially supported on ARM64 architecture."
  echo "You can try installing it via Snap:"
  echo "  sudo snap install signal-desktop"
  exit 1
else
  echo "Unsupported architecture: $ARCH"
  exit 1
fi

cd "$HOME/.cache/dotfiles/"

# Install our official public software signing key
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg;
cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

# Add repository to the list of repositories:
echo "deb [arch=$ARCH signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main" |\
  sudo tee /etc/apt/sources.list.d/signal-xenial.list

# Update your package database and install Signal
sudo apt update
sudo apt -y install signal-desktop

rm "./signal-desktop-keyring.gpg"

cd -
