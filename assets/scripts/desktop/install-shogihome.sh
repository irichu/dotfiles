#!/usr/bin/env bash

cd "$HOME/.cache/dotfiles/"

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

USER_REPO="sunfish-shogi/shogihome"

LATEST_VERSION=$(curl -w "%{redirect_url}" -s -o /dev/null "https://github.com/$USER_REPO/releases/latest" | grep -oP '\d+\.\d+\.\d+$')
echo "Latest version: $LATEST_VERSION"
wget "https://github.com/${USER_REPO}/releases/download/v${LATEST_VERSION}/release-v${LATEST_VERSION}-linux.zip"

unzip "release-v${LATEST_VERSION}-linux.zip" -d shogihome_temp
sudo mv shogihome_temp/"ShogiHome-v${LATEST_VERSION}.AppImage" /usr/local/bin/ShogiHome
sudo chmod +x /usr/local/bin/ShogiHome
rm -rf shogihome_temp
rm "release-v${LATEST_VERSION}-linux.zip"

# Create shogi directory
SHOGI_DIR="$HOME/Documents/shogi2"
mkdir -p "$SHOGI_DIR"
cd "$SHOGI_DIR"

# Install YaneuraOu engine
git clone https://github.com/yaneurao/YaneuraOu.git
cd YaneuraOu

cd source

# Build dependencies
sudo apt install -y build-essential clang lld libopenblas-dev unzip zip p7zip-full

# Install eval file
wget https://github.com/nodchip/tanuki-/releases/download/tanuki-.halfkp_256x2-32-32.2023-05-08/tanuki-.halfkp_256x2-32-32.2023-05-08.7z
7z x tanuki-.halfkp_256x2-32-32.2023-05-08.7z -y

# make
make

cd -
