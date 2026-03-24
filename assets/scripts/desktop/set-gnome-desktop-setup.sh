#!/usr/bin/env bash

SCRIPT_DIR=$(
  cd "$(dirname "${BASH_SOURCE:-$0}")"
  pwd
)

echo "$SCRIPT_DIR"

"$SCRIPT_DIR/"install-gnome-extensions.sh
