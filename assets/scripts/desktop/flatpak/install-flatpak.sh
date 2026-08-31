#!/usr/bin/env bash

set -Eeuo pipefail

FLATHUB_URL="https://dl.flathub.org/repo/flathub.flatpakrepo"

if ! command -v flatpak >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y flatpak
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y flatpak
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm flatpak
  else
    echo "Unsupported package manager. Install Flatpak, then rerun this script." >&2
    exit 1
  fi

  hash -r
fi

if ! command -v flatpak >/dev/null 2>&1; then
  echo "Flatpak installation did not provide the flatpak command." >&2
  exit 1
fi

sudo flatpak remote-add --system --if-not-exists flathub "$FLATHUB_URL"

echo "Flatpak and the system Flathub remote are ready."
