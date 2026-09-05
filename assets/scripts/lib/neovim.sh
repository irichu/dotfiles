#!/usr/bin/env bash

# Keep staging and its cleanup local to this install, including on failure.
install_neovim_release() (
  local staging archive extracted
  staging=$(mktemp -d) || return 1
  trap 'rm -rf -- "$staging"' EXIT
  archive="$staging/neovim.tar.gz"
  extracted="$staging/nvim-linux-${ARCH_GH}"

  wget -O "$archive" "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-${ARCH_GH}.tar.gz" || return 1
  tar -zxf "$archive" -C "$staging" || return 1

  # Validate the new release before touching the installed copy.
  if [ ! -f "$extracted/bin/nvim" ] ||
    [ ! -d "$extracted/lib/nvim" ] ||
    [ ! -d "$extracted/share/nvim" ]; then
    error "Neovim release is missing its binary, libraries, or runtime."
    return 1
  fi

  sudo mkdir -p /usr/bin /usr/lib /usr/share || return 1
  # Replace whole directories: merging would leave obsolete runtime files.
  sudo rm -rf -- /usr/lib/nvim /usr/share/nvim || return 1
  sudo mv -T -- "$extracted/lib/nvim" /usr/lib/nvim || return 1
  sudo mv -T -- "$extracted/share/nvim" /usr/share/nvim || return 1
  sudo install -m 755 -- "$extracted/bin/nvim" /usr/bin/nvim || return 1
)
