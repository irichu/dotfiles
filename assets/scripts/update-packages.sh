#!/usr/bin/env bash

cmd_exists() {
  command -v "$1" &>/dev/null
}

#--------------------------------------------------
# apt
#--------------------------------------------------

if cmd_exists apt; then
  if [ -z "${TERMUX_VERSION}" ]; then
    sudo apt update && sudo apt upgrade -y
  else
    apt update && apt upgrade -y
  fi
fi

#--------------------------------------------------
# pkg
#--------------------------------------------------

# if cmd_exists pkg; then
#   pkg up -y
# fi

#--------------------------------------------------
# snap
#--------------------------------------------------

if cmd_exists snap; then
  sudo snap refresh
fi

#--------------------------------------------------
# brew
#--------------------------------------------------

if cmd_exists brew; then
  brew update
  brew upgrade
fi

#--------------------------------------------------
# rustup
#--------------------------------------------------

if cmd_exists rustup; then
  rustup update stable
fi
