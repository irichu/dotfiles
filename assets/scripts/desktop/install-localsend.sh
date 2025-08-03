#!/usr/bin/env bash

cd "$HOME/.cache/dotfiles/"

ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
  ARCH="x86-64"
elif [ "$ARCH" = "aarch64" ]; then
  ARCH="arm64"
fi
if [ "$ARCH" != "x86-64" ] && [ "$ARCH" != "arm64" ]; then
  echo "Unsupported architecture: $ARCH"
  exit 1
fi

# (API)
# LATEST_VERSION=$(curl -s "https://api.github.com/repos/localsend/localsend/releases/latest" | grep -oP '"tag_name": "v\K[^"]+')
# Redirect URL
LATEST_VERSION=$(curl -w "%{redirect_url}" -s -o /dev/null "https://github.com/localsend/localsend/releases/latest" | grep -oP '\d+\.\d+\.\d+$')
wget "https://github.com/localsend/localsend/releases/latest/download/LocalSend-${LATEST_VERSION}-linux-${ARCH}.deb"
sudo apt install -y "./LocalSend-${LATEST_VERSION}-linux-${ARCH}.deb"
rm "./LocalSend-${LATEST_VERSION}-linux-${ARCH}.deb"

cd -
