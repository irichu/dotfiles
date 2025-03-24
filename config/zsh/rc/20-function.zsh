#!/usr/bin/env zsh

# functions

# utils
function cdls() {
  \cd $1 && ls -l
}

function mkdircd() {
  mkdir -p $1 && cd $_
}

function killport() {
  if [[ -z "$1" ]]; then
    echo "Usage: killport <port>"
    return 1
  fi

  local pids
  pids=$(lsof -i:"$1" -t)

  if [[ -z "$pids" ]]; then
    echo "No process found on port $1"
    return 1
  fi

  echo "Killing processes on port $1: $pids"
  echo "$pids" | xargs kill -9
}

function print_xdg_env() {
  local xdg_envs=(
    XDG_CACHE_HOME
    XDG_CONFIG_DIRS
    XDG_CONFIG_HOME
    XDG_CURRENT_DESKTOP
    XDG_DATA_DIRS
    XDG_DATA_HOME
    XDG_MENU_PREFIX
    XDG_RUNTIME_DIR
    XDG_SESSION_CLASS
    XDG_SESSION_DESKTOP
    XDG_SESSION_TYPE
    XDG_STATE_HOME
  )

  for env in ${xdg_envs[@]}; do
    echo "$env=$(printenv $env)"
  done
}

function print_proxy_env() {
  local proxy_envs=(
    HTTPS_PROXY
    HTTP_PROXY
    FTP_PROXY
    NO_PROXY
    https_proxy
    http_proxy
    ftp_proxy
    no_proxy
  )

  for env in ${proxy_envs[@]}; do
    echo "$env=$(printenv $env)"
  done
}

# tmux
function tvim() {
  tmux split-window -v
  tmux split-window -h
  tmux resize-pane -D 15
  tmux select-pane -t 1

  fdfind --type f --hidden --exclude .git | fzf-tmux -p | xargs -o nvim
}

function confirm {
  echo -n "$1 [y/N]: "
  read -q
  return $?
}

# yazi shell wrappers
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# bat
help() {
  "$@" --help 2>&1 | bathelp
}
