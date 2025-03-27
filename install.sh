#!/usr/bin/env bash

set -ue
set -o pipefail

export LC_ALL=C

DEBUG=true

#--------------------------------------------------
# path
#--------------------------------------------------

SCRIPT_DIR=$(
  cd $(dirname ${BASH_SOURCE:-})
  pwd
)

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$CONFIG_HOME"

CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
CACHE_DIR="$CACHE_HOME/dotfiles"
mkdir -p "$CACHE_DIR"

STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
STATE_DIR="$STATE_HOME/dotfiles"
mkdir -p "$STATE_DIR"

DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
mkdir -p "$DATA_HOME"

DATA_DIR="$DATA_HOME/dotfiles-main"

# add path
LOCAL_PATH="$HOME/.local/bin"
mkdir -p $LOCAL_PATH

if [ -d "$LOCAL_PATH" ] && [[ ":$PATH:" != *":$LOCAL_PATH:"* ]]; then
  export PATH="$LOCAL_PATH:$PATH"
fi

#--------------------------------------------------
# logger
#--------------------------------------------------

COLOR_BLACK='\033[0;30m'
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[1;33m'
COLOR_BLUE='\033[0;34m'
COLOR_PURPLE='\033[0;35m'
COLOR_CYAN='\033[0;36m'
COLOR_WHITE='\033[1;37m'
COLOR_NONE='\033[0m'

COLOR_DEBUG=$COLOR_PURPLE
COLOR_INFO=$COLOR_BLUE
COLOR_NOTICE=$COLOR_CYAN
COLOR_WARNING=$COLOR_YELLOW
COLOR_ERROR=$COLOR_RED
COLOR_SUCCESS=$COLOR_GREEN

log_color() {
  LOG_LEVEL="$1"
  shift

  LOG_COLOR=$COLOR_WHITE
  case $LOG_LEVEL in
  DEBUG)
    LOG_COLOR=$COLOR_DEBUG
    ;;
  INFO)
    LOG_COLOR=$COLOR_INFO
    ;;
  NOTICE)
    LOG_COLOR=$COLOR_NOTICE
    ;;
  WARNING)
    LOG_COLOR=$COLOR_WARNING
    ;;
  ERROR)
    LOG_COLOR=$COLOR_ERROR
    ;;
  SUCCESS)
    LOG_COLOR=$COLOR_SUCCESS
    ;;
  esac

  local OPT=""
  local OPTS
  local OPTIND=1
  while getopts ":c:n:" OPTS; do
    # echo "$OPTS"
    case "$OPTS" in
    n)
      OPT=-n
      ;;
    c)
      case "$OPTARG" in
      c)
        LOG_COLOR=$COLOR_NOTICE
        ;;
      g)
        LOG_COLOR=$COLOR_SUCCESS
        ;;
      n)
        LOG_COLOR=$COLOR_NONE
        ;;
      w)
        LOG_COLOR=$COLOR_WHITE
        ;;
      esac
      ;;
    esac
  done

  shift $((OPTIND - 1))

  echo -e ${OPT:-} "$LOG_COLOR""$@""$COLOR_NONE"

  $DEBUG && echo "[$(log_date_str)][$LOG_LEVEL]" "$@" >>"$STATE_DIR/debug.log"
  [ $LOG_LEVEL = 'ERROR' ] && echo "[$(log_date_str)][$LOG_LEVEL]" "$@" >>"$STATE_DIR/errors.log"

  return 0
}

debug() {
  $DEBUG && log_color DEBUG "$1"
  return 0
}

info() {
  log_color INFO "$1" "${2:-}" "${3:-}"
}

notice() {
  log_color NOTICE "$1" "${2:-}"
}

warning() {
  log_color WARNING "$1" "${2:-}"
}

error() {
  log_color ERROR "$1" "${2:-}"
}

success() {
  log_color SUCCESS "$1" "${2:-}"
}

log() {
  LOG_LEVEL="$1"
  shift

  local OPTS
  if getopts ":n:" OPTS; then
    OPTS=-$OPTS
    shift
  else
    OPTS=""
  fi

  case "$LOG_LEVEL" in
  DEBUG)
    debug $OPTS "$@"
    ;;
  INFO)
    info $OPTS "$@"
    ;;
  NOTICE)
    notice $OPTS "$@"
    ;;
  WARNING)
    warning $OPTS "$@"
    ;;
  ERROR)
    error $OPTS "$@"
    ;;
  SUCCESS)
    success $OPTS "$@"
    ;;
  esac

  return 0
}

now_str() {
  date +'%Y%m%d-%H%M%S'
}

log_date_str() {
  date +'%Y-%m-%d %H:%M:%S.%3N'
}

#--------------------------------------------------
# utils
#--------------------------------------------------

cmd_exists() {
  command -v $1 &>/dev/null
}

#--------------------------------------------------
# backup
#--------------------------------------------------

backup_dir() {
  date_str=$(now_str)

  if [ -e "$1" ]; then
    info "Dir $1 already exists."

    if [ -L "$1" ]; then
      info "Unlink ... "
      unlink "$1"

      return 0
    fi

    info "Rename ... "

    mv "$1"{,.bak$date_str}

    info "Renamed to $1.bk$date_str"

    return 0
  fi

  return 0
}

#--------------------------------------------------
# intall
#--------------------------------------------------

# Function to install the 'gum' utility, which is used for interactive shell scripts.
install_gum() {
  info "Start: ${FUNCNAME[0]}"

  if cmd_exists gum; then
    info "gum already installed."
    return 0
  fi

  if cmd_exists apt; then
    if [ -n "${TERMUX_VERSION:-}" ]; then
      # termux
      pkg install gum -y
    else
      # ubuntu debian
      sudo mkdir -p /etc/apt/keyrings
      curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
      echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
      sudo apt update && sudo apt install gum -y
    fi

  elif cmd_exists dnf; then
    # fedora
    echo '[charm]
    name=Charm
    baseurl=https://repo.charm.sh/yum/
    enabled=1
    gpgcheck=1
    gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo >/dev/null

    sudo rpm --import https://repo.charm.sh/yum/gpg.key

    sudo dnf install gum

  elif cmd_exists pacman; then
    # arch
    sudo pacman -S gum --noconfirm
  fi

  # zsh completions
  if cmd_exists gum; then
    info "gum installation completed."

    info "Install zsh completions."

    mkdir -p "$CONFIG_HOME/zsh/completions"
    gum completion zsh >"$CONFIG_HOME/zsh/completions/_gum"

    info "Installed zsh completions."
  else
    error "gum installation failed."
  fi

  info "End: ${FUNCNAME[0]}"
  return 0
}

case "${1:-}" in
--gum)
  install_gum
  ;;
esac

# download
curl -OL https://github.com/irichu/dotfiles/archive/refs/heads/main.tar.gz

# current git user
if cmd_exists git; then
  git_user_name="$(git config user.name || true)"
  git_user_email="$(git config user.email || true)"
fi

# current zsh history if exists
histfile="$CONFIG_HOME/zsh/.zsh_history"
histfile_tmp="$CACHE_DIR/.zsh_history.tmp"
if [ -f "$histfile" ]; then
  info "$histfile found"
  cp "$histfile" "$histfile_tmp"
fi

# create completions directory
zsh_completions_dir="$CONFIG_HOME/zsh/completions"
zsh_completions_cache_dir="$CACHE_DIR/"
mkdir -p "$zsh_completions_dir"
mkdir -p "$zsh_completions_cache_dir"
cp -rf "$zsh_completions_dir" "$zsh_completions_cache_dir"

# deploy
tar xvf main.tar.gz
backup_dir "$HOME/.local/share/dotfiles-main"
touch "$HOME/.local/share/dotfiles-tmp-74ead8f4-4501-47a1-8e4a-b9ba72b39c3a"
mv -f dotfiles-main "$HOME/.local/share/"

if [ -f "./assets/scripts/main.sh" ]; then
  # git repos
  if [ -d /data/data/com.termux/files/usr/bin ]; then
    # for termux
    \cp -f "./assets/scripts/main.sh" /data/data/com.termux/files/usr/bin/dots
  fi

  # install to .local/bin
  \cp -f "./assets/scripts/main.sh" "$HOME/.local/bin/dots"

  # copy to .local/share/dotfiles
  mkdir -p "$DATA_DIR"
  \cp -rf ./* "$DATA_DIR"/
else
  # for termux
  if [ -d /data/data/com.termux/files/usr/bin ]; then
    \cp -f "$HOME/.local/share/dotfiles-main/assets/scripts/main.sh" /data/data/com.termux/files/usr/bin/dots
  fi

  # install
  \cp -f "$HOME/.local/share/dotfiles-main/assets/scripts/main.sh" "$HOME/.local/bin/dots"
fi

# Remove
rm ./main.tar.gz
rm "$HOME/.local/share/dotfiles-tmp-74ead8f4-4501-47a1-8e4a-b9ba72b39c3a"

# create ~/.bashrc if not exists
if [ ! -f "$HOME/.bashrc" ]; then
  touch "$HOME/.bashrc"
  echo "# Created .bashrc" >>"$HOME/.bashrc"
fi

# add to PATH
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >>~/.bashrc
fi

# restore git user
if cmd_exists git; then

  if [ ! -f ~/.config/git/config ]; then
    mkdir -p ~/.config/git
    touch ~/.config/git/config
  fi

  # name
  if [ -n "${git_user_name:-}" ]; then
    git config -f ~/.config/git/config user.name "${git_user_name:-}"
  fi

  # email
  if [ -n "${git_user_email:-}" ]; then
    git config -f ~/.config/git/config user.email "${git_user_email:-}"
  fi
fi

# restore zsh

if [ -f "$histfile_tmp" ]; then
  if [ ! -f "$histfile" ]; then
    info "restore .zsh_history"
    mkdir -p "$CONFIG_HOME/zsh"
    cp -f "$histfile_tmp" "$histfile"
  fi

  rm "$histfile_tmp"
fi

# restore completions
mkdir -p "$zsh_completions_cache_dir"
cp -rf "$zsh_completions_cache_dir"/completions "$CONFIG_HOME/zsh/"

success 'The dots command installation has been completed!'
success 'If the dots command is not found, use the ~/.local/bin/dots command during the installation process.'
info ''

success 'If you like it, please consider starring the repository.'
success 'https://github.com/irichu/dotfiles'
info ''
