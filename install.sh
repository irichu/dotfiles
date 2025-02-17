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

#mkdir -p "$DATA_DIR"
#echo $HOME/.{cache,config,local/state}/dotfiles | read cache_dir config_dir state_dir

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

#COLOR_DARKGRAY='\033[1;30m'
#COLOR_LIGHTRED='\033[1;31m'
#COLOR_LIGHTGREEN='\033[1;32m'
#COLOR_BROWNORANGE='\033[0;33m'
#COLOR_LIGHTBLUE='\033[1;34m'
#COLOR_LIGHTPURPLE='\033[1;35m'
#COLOR_LIGHTCYAN='\033[1;36m'
#COLOR_LIGHTGRAY='\033[0;37m'

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

echo_descriptions() {
  data_path="$1"

  #tail -n +2 "$data_path" | sort -t'	' -k1,1 | while IFS='	' read -r key value; do
  tail -n +2 "$data_path" | while IFS='	' read -r key value; do
    info -ny -cc "  $(printf "%-${2:-13}s" "$key")"
    info -cn " $value"
  done

  return 0
}

echo_allcommand_usage() {

  info -ny -cg "Usage: "
  info -cc "./$(basename "$0") all <Command>"

  info -cg "Commands: "
  echo_descriptions "$SCRIPT_DIR"/assets/tsv/main-commands.tsv 5

  # list command
  info ""
  info -ny -cg "Show package list: "
  info -cc "./$(basename "$0") list(alias:ls) <Command>"
  #echo_descriptions "$SCRIPT_DIR"/assets/package-managers.tsv

  return 0
}

echo_each_command_usage() {

  info ""
  info -ny -cg "Individual installation: "
  info -cc "./$(basename "$0") <Package>"

  echo_descriptions "$SCRIPT_DIR"/assets/tsv/install-packages.tsv

  info ""
  info -ny -cg "Individual set up: "
  info -cc "./$(basename "$0") <Setup>"

  echo_descriptions "$SCRIPT_DIR"/assets/tsv/setup-packages.tsv

  return 0
}

echo_completion_message() {

  info ""
  info "To reflect zsh settings immediately,"
  info "relogin shell or run the following command:"
  info ""

  success "  exec -l \$(which zsh)"

  info ""
  info "If you like this repository even a little bit, please star it on GitHub as it will motivate our activities!"
  success "https://github.com/irichu/dotfiles"
  info ""

  return 0
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

# download
curl -OL https://github.com/irichu/dotfiles/archive/refs/heads/main.tar.gz

# deploy
tar xvf main.tar.gz
backup_dir "$HOME/.local/share/dotfiles-main"
touch "$HOME/.local/share/dotfiles-tmp-74ead8f4-4501-47a1-8e4a-b9ba72b39c3a"
mv -f dotfiles-main "$HOME/.local/share/"

if [ -f "./main.sh" ]; then
  # git repos
  #if [ -d /data/data/com.termux/files/usr/bin ]; then
  #  # for termux
  #  \cp -f "./main.sh" /data/data/com.termux/files/usr/bin/dots
  #else
  # install to .local/bin
  \cp -f "./main.sh" "$HOME/.local/bin/dots"
  #fi

  # copy to .local/share/dotfiles
  mkdir -p "$DATA_DIR"
  \cp -rf ./* "$DATA_DIR"/
else
  # for termux
  #if [ -d /data/data/com.termux/files/usr/bin ]; then
  #  \cp -f "$HOME/.local/share/dotfiles-main/main.sh" /data/data/com.termux/files/usr/bin/dots
  #else
  # install
  \cp -f "$HOME/.local/share/dotfiles-main/main.sh" "$HOME/.local/bin/dots"
  #fi
fi

# Remove
rm ./main.tar.gz
rm "$HOME/.local/share/dotfiles-tmp-74ead8f4-4501-47a1-8e4a-b9ba72b39c3a"

# ~/.bashrc が存在しない場合は作成
if [ ! -f "$HOME/.bashrc" ]; then
  touch "$HOME/.bashrc"
  echo "# Created .bashrc" >> "$HOME/.bashrc"
fi

# ~/.bashrc に PATH を追加（重複チェックあり）
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

# ~/.bashrc を即反映
source ~/.bashrc

echo "PATH has been updated! You can now use dots commands."
