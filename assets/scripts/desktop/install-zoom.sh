#!/usr/bin/env bash

set -Eeuo pipefail

if ! command -v snap >/dev/null 2>&1; then
  echo "snap command not found." >&2
  exit 1
fi

if snap list zoom-client >/dev/null 2>&1; then
  echo "Zoom is already installed from Snap."
  exit 0
fi

sudo snap install zoom-client
