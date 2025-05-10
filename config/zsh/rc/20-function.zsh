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

get_theme() {
  # get theme
  CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
  CONFIG_FILE="$CONFIG_HOME/tmux/script/config.sh"

  # check if config file exists
  if [[ ! -f "$CONFIG_FILE" ]]; then
    error "Error: Config file '$CONFIG_FILE' not found." >&2
    exit 1
  fi

  # get theme value
  theme=$(grep -E '^THEME=' "$CONFIG_FILE" | grep -oE '".*"' || true)

  # check if theme value exists
  if [[ -z "$theme" ]]; then
    error "Error: 'THEME=' not found or has no value in '$CONFIG_FILE'." >&2
    exit 1
  fi

  echo "$theme" | tr -d '"'

  return 0
}

function get_theme_color() {
  theme=$(get_theme)
  case "${theme:-}" in
  *developer*) echo "#8787ff" ;;
  *turquoise*) echo "#00d7d7" ;;
  *orange*) echo "#ffaf00" ;;
  *blue*) echo "#87afff" ;;
  *) echo "#8787ff" ;;
  esac
}

function confirm {
  if command -v gum &>/dev/null; then
    gum confirm --selected.background=$(get_theme_color || echo "#8787ff") "$1"
  else
    echo -n "$1 [y/N]: "
    read -q
  fi

  return $?
}

# markdown
function pmd() {
  if [ -f "${1:-}" ]; then
    gum format -t markdown <"${1:-}"
    echo ''
  fi
}

# csv
function gcsv() {
  if [ -f "${1:-}" ]; then
    gum table <"${1:-}" | cut -d ',' -f "${2:-1}"
  fi
}

# tsv
function gtsv() {
  if [ -f "${1:-}" ]; then
    gum table --separator='	' <"${1:-}" | cut -d '	' -f "${2:-1}"
  fi
}

# pager
function gpager() {
  if [ -f "${1:-}" ]; then
    gum pager <"${1:-}"
  fi
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

# git
function git_remote_latest_tag_by_url() {
  local url="$1"

  if [[ -z "$url" ]]; then
    echo "Usage: git_romote_latest_tag_by_url <url>"
    return 1
  fi

  git -c 'versionsort.suffix=-' ls-remote --exit-code --refs --sort='version:refname' --tags "$url" '*.*.*' | tail -n1 | cut -d/ -f3
}

# ufw
function allow_from_ip_to_port() {
  local ip="$1" # IP address or CIDR range
  local port="$2"

  if [[ -z "$ip" ]]; then
    echo "Usage: allow_from_ip_to_port <ip> <port>"
    return 1
  fi

  if [[ -z "$port" ]]; then
    echo "Usage: allow_from_ip_to_port <ip> <port>"
    return 1
  fi

  sudo ufw allow from "$ip" to any port "$port"
}

# pip-audit
# https://pypi.org/project/pip-audit/
pip_audit() {
  local requirements_file="$1"

  if [[ -z "$requirements_file" ]]; then
    echo "Usage: pip_audit <requirements_file>"
    return 1
  fi

  local pip_audit_venv_dir="$HOME/.local/share/.pip-audit"

  # Create the virtual environment directory if it doesn't exist
  if [[ ! -f "$pip_audit_venv_dir"/bin/activate ]]; then
    python3 -m venv "$pip_audit_venv_dir"
  fi

  # Activate the virtual environment
  source "$pip_audit_venv_dir"/bin/activate

  # Upgrade pip
  if [[ ! -f "$pip_audit_venv_dir"/bin/pip ]]; then
    echo "pip installation failed."
    return 1
  fi
  pip install --upgrade pip

  # Install pip-audit if not already installed
  if [[ ! -f "$pip_audit_venv_dir"/bin/pip-audit ]]; then
    pip install pip-audit
  else
    pip install --upgrade pip-audit
  fi

  # Check if pip-audit is installed
  if [[ ! -f "$pip_audit_venv_dir"/bin/pip-audit ]]; then
    echo "pip-audit installation failed."
    return 1
  fi

  # Check if the requirements file exists and is readable
  if [[ ! -f "$requirements_file" ]]; then
    echo "Requirements file '$requirements_file' not found."
    return 1
  fi

  # Check if the requirements file is empty
  if [[ ! -s "$requirements_file" ]]; then
    echo "Requirements file '$requirements_file' is empty."
    return 1
  fi

  # Run pip-audit
  "$pip_audit_venv_dir"/bin/pip-audit -r "$requirements_file"

  # Deactivate the virtual environment
  deactivate
}
