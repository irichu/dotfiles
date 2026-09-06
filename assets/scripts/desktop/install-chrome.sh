#!/usr/bin/env bash

# shellcheck source=assets/scripts/lib/apt.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/apt.sh"

set -Eeuo pipefail

cd "$HOME/.cache/dotfiles/"

wget -O google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dots_apt_get install -y ./google-chrome-stable_current_amd64.deb
xdg-settings set default-web-browser google-chrome.desktop
rm google-chrome-stable_current_amd64.deb

cd -
