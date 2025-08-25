#!/usr/bin/env bash

# Install AppImageLauncher dependencies
sudo apt install libfuse2t64

USER_REPO="TheAssassin/AppImageLauncher"

LATEST_VERSION=$(curl -w "%{redirect_url}" -s -o /dev/null "https://github.com/$USER_REPO/releases/latest" | grep -oP '\d+\.\d+\.\d+$')
echo "Latest version: $LATEST_VERSION"
wget "https://github.com/TheAssassin/AppImageLauncher/releases/download/v${LATEST_VERSION}/appimagelauncher_${LATEST_VERSION}-travis995.0f91801.bionic_amd64.deb"

# Build dependencies
sudo apt install clang lld

# Install shogi engine
