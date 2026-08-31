#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_ID="org.gimp.GIMP"

bash "$SCRIPT_DIR/install-flatpak.sh"

if flatpak info --system "$APP_ID" >/dev/null 2>&1; then
  echo "GIMP is already installed from Flatpak."
  exit 0
fi

if ! flatpak remote-info --system flathub "$APP_ID" >/dev/null 2>&1; then
  echo "GIMP ($APP_ID) is not available from Flathub for this system." >&2
  exit 1
fi

sudo flatpak install --system -y flathub "$APP_ID"
