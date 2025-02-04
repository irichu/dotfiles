#!/bin/bash

SCRIPT_DIR=$(
  cd $(dirname $BASH_SOURCE)
  pwd
)

source "$SCRIPT_DIR/window-status.sh"
