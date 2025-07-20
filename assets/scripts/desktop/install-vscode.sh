#!/bin/bash

# Debian-based
if command -v apt-get &> /dev/null; then
  echo "Detected Debian-based system. Proceeding with installation..."

  # Install Visual Studio Code on Debian-based systems
  sudo apt-get update
  sudo apt-get -y install wget gpg

  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
  rm -f packages.microsoft.gpg

  sudo apt-get -y install apt-transport-https
  sudo apt-get update

  # Install Visual Studio Code and its insiders version
  sudo apt-get -y install code
  sudo apt-get -y install code-insiders

# Red Hat-based
elif command -v dnf &> /dev/null; then
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

  dnf check-update
  sudo dnf install code # or code-insiders

# Arch-based
elif command -v pacman &> /dev/null; then
  sudo pacman -Syyu --noconfirm
  git clone https://AUR.archlinux.org/visual-studio-code-bin.git
  cd visual-studio-code-bin || exit 1
  makepkg -s
  sudo pacman -U visual-studio-code-bin-*.pkg.tar.zst --noconfirm
  cd ..
  rm -rf visual-studio-code-bin

else
  echo "This script is intended for apt, dnf, pacman management system."
  exit 1
fi
