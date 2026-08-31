#!/usr/bin/env bash

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
ZSH_COMPLETIONS_DIR="${ZSH_COMPLETIONS_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/zsh/completions}"
ZSH_COMPDUMP_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump"
mkdir -p "$ZSH_COMPLETIONS_DIR"

cmd_exists() {
  command -v "$1" &>/dev/null
}

generate_completions() {
  # bat
  if cmd_exists bat; then
    bat --completion zsh > "${ZSH_COMPLETIONS_DIR}/_bat"
  fi

  # fnm
  if cmd_exists fnm; then
    fnm completions --shell zsh > "${ZSH_COMPLETIONS_DIR}/_fnm"
  fi

  # gum
  if cmd_exists gum; then
    gum completion zsh > "${ZSH_COMPLETIONS_DIR}/_gum"
  fi

  # jj
  if cmd_exists jj; then
    jj util completion zsh > "${ZSH_COMPLETIONS_DIR}/_jj"
  fi

  # mise
  if cmd_exists mise; then
    # mise plugin install usage
    if ! cmd_exists usage; then
      mise use -g usage
    fi

    mise completion zsh > "${ZSH_COMPLETIONS_DIR}/_mise"
  fi

  # rustup and cargo
  if cmd_exists rustup; then
    # rustup
    rustup completions zsh >"${ZSH_COMPLETIONS_DIR}/_rustup"

    # cargo
    rustup completions zsh cargo >"${ZSH_COMPLETIONS_DIR}/_cargo"
  fi

  # uv
  if cmd_exists uv; then
    uv generate-shell-completion zsh > "${ZSH_COMPLETIONS_DIR}/_uv"
  fi

  # zellij
  if cmd_exists zellij; then
    zellij setup --generate-completion zsh > "${ZSH_COMPLETIONS_DIR}/_zellij"
  fi

  return 0
}

generate_completions

# Regenerate zsh completion dump file
if [ -f "$ZSH_COMPDUMP_FILE" ]; then
  rm "$ZSH_COMPDUMP_FILE" >/dev/null 2>&1
fi
if cmd_exists zsh; then
  ZSH_COMPDUMP_FILE="$ZSH_COMPDUMP_FILE" \
    zsh -c 'autoload -Uz compinit && compinit -d "$ZSH_COMPDUMP_FILE"' >/dev/null 2>&1
fi
