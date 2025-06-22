#!/bin/bash

SCRIPT_DIR=$(
  cd "$(dirname "${BASH_SOURCE:-$0}")"
  pwd
)

cat "$SCRIPT_DIR/code-extensions.txt" | while read extension; do echo "Install $extension ..." && code --install-extension "$extension"; done
