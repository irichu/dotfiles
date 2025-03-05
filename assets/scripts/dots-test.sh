#!/usr/bin/env bash

set -ue
set -o pipefail

export LC_ALL=C

# apt test
dots install --apt

# install test
dots install apt-packages
dots install fnm
dots install fzf
dots install hackgen
dots install docker
dots install lazydocker
dots install lazygit
dots install lazyvim
dots install neovim
dots install rustup
dots install starship

# setup test
dots setup git
dots setup tmux
dots setup zellij
dots setup zsh
dots apply

# update test
dots up
dots update
dots upgrade

# clean test
dots clean
dots clean config
dots clean backup
dots clean all

# list test
dots ls apt
dots ls pkg
dots ls snap
dots ls brew

dots list apt
dots list pkg
dots list snap
dots list brew

# help test
dots help

# version test
dots version
