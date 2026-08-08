#!/usr/bin/env bash

ARCH="$(uname -m)"

cd "$HOME/.cache/dotfiles/"

LATEST_VERSION=$(curl -w "%{redirect_url}" -s -o /dev/null "https://github.com/obsidianmd/obsidian-releases/releases/latest" | grep -oP '\d+\.\d+\.\d+$')

if [[ "$ARCH" == "x86_64" ]]; then
  ARCH="amd64"
  wget "https://github.com/obsidianmd/obsidian-releases/releases/latest/download/obsidian_${LATEST_VERSION}_${ARCH}.deb"
  sudo apt install -y "./obsidian_${LATEST_VERSION}_${ARCH}.deb"
  rm "./obsidian_${LATEST_VERSION}_${ARCH}.deb"
elif [[ "$ARCH" == "aarch64" ]]; then
  ARCH="arm64"

  # Install AppImage dependencies
  sudo apt update

  # Get the current Ubuntu version
  ubuntu_version=$(lsb_release -r | awk '{print $2}')

  # Check if the version is 24.04 or higher
  if [[ "$(echo -e "$ubuntu_version\n24.04" | sort -V | head -n 1)" == "24.04" ]]; then
    echo "Ubuntu is 24.04 or higher."
    sudo apt install -y libfuse2t64
  else
    echo "Ubuntu is lower than 24.04."
    sudo apt install -y libfuse2
  fi

  wget "https://github.com/obsidianmd/obsidian-releases/releases/latest/download/Obsidian-${LATEST_VERSION}-${ARCH}.AppImage"
  chmod +x "Obsidian-${LATEST_VERSION}-${ARCH}.AppImage"
  ./Obsidian-${LATEST_VERSION}-${ARCH}.AppImage --appimage-extract
  cp -rf squashfs-root/usr/share/icons "$HOME/.local/share"
  mv "Obsidian-${LATEST_VERSION}-${ARCH}.AppImage" "$HOME/.local/bin/obsidian"
  rm -rf squashfs-root

else
  echo "Unsupported architecture: $ARCH"
  exit 1
fi

cd -
