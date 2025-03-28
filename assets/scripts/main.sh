#!/usr/bin/env bash

###################################################
# init
###################################################

set -ue
set -o pipefail

export LC_ALL=C

readonly DEBUG=true
readonly ARCH="$(uname -m)"
#readonly GITHUB_ACTIONS=1

#--------------------------------------------------
# path
#--------------------------------------------------

SCRIPT_DIR=$(
  cd "$(dirname "${BASH_SOURCE:-$0}")"
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
DATA_DIR="$DATA_HOME/dotfiles-main"
mkdir -p "$DATA_DIR"
#echo $HOME/.{cache,config,local/state}/dotfiles | read cache_dir config_dir state_dir
#printf "%s\n" $HOME/.{cache,config,local/state}/dotfiles | xargs -I{} sh -c "mkdir -p $1" && echo "$1"' sh {}

if [ "$SCRIPT_DIR" = "$HOME/.local/bin" -o "$SCRIPT_DIR" = "/data/data/com.termux/files/usr/bin" ]; then
  SCRIPT_DIR="$DATA_DIR"
  cd "$SCRIPT_DIR"
fi

#echo $SCRIPT_DIR
#exit 0

#--------------------------------------------------
# theme
#--------------------------------------------------
# available themes
themes=(
  "developer"
  "developer-textcolored"
  "developer-colorful"
  "developer-mono"
  "dark-turquoise"
  "dark-turquoise-textcolored"
  "dark-turquoise-colorful"
  "dark-turquoise-mono"
  "dark-orange"
  "dark-orange-textcolored"
  "dark-orange-colorful"
  "dark-orange-mono"
  "dark-skyblue"
  "dark-skyblue-textcolored"
  "dark-skyblue-colorful"
  "dark-skyblue-mono"
  "random"
)

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
  info -cc "dots install <Command>"

  info -cg "Commands: "
  echo_descriptions "$SCRIPT_DIR"/assets/tsv/main-commands.tsv 5

  # list command
  info ""
  info -ny -cg "Show package list: "
  info -cc "dots list(alias:ls) <Command>"
  #echo_descriptions "$SCRIPT_DIR"/assets/package-managers.tsv

  return 0
}

echo_each_command_usage() {

  info ''
  info -ny -cg 'Individual installation: '
  info -cc 'dots install <Package>'

  echo_descriptions "$SCRIPT_DIR"/assets/tsv/install-packages.tsv

  info ''
  info -ny -cg 'Individual set up: '
  info -cc 'dots setup <Setup>'

  echo_descriptions "$SCRIPT_DIR"/assets/tsv/setup-packages.tsv

  info ''
  info -ny -cg 'Update all package by package manager: '
  info -cc 'dots update'

  info ''
  info -ny -cg 'Get theme: '
  info -cc 'dots theme'
  info -ny -cg 'Set theme: '
  info -cc 'dots set-theme <NUMBER|NAME>'

  # show theme list
  i=1
  for theme in "${themes[@]}"; do
    if ((i < 10)); then
      formatted_index="[$i]"
    else
      printf -v formatted_index "[%2d]" "$i"
    fi
    info -cc "$(printf "%6s" "$formatted_index") $theme"
    ((i++))
  done

  info ''
  info -ny -cg 'Test on Docker: '
  info -cc 'dots docker test {ubuntu|ubuntu-22.04|arch|fedora}'

  info ''
  info -ny -cg 'Clean up dotfiles [and backup, and config, and both]: '
  info -cc 'dots clean [backup|config|all]'

  info -ny -cc '  clean         '
  info -cn 'remove cache (~/.local/cache/dotfiles/*)'
  info -ny -cc '  clean backup  '
  info -cn 'remove cache and backup (~/.local/dotfiles*.bak*)'
  info -ny -cc '  clean config  '
  info -cn 'remove cache and config (~/.config/*.bak*)'
  info -ny -cc '  clean all     '
  info -cn 'remove cache and backup and config'

  return 0
}

echo_completion_message() {

  info ""
  info "To reflect zsh settings immediately,"
  info "relogin shell or run the following command:"
  info ""

  success "  exec -l \$(which zsh)"

  info ""
  success "If you like this repository even a little bit, please star it on GitHub!"
  success "https://github.com/irichu/dotfiles"
  info ""

  return 0
}

###################################################
# utils
###################################################

cmd_exists() {
  command -v $1 &>/dev/null
}

check_command() {
  if ! cmd_exists $1; then
    error "$1 command not found."
    exit 1
  fi
  return 0
}

# for subshell
get_github_latest_version() {
  user_regex='[a-zA-Z0-9]([a-zA-Z0-9]?|[\-]?([a-zA-Z0-9])){0,38}'
  repos_regex='[a-zA-Z0-9\-\_]{2,255}'
  echo "$1" | grep -E "^$user_regex/$repos_regex$" &>/dev/null &&
    echo "$(curl -w "%{redirect_url}" -s -o /dev/null "https://github.com/$1/releases/latest" | grep -Eo '[0-9]+\.[0-9]+.[0-9]+$')"
  return 0
}

# Function to install the 'gum' utility, which is used for interactive shell scripts.
install_gum() {
  info "Start: ${FUNCNAME[0]}"

  if is_gum_available; then
    info "gum already installed."

    if [ ! -f "$CONFIG_HOME/zsh/completions/_gum" ]; then
      info "Install zsh completions."
      mkdir -p "$CONFIG_HOME/zsh/completions"
      gum completion zsh >"$CONFIG_HOME/zsh/completions/_gum"
    fi

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
  if is_gum_available; then
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

is_gum_available() {
  [[ "${TERMUX_VERSION:-}" != *googleplay* ]] && command -v gum &> /dev/null
}

remove_zcompdump() {
  info "Start: ${FUNCNAME[0]}"

  ZCOMPDUMP_FILE="$CONFIG_HOME/zsh/.zcompdump"
  if [ -f "$ZCOMPDUMP_FILE" ]; then
    rm "$ZCOMPDUMP_FILE"
    info "removed .zcompdump file"
  else
    info "no .zcompdump file found."
  fi

  info "End: ${FUNCNAME[0]}"
  return 0
}

###################################################
# shells
###################################################
#--------------------------------------------------
# bash
#--------------------------------------------------

# setup_bash() {
#   info "Start: ${FUNCNAME[0]}"
#
#   cp "$HOME"/.bashrc{,.bk}
#   cp "$HOME"/.bash_aliases{,.bk}
#   cp "$SCRIPT_DIR"/config/bash/.bashrc "$HOME"
#   cp "$SCRIPT_DIR"/config/bash/.bash_aliases "$HOME"
#
#   [ -f /bin/bash ] && bash_path=/bin/bash
#
#   if grep "$bash_path" /etc/shells && [ "$SHELL" = "$bash_path" ]; then
#     CURRENT_USER=$(id -u -n)
#     sudo chsh "$CURRENT_USER" -s "$bash_path"
#     info "changed to bash"
#   fi
#
#   info "End: ${FUNCNAME[0]}"
#   return 0
# }

#--------------------------------------------------
# zsh
#--------------------------------------------------

setup_zsh() {
  info "Start: ${FUNCNAME[0]}"

  sudo sh -c "echo 'ZDOTDIR=\$HOME/.config/zsh' > /etc/zshenv"
  [ -f /etc/zsh/zshenv ] && ! grep 'ZDOTDIR=' /etc/zsh/zshenv &>/dev/null && sudo sh -c "echo 'ZDOTDIR=\$HOME/.config/zsh' >> /etc/zsh/zshenv"

  # create temp file
  histfile="$CONFIG_HOME/zsh/.zsh_history"
  histfile_tmp="$CACHE_DIR/.zsh_history.tmp"
  if [ -f "$histfile" ]; then
    cp "$histfile" "$histfile_tmp"
  fi

  # create completions directory
  zsh_completions_dir="$CONFIG_HOME/zsh/completions"
  zsh_completions_cache_dir="$CACHE_DIR/"
  mkdir -p "$zsh_completions_dir"
  mkdir -p "$zsh_completions_cache_dir"
  cp -rf "$zsh_completions_dir" "$zsh_completions_cache_dir"

  # create copy backup
  backup_dir "$CONFIG_HOME/zsh"

  # apply setting
  ln -s "$SCRIPT_DIR/config/zsh" "$CONFIG_HOME/"

  # restore
  if [ -f "$histfile_tmp" ]; then

    if [ ! -f "$histfile" ]; then
      info "restore .zsh_history"
      cp -f "$histfile_tmp" "$histfile"
    fi

    # remove temp file
    rm "$histfile_tmp"
  fi

  # restore completions
  mkdir -p "$zsh_completions_cache_dir"
  cp -rf "$zsh_completions_cache_dir"/completions "$CONFIG_HOME/zsh/"

  [ -f /bin/zsh ] && zsh_path=/bin/zsh

  if cmd_exists brew; then
    zsh_path="$(brew --prefix)/bin/zsh"
  fi
  if ! grep "$zsh_path" /etc/shells &>/dev/null; then
    echo "$zsh_path" | sudo tee -a /etc/shells
  fi

  echo "zsh_path: $zsh_path"
  CURRENT_USER=$(id -u -n)
  sudo -i chsh "$CURRENT_USER" -s "$zsh_path"

  # zsh-completions
  zcpath="$DATA_HOME/zsh-completions"
  [ ! -d "$zcpath" ] && git clone https://github.com/zsh-users/zsh-completions.git "$zcpath"

  info "End: ${FUNCNAME[0]}"
  return 0
}

###################################################
# installation
###################################################
#--------------------------------------------------
# starship.rs
#--------------------------------------------------

install_or_update_starship() {
  info "Start: ${FUNCNAME[0]}"

  mkdir -p "$HOME/.local/bin"
  curl -sS https://starship.rs/install.sh | sh -s -- -b "$HOME/.local/bin" -y

  #cp -r "$SCRIPT_DIR"/config/starship "$CONFIG_HOME"
  backup_dir "$CONFIG_HOME/starship"
  ln -s "$SCRIPT_DIR/config/starship" "$CONFIG_HOME/"

  "$HOME"/.local/bin/starship preset nerd-font-symbols -o "$CONFIG_HOME"/starship/nerd.toml

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# fzf
#--------------------------------------------------

install_fzf_via_git() {
  info "Start: ${FUNCNAME[0]}"

  [ ! -d ~/.fzf ] && git clone --depth=1 https://github.com/junegunn/fzf.git ~/.fzf
  (yes || true) | ~/.fzf/install

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# nvm
#--------------------------------------------------

# install_nvm() {
#   info "Start: ${FUNCNAME[0]}"
#
#   local LATEST_VERSION
#   LATEST_VERSION=$(get_github_latest_version 'nvm-sh/nvm') &&
#     curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${LATEST_VERSION}/install.sh | bash
#
#   install_node_by_nvm
#
#   info "End: ${FUNCNAME[0]}"
#   return 0
# }

# install_node_by_nvm() {
#   info "Start: ${FUNCNAME[0]}"
#
#   XDG_CONFIG_HOME="$CONFIG_HOME"
#   if [ -d "$HOME/.nvm" ]; then
#     export NVM_DIR="$HOME/.nvm"
#     [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
#   fi
#   if [ -d "$HOME/.config/nvm" ]; then
#     export NVM_DIR="$HOME/.config/nvm"
#     [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
#   fi
#
#   if [ -s "${HOMEBREW_PREFIX-}/opt/nvm/nvm.sh" ]; then
#     export NVM_DIR="$HOME/.config/nvm"
#     mkdir -p "$NVM_DIR"
#     \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
#   fi
#
#   nvm -v
#   nvm install --lts --latest-npm
#
#   info "End: ${FUNCNAME[0]}"
#   return 0
# }

#--------------------------------------------------
# FNM
#--------------------------------------------------

install_fnm() {
  info "Start: ${FUNCNAME[0]}"

  curl -fsSL https://fnm.vercel.app/install | bash
  install_node_by_fnm

  info "End: ${FUNCNAME[0]}"
  return 0
}

install_node_by_fnm() {
  info "Start: ${FUNCNAME[0]}"

  # fnm
  FNM_PATH="$DATA_HOME/fnm"
  if [ -d "$FNM_PATH" ]; then
    export PATH="$DATA_HOME/fnm:$PATH"
    eval "$(fnm env)"
  fi

  mkdir -p "$CONFIG_HOME/zsh/completions"
  fnm completions --shell zsh >"$CONFIG_HOME/zsh/completions/_fnm"

  fnm --version
  fnm install --lts

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# Zed editor
#--------------------------------------------------

install_zed() {
  info "Start: ${FUNCNAME[0]}"

  if [ "$(uname)" == "Linux" ]; then
    curl -f https://zed.dev/install.sh | sh
  fi

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# HackGen font
#--------------------------------------------------

install_hackgen() {
  info "Start: ${FUNCNAME[0]}"

  local LATEST_VERSION
  LATEST_VERSION=$(get_github_latest_version 'yuru7/HackGen')
  if [ -z $LATEST_VERSION ]; then
    error 'yuru7/HackGen latest version not found'
    return 1
  fi
  debug $LATEST_VERSION

  [ ! -f "$CACHE_DIR/HackGen_NF_v${LATEST_VERSION}.zip" ] &&
    curl -Lo "$CACHE_DIR/HackGen_NF_v${LATEST_VERSION}.zip" "https://github.com/yuru7/HackGen/releases/download/v${LATEST_VERSION}/HackGen_NF_v${LATEST_VERSION}.zip"

  unzip -o "$CACHE_DIR/HackGen_NF_v${LATEST_VERSION}.zip" -d $CACHE_DIR

  [ ! -d "$CACHE_DIR/HackGen_NF" ] &&
    mv "$CACHE_DIR/HackGen_NF_v${LATEST_VERSION}" "$CACHE_DIR/HackGen_NF"

  [ ! -d ~/.local/share/fonts/HackGen_NF ] &&
    mv "$CACHE_DIR/HackGen_NF" ~/.local/share/fonts/

  if [ ${TERMUX_VERSION:-0} = 0 ]; then
    cmd_exists fc-cache && fc-cache -vf || warning 'fc-cache command not found. please check and install fontconfig.'
  else
    [ -f ~/.local/share/fonts/HackGen35ConsoleNF-Regular.ttf ] && cp -f ~/.local/share/fonts/HackGen35ConsoleNF-Regular.ttf ~/.termux/font.ttf
    [ -f ~/.local/share/fonts/HackGen_NF/HackGen35ConsoleNF-Regular.ttf ] && cp -f ~/.local/share/fonts/HackGen_NF/HackGen35ConsoleNF-Regular.ttf ~/.termux/font.ttf
  fi

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# terminator
#--------------------------------------------------

# setup_terminator() {
#   info "Start: ${FUNCNAME[0]}"
#
#   cp -r "$SCRIPT_DIR"/config/terminator "$CONFIG_HOME"
#
#   info "End: ${FUNCNAME[0]}"
#   return 0
# }

#--------------------------------------------------
# apt-get
#--------------------------------------------------

install_apt_package() {
  info "Start: ${FUNCNAME[0]}"

  sudo apt-get update
  cat "$SCRIPT_DIR"/assets/txt/apt-basic-packages.txt | xargs sudo apt-get install -y

  # Get the current Ubuntu version
  ubuntu_version=$(lsb_release -r | awk '{print $2}')

  # Check if the version is 24.04 or higher
  if [[ "$(echo -e "$ubuntu_version\n24.04" | sort -V | head -n 1)" == "24.04" ]]; then
    info "Ubuntu is 24.04 or higher."
    cat "$SCRIPT_DIR"/assets/txt/apt-packages-latest.txt | xargs sudo apt-get install -y
  else
    info "Ubuntu is lower than 24.04."
    cat "$SCRIPT_DIR"/assets/txt/apt-packages.txt | xargs sudo apt-get install -y
  fi

  # .local install
  mkdir -p ~/.local/bin
  [ ! -f ~/.local/bin/bat ] && ln -s /usr/bin/batcat ~/.local/bin/bat
  [ ! -f ~/.local/bin/fd ] && ln -s /usr/bin/fdfind ~/.local/bin/fd

  # bat config
  backup_dir "$CONFIG_HOME/bat"
  ln -s "$SCRIPT_DIR/config/bat" "$CONFIG_HOME/"

  # ripgrep config
  backup_dir "$CONFIG_HOME/ripgrep"
  ln -s "$SCRIPT_DIR/config/ripgrep" "$CONFIG_HOME/"

  # dust (debian_revisionが -1 とは限らないが決め打ち。NGならsnapかbrewで)
  if ! cmd_exists snap && ! cmd_exists dust; then
    notice 'snap command not found. Install dust by deb file.'
    local LATEST_VERSION
    LATEST_VERSION=$(get_github_latest_version 'bootandy/dust')
    [ ! -f "$CACHE_DIR/du-dust_${LATEST_VERSION}-1_amd64.deb" ] &&
      wget -P $CACHE_DIR "https://github.com/bootandy/dust/releases/download/v${LATEST_VERSION}/du-dust_${LATEST_VERSION}-1_amd64.deb" || error "dust.deb not found"
    sudo dpkg -i "$CACHE_DIR/du-dust_${LATEST_VERSION}-1_amd64.deb"
  fi

  # fastfetch
  if ! cmd_exists fastfetch; then
    info 'install fastfetch'
    sudo add-apt-repository --yes ppa:zhangsongcui3371/fastfetch
    sudo apt update
    sudo apt-get install fastfetch
  fi

  # pre Ubuntu 22.04
  # eza
  if ! cmd_exists eza; then
    info 'install eza'
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg --yes
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt-get update
    sudo apt-get install -y eza
  fi

  backup_dir "$CONFIG_HOME/eza"
  ln -s "$SCRIPT_DIR/config/eza" "$CONFIG_HOME/"

  # git-delta
  if ! cmd_exists delta; then
    info 'install git-delta'
    local LATEST_VERSION
    LATEST_VERSION=$(get_github_latest_version 'dandavison/delta')
    [ ! -f "$CACHE_DIR/git-delta_amd64.deb" ] &&
      curl -Lo "$CACHE_DIR/git-delta_amd64.deb" "https://github.com/dandavison/delta/releases/latest/download/git-delta_${LATEST_VERSION}_amd64.deb"
    sudo dpkg -i "$CACHE_DIR/git-delta_amd64.deb"
  fi

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# brew
#--------------------------------------------------

install_homebrew() {
  info "Start: ${FUNCNAME[0]}"

  # install requirements
  # https://docs.brew.sh/Homebrew-on-Linux#requirements
  if cmd_exists apt; then
    sudo apt-get update
    sudo apt-get install -y build-essential procps curl file git
  elif cmd_exists dnf; then
    if dnf --version 2>/dev/null | grep -q "dnf5"; then
      sudo dnf install -y @development-tools
    else
      sudo dnf install -y "@Development Tools"
    fi
    sudo dnf install -y procps-ng curl file git
    sudo dnf install -y wget util-linux-user # for chsh
  elif cmd_exists pacman; then
    sudo pacman -S base-devel procps-ng curl file git --noconfirm
  fi

  if ! cmd_exists brew; then
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if [ "$(uname)" == "Linux" ]; then
    test -f /home/linuxbrew/.linuxbrew/bin/brew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    # test -r ~/.bashrc && ! grep 'eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' ~/.bashrc &>/dev/null && (
    #   echo
    #   echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\""
    # ) >>~/.bashrc
  fi

  cd "$SCRIPT_DIR"

  if [ -z "${GITHUB_ACTIONS:-}" ]; then
    # install all
    brew bundle
  else
    # testing
    brew bundle --file=assets/ci/Brewfile
  fi

  # fzf set up
  "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-fish

  #cp -r "$SCRIPT_DIR"/config/lazygit "$CONFIG_HOME"
  #cp -r "$SCRIPT_DIR"/config/starship "$CONFIG_HOME"/
  backup_dir "$CONFIG_HOME/bat"
  ln -s "$SCRIPT_DIR/config/bat" "$CONFIG_HOME/"

  backup_dir "$CONFIG_HOME/eza"
  ln -s "$SCRIPT_DIR/config/eza" "$CONFIG_HOME/"

  backup_dir "$CONFIG_HOME/lazygit"
  ln -s "$SCRIPT_DIR/config/lazygit" "$CONFIG_HOME/"

  backup_dir "$CONFIG_HOME/ripgrep"
  ln -s "$SCRIPT_DIR/config/ripgrep" "$CONFIG_HOME/"

  backup_dir "$CONFIG_HOME/starship"
  ln -s "$SCRIPT_DIR/config/starship" "$CONFIG_HOME/"

  backup_dir "$CONFIG_HOME/yazi"
  ln -s "$SCRIPT_DIR/config/yazi" "$CONFIG_HOME/"

  starship preset nerd-font-symbols -o "$CONFIG_HOME"/starship/nerd.toml

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# snap
#--------------------------------------------------

install_snap_package() {
  info "Start: ${FUNCNAME[0]}"

  if ! cmd_exists snap; then
    error 'snap command not found.'
    return 1
  fi

  # snap package list
  snappy_packages="$SCRIPT_DIR"/assets/txt/snap-packages.txt

  # install --classic packages
  grep -- '--classic' "$snappy_packages" | sed 's/ --classic//' | xargs -d '\n' -I{} sudo snap install {} --classic

  # install snap packages
  grep -v -- '--classic' "$snappy_packages" | xargs -d '\n' -n1 sudo snap install

  # To allow the program to run as intended
  sudo snap connect bottom:mount-observe
  sudo snap connect bottom:hardware-observe
  sudo snap connect bottom:system-observe
  sudo snap connect bottom:process-control

  # install latest stable rustc and cargo
  /snap/bin/rustup default stable
  #rustup update stable

  # cargo install
  /snap/bin/cargo install --locked typst-cli
  #/snap/bin/cargo install --locked yazi-fm yazi-cli

  #cp -r "$SCRIPT_DIR"/config/alacritty "$CONFIG_HOME"
  #cp -r "$SCRIPT_DIR"/config/lazygit "$CONFIG_HOME"

  backup_dir "$CONFIG_HOME/alacritty"
  ln -s "$SCRIPT_DIR/config/alacritty" "$CONFIG_HOME/"

  backup_dir "$CONFIG_HOME/lazygit"
  ln -s "$SCRIPT_DIR/config/lazygit" "$CONFIG_HOME/"

  setup_zellij

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# rustdesk
#--------------------------------------------------

install_rustdesk() {
  info "Start: ${FUNCNAME[0]}"

  local LATEST_VERSION
  LATEST_VERSION=$(get_github_latest_version 'rustdesk/rustdesk')
  wget "https://github.com/rustdesk/rustdesk/releases/download/${LATEST_VERSION}/rustdesk-${LATEST_VERSION}-${ARCH}.deb"
  sudo dpkg -i "rustdesk-${LATEST_VERSION}-${ARCH}.deb"

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# rustup
#--------------------------------------------------

install_rustup() {
  info "Start: ${FUNCNAME[0]}"

  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
  rustup default stable

  #install_cargo_packages
  info "rustup installation completed."
  info ""
  info "To install typst, execute: "
  info "  cargo install --locked typst-cli"
  info ""
  info "To install yazi, execute: "
  info "  cargo install --locked yazi-fm yazi-cli"
  info ""

  info "End: ${FUNCNAME[0]}"
  return 0
}

install_cargo_packages() {
  info "Start: ${FUNCNAME[0]}"

  # cargo install

  # alacritty
  if cmd_exists apt; then
    sudo apt install pkg-config libfreetype6-dev libfontconfig1-dev
  fi

  cargo install alacritty

  backup_dir "$CONFIG_HOME/alacritty"
  ln -s "$SCRIPT_DIR/config/alacritty" "$CONFIG_HOME/"

  # typst
  cargo install --locked typst-cli

  # yazi
  cargo install --locked yazi-fm yazi-cli

  backup_dir "$CONFIG_HOME/yazi"
  ln -s "$SCRIPT_DIR/config/yazi" "$CONFIG_HOME/"

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# neovim
#--------------------------------------------------

build_install_neovim() {
  info "Start: ${FUNCNAME[0]}"

  # neovim
  wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
  tar -zxvf nvim-linux-x86_64.tar.gz
  [ ! -d /usr/bin/nvim ] && sudo mv -f nvim-linux-x86_64/bin/nvim /usr/bin/nvim
  [ ! -d /usr/lib/nvim ] && sudo mv -f nvim-linux-x86_64/lib/nvim /usr/lib/nvim
  [ ! -d /usr/share/nvim ] && sudo mv -f nvim-linux-x86_64/share/nvim/ /usr/share/nvim
  rm -rf nvim-linux-x86_64
  rm nvim-linux-x86_64.tar.gz

  mkdir -p "$CONFIG_HOME"/nvim/lua/config/
  mkdir -p "$CONFIG_HOME"/nvim/lua/plugins/

  # lazygit
  local LATEST_VERSION
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${ARCH}.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm lazygit lazygit.tar.gz

  #cp -r "$SCRIPT_DIR"/config/lazygit "$CONFIG_HOME"
  backup_dir "$CONFIG_HOME/lazygit"
  ln -s "$SCRIPT_DIR/config/lazygit" "$CONFIG_HOME/"

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# lazygit
#--------------------------------------------------

build_install_lazygit() {
  info "Start: ${FUNCNAME[0]}"

  # lazygit
  local LATEST_VERSION
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${ARCH}.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm lazygit lazygit.tar.gz

  #cp -r "$SCRIPT_DIR"/config/lazygit "$CONFIG_HOME"
  backup_dir "$CONFIG_HOME/lazygit"
  ln -s "$SCRIPT_DIR/config/lazygit" "$CONFIG_HOME/"

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# LazyVim
#--------------------------------------------------

install_lazyvim() {
  info "Start: ${FUNCNAME[0]}"

  # required
  date_str=$(now_str)
  [ -d "$CONFIG_HOME"/nvim ] &&
    mv "$CONFIG_HOME"/nvim{,.bak$date_str}

  # optional but recommended
  [ -d ~/.local/share/nvim ] &&
    mv ~/.local/share/nvim{,.bak$date_str}
  [ -d ~/.local/state/nvim ] &&
    mv ~/.local/state/nvim{,.bak$date_str}
  [ -d ~/.cache/nvim ] &&
    mv ~/.cache/nvim{,.bak$date_str}

  git clone https://github.com/LazyVim/starter "$CONFIG_HOME/nvim"

  rm -rf "$CONFIG_HOME/nvim/.git"

  cp "$SCRIPT_DIR"/config/nvim/lua/config/*.lua "$CONFIG_HOME/nvim/lua/config/"
  cp "$SCRIPT_DIR"/config/nvim/lua/plugins/*.lua "$CONFIG_HOME/nvim/lua/plugins/"
  cp "$SCRIPT_DIR"/config/nvim/lazy-lock.json "$CONFIG_HOME/nvim/"
  cp "$SCRIPT_DIR"/config/nvim/lazyvim.json "$CONFIG_HOME/nvim/"

  nvim +q

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# docker
#--------------------------------------------------

install_docker() {
  info "Start: ${FUNCNAME[0]}"

  # check docker command
  if cmd_exists docker; then
    info "docker already installed."
    return 0
  fi

  if cmd_exists apt; then
    if [ -n "${TERMUX_VERSION:-}" ]; then
      # termux
      echo "termux not supported."
    else
      # ubuntu debian
      sudo apt update
      sudo apt install ca-certificates curl gnupg

      sudo install -m 0755 -d /etc/apt/keyrings
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
      sudo chmod a+r /etc/apt/keyrings/docker.asc

      # Add the repository to apt sources:
      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
      sudo apt update

      # add docker group
      if ! getent group docker >/dev/null; then
        sudo groupadd docker
      fi

      CURRENT_USER=$(id -u -n)
      sudo usermod -aG docker "$CURRENT_USER"

      # install docker
      sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      sudo systemctl enable docker
      sudo systemctl start docker
    fi
  elif cmd_exists dnf; then
    # fedora

    #sudo dnf remove docker \
    #  docker-client \
    #  docker-client-latest \
    #  docker-common \
    #  docker-latest \
    #  docker-latest-logrotate \
    #  docker-logrotate \
    #  docker-selinux \
    #  docker-engine-selinux \
    #  docker-engine

    # add docker group
    if ! getent group docker >/dev/null; then
      sudo groupadd docker
    fi

    CURRENT_USER=$(id -u -n)
    sudo usermod -aG docker "$CURRENT_USER"

    sudo dnf -y install dnf-plugins-core

    #sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo

    sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo systemctl enable docker
    sudo systemctl start docker
  elif cmd_exists pacman; then
    # arch

    # add docker group
    if ! getent group docker >/dev/null; then
      sudo groupadd docker
    fi

    CURRENT_USER=$(id -u -n)

    sudo usermod -aG docker "$CURRENT_USER"
    sudo pacman -S docker docker-compose --noconfirm
    sudo systemctl enable docker
    sudo systemctl start docker
  fi

  # print version
  if cmd_exists docker; then
    info 'docker --version'
    docker --version

    info 'docker compose version'
    docker compose version
  fi

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# lazydocker
#--------------------------------------------------

install_lazdocker() {
  info "Start: ${FUNCNAME[0]}"

  curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

  info "End: ${FUNCNAME[0]}"
  return 0
}

###################################################
# settings
###################################################
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

backup_dotfiles() {
  info "Start: ${FUNCNAME[0]}"

  date_str=$(now_str)
  backup_path="$DATA_DIR/backup/$date_str"

  mkdir -p "$backup_path"

  [ -f ~/.bashrc ] && cp ~/.bashrc "$backup_path"
  [ -f ~/.bash_aliases ] && cp ~/.bash_aliases "$backup_path"
  cp -Lr "$CONFIG_HOME"/* "$backup_path"

  info -cn "copied to $backup_path"

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# git
#--------------------------------------------------

setup_git() {
  info "Start: ${FUNCNAME[0]}"

  info "setup git config"

  check_command git

  #cp -r "$SCRIPT_DIR"/config/git "$CONFIG_HOME"
  git_user_name="$(git config user.name || true)"
  git_user_email="$(git config user.email || true)"

  backup_dir "$CONFIG_HOME/git"
  ln -s "$SCRIPT_DIR/config/git" "$CONFIG_HOME/"

  if [ -z "${GITHUB_ACTIONS:-}" ]; then
    #current_name=$(git config user.name)
    #current_email=$(git config user.email)

    #read -rp "git user.name [$current_name]:" name
    #read -rp "git user.email [$current_email]:" email

    #git config -f ~/.config/git/config user.name "${name:-$current_name}"
    #git config -f ~/.config/git/config user.email "${email:-$current_email}"

    if [ -n "$git_user_name" ]; then
      git config -f ~/.config/git/config user.name "$git_user_name"
    fi

    if [ -n "$git_user_email" ]; then
      git config -f ~/.config/git/config user.email "$git_user_email"
    fi
  fi

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# termux
#--------------------------------------------------

setup_termux() {
  info "Start: ${FUNCNAME[0]}"

  "$SCRIPT_DIR"/assets/scripts/setup-termux.sh

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# tmux
#--------------------------------------------------

setup_tmux() {
  info "Start: ${FUNCNAME[0]}"

  #cp -r "$SCRIPT_DIR"/config/tmux "$CONFIG_HOME"
  backup_dir "$CONFIG_HOME/tmux"
  ln -s "$SCRIPT_DIR/config/tmux" "$CONFIG_HOME/"

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# zellij
#--------------------------------------------------

setup_zellij() {
  info "Start: ${FUNCNAME[0]}"

  mkdir -p "$CONFIG_HOME/zsh/completions"
  zellij setup --generate-completion zsh >"$CONFIG_HOME/zsh/completions/_zellij"

  #cp -r "$SCRIPT_DIR/config/zellij" "$CONFIG_HOME"
  backup_dir "$CONFIG_HOME/zellij"
  ln -s "$SCRIPT_DIR/config/zellij" "$CONFIG_HOME/"

  info "End: ${FUNCNAME[0]}"
  return 0
}

#--------------------------------------------------
# settings only
#--------------------------------------------------

apply_settings() {
  info "Start: ${FUNCNAME[0]}"

  # cp "$SCRIPT_DIR"/config/bash/.bashrc "$HOME"
  # cp "$SCRIPT_DIR"/config/bash/.bash_aliases "$HOME"
  for pn in {alacritty,bat,lazygit,ripgrep,starship,tmux,zellij,zsh}; do
    # mv directory or unlink
    backup_dir "$CONFIG_HOME/$pn"

    # apply setting
    ln -s "$SCRIPT_DIR/config/$pn" "$CONFIG_HOME/"
  done

  # nvim config
  cp "$SCRIPT_DIR"/config/nvim/lua/config/*.lua "$CONFIG_HOME/nvim/lua/config/"
  cp "$SCRIPT_DIR"/config/nvim/lua/plugins/*.lua "$CONFIG_HOME/nvim/lua/plugins/"
  cp "$SCRIPT_DIR"/config/nvim/lazy-lock.json "$CONFIG_HOME/nvim/"
  cp "$SCRIPT_DIR"/config/nvim/lazyvim.json "$CONFIG_HOME/nvim/"

  # cp -r "$SCRIPT_DIR"/config/alacritty "$CONFIG_HOME"
  # cp -r "$SCRIPT_DIR/config/zsh" "$CONFIG_HOME/"
  # cp -r "$SCRIPT_DIR"/config/terminator "$CONFIG_HOME"
  # cp -r "$SCRIPT_DIR"/config/starship "$CONFIG_HOME"
  # cp -r "$SCRIPT_DIR"/config/lazygit "$CONFIG_HOME"
  # cp -r "$SCRIPT_DIR"/config/tmux "$CONFIG_HOME"
  # cp -r "$SCRIPT_DIR/config/zellij" "$CONFIG_HOME"

  info "End: ${FUNCNAME[0]}"
}

echo_list() {
  package_manager="${1:-none}"

  local package_managers=("--apt" "--brew" "--pkg" "--snap")
  if printf '%s\n' "${package_managers[@]}" | grep -qx -- "$package_manager"; then
    info "$package_manager option found."
  else
    if is_gum_available; then
      package_manager=$(gum choose -- "${package_managers[@]}")
    else
      echo_allcommand_usage
      exit 1
    fi
  fi

  case "$package_manager" in
  apt | --apt)
    info '# Basic packages'
    cat "$SCRIPT_DIR"/assets/txt/apt-basic-packages.txt | sort | xargs -i echo '- {}'

    info ""
    info '# Packages'
    cat "$SCRIPT_DIR"/assets/txt/apt-packages.txt | sort | xargs -i echo '- {}'
    ;;
  brew | --brew)
    info '# Homebrew packages'
    grep -v ^# "$SCRIPT_DIR"/Brewfile | grep -o "\".*\"" | sort | xargs -i -n1 echo '- {}'
    ;;
  snap | --snap)
    info '# Snap packages'
    cat "$SCRIPT_DIR"/assets/txt/snap-packages.txt | sort | xargs -i echo '- {}'
    ;;
  pkg | --pkg)
    info '# Termux pkg packages'
    cat "$SCRIPT_DIR"/assets/txt/pkg-packages.txt | sort | xargs -i echo '- {}'
    ;;
  *)
    error 'No list found. Usage: dots list {--apt|--brew|--pkg|--snap}'
    ;;
  esac

  return 0
}

###################################################
# dev
###################################################

update_packages() {
  info "Start updating packages"

  bash "$SCRIPT_DIR/assets/scripts/update-packages.sh"

  info "End updating packages"
  return 0
}

#--------------------------------------------------
# Docker
#--------------------------------------------------

docker_test() {
  info "Start docker testing"

  distribution="${1:-}"

  if [ ! -f ./Dockerfile ] || [ ! -d assets ]; then
    info 'Dockerfile not found'
    cd "$SCRIPT_DIR"

    info "cd $SCRIPT_DIR"
  fi

  if [ -z "$distribution" ]; then
    if is_gum_available; then
      distribution=$(gum choose ubuntu ubuntu-22.04 arch fedora)
    else
      info "No distribution found."
      exit 1
    fi
  fi

  bash "$SCRIPT_DIR/assets/scripts/docker-test.sh" "$distribution"

  info "End docker testing"
  return 0
}

#--------------------------------------------------
# clean
#--------------------------------------------------

clean() {
  info "Start clean up process"

  local res

  # Remove cache files
  CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
  CACHE_DIR="$CACHE_HOME/dotfiles"
  rm -rf "$CACHE_DIR"/*
  success "Success: clean up $CACHE_DIR/*"

  # Remove dotfiles backup files
  if [[ "${1:-}" = "backup" || "${1:-}" = "all" ]]; then
    res=$(find "$DATA_HOME" -maxdepth 1 -name 'dotfiles*.bak*' 2>/dev/null || true)
    if [ -n "$res" ]; then
      rm -rf "$DATA_HOME"/dotfiles*.bak*
      success "Success: clean up $DATA_HOME/dotfiles*.bak*"
    else
      success "Success: $DATA_HOME/dotfiles*.bak* directories are not found."
    fi
  fi

  # Remove config backup files
  if [[ "${1:-}" = "config" || "${1:-}" = "all" ]]; then
    res=$(find "$CONFIG_HOME" -maxdepth 1 -name '*.bak*' 2>/dev/null || true)
    if [ -n "$res" ]; then
      rm -rf "$CONFIG_HOME"/*.bak*
      success "Success: clean up $CONFIG_HOME/*.bak*"
    else
      success "Success: $CONFIG_HOME/*.bak* directories are not found."
    fi
  fi

  info "End clean up process"

  return 0
}

#--------------------------------------------------
# THEME
#--------------------------------------------------

get_theme() {
  # get theme
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

set_theme() {
  value="${1:-}"

  current_theme=$(get_theme)
  info -ny -cb "Current theme: "
  info -cn "$current_theme"

  # check if value is a number
  if [[ "$1" =~ ^[1-9][0-9]*$ ]]; then
    index=$(($1 - 1)) # 1-based → 0-based index

    # check if index is in themes
    if ((index >= 0 && index < ${#themes[@]})); then
      value="${themes[index]}"
      info -ny -cb "Selected theme: "
      info -cn "$value\n"
    else
      error "Error: Invalid theme number." >&2
      return 1
    fi
  fi

  # set a random theme
  #if [[ ${value:-} == "random" ]]; then
  #  # shuf -i 0-15 -n 1
  #  n=$(((RANDOM + RANDOM + RANDOM) % 16))
  #  value="${themes[$n]}"
  #fi

  # check if value is in themes
  if printf '%s\n' "${themes[@]}" | grep -qx -- "$value"; then
    info "$value found."
  else
    if is_gum_available; then
      value=$(gum choose "${themes[@]}")
    else
      # error message
      error "Theme \"$value\" does not exist."

      info "Available themes:"
      i=1
      for theme in "${themes[@]}"; do
        if ((i < 10)); then
          formatted_index="[$i]"
        else
          printf -v formatted_index "[%2d]" "$i"
        fi
        info -cn "$(printf "%6s" "$formatted_index") $theme"
        ((i++))
      done

      exit 1
    fi
  fi

  # set theme
  sed -i "s/^THEME=.*/THEME=\"${value}\"/" "$CONFIG_HOME"/tmux/script/config.sh

  success -ny "Theme set to "
  info -ny -cn "$value"
  success " successfully.\n"

  # source tmux config
  if tmux info &>/dev/null; then
    info "tmux is running"
    info "source tmux config..."

    if is_gum_available; then
      gum spin -- tmux source-file "$CONFIG_HOME"/tmux/tmux.conf
    else
      tmux source-file "$CONFIG_HOME"/tmux/tmux.conf
    fi

    success "done!"
  else
    info "tmux is NOT running. done."
  fi

  exit 0
}

#--------------------------------------------------
# LANG
#--------------------------------------------------
ZSH_ENV_CONFIG_FILE="$HOME/.config/zsh/rc/02-env.zsh"

set_lang() {
  info -ny -cb "Current LANG: "
  info -cn "$LANG"

  local mode=1
  local new_lang=""

  case "${1:-}" in
  en_US | en_US.UTF-8 | en)
    mode=1
    ;;
  ja_JP | ja_JP.UTF-8 | ja)
    mode=2
    ;;
  C)
    mode=0
    ;;
  *)
    if is_gum_available; then
      value=$(gum choose "en_US.UTF-8" "ja_JP.UTF-8" "C") # TODO: locale -a
      case "${value:-}" in
      "en_US.UTF-8")
        mode=1
        ;;
      "ja_JP.UTF-8")
        mode=2
        ;;
      "C")
        mode=0
        ;;
      esac
    else
      echo "Usage: dots set-lang {en|ja|C}"
      exit 1
    fi
    ;;
  esac

  case "$mode" in
  0)
    new_lang="C"
    ;;
  1)
    # en_US.UTF-8 | en_US.utf8
    new_lang=$(locale -a | rg -i "en_US.UTF-?8" | head -n 1 | sed 's/\(en_US\)\.utf8/\1.UTF-8/I')
    ;;
  2)
    # ja_JP.UTF-8 | ja_JP.utf8
    new_lang=$(locale -a | rg -i "ja_JP.UTF-?8" | head -n 1 | sed 's/\(ja_JP\)\.utf8/\1.UTF-8/I')
    ;;
  *)
    error "Invalid mode: $mode (expected 0, 1, or 2)"
    return 1
    ;;
  esac

  info -ny -cb "Selected LANG: "
  info -cn "$new_lang\n"

  # locale not found
  if [[ -z "$new_lang" ]]; then
    error "No matching locale found for mode $mode."
    return 1
  fi

  # check if config file exists
  if [[ ! -f "$ZSH_ENV_CONFIG_FILE" ]]; then
    error "Config file not found: $ZSH_ENV_CONFIG_FILE"
    return 1
  fi

  # set LANG
  sed -i "s|^export LANG=[^#]*|export LANG=$new_lang|" "$ZSH_ENV_CONFIG_FILE"
  echo "Updated LANG in $ZSH_ENV_CONFIG_FILE to \"$new_lang\""
}

###################################################
# main
###################################################

if [ $# -le 0 ]; then
  info -cw "No parameter found."
  echo_allcommand_usage
  echo_each_command_usage
  exit 1
fi

case "$1" in
#--------------------------------------------------
# batch installation
#--------------------------------------------------
i | install)
  package_manager="${2:-}"

  if [ $# -le 1 ]; then
    if is_gum_available; then
      package_managers=("--apt" "--brew" "--pkg" "--snap" "cancel")
      package_manager=$(gum choose --header="Please select a package manager for batch installation" -- "${package_managers[@]}")

      if package_manager="cancel"; then
        info "Canceled."
        exit 0
      fi
    else
      echo_allcommand_usage
      exit 1
    fi
  fi

  case "$package_manager" in
  --apt)
    check_command apt

    info "Start installation with apt"
    install_apt_package
    install_gum
    setup_zsh
    install_fnm
    build_install_neovim
    install_lazyvim
    install_or_update_starship
    install_fzf_via_git
    setup_tmux
    install_hackgen
    install_rustup
    setup_git
    remove_zcompdump
    echo_completion_message
    info "End installation with apt"
    ;;
  --brew)
    info "Start installation with homebrew"
    install_homebrew
    setup_zsh
    install_node_by_fnm
    install_lazyvim
    setup_tmux
    setup_zellij
    install_hackgen
    setup_git
    remove_zcompdump
    echo_completion_message
    info "End installation with homebrew"
    ;;
  --snap)
    info "Start installation with apt and snap"
    check_command apt
    check_command snap

    info "Start installation with apt and snap"
    install_apt_package
    install_snap_package
    setup_zsh
    install_fnm
    install_lazyvim
    install_or_update_starship
    install_fzf_via_git
    setup_tmux
    install_hackgen
    setup_git
    remove_zcompdump
    echo_completion_message
    info "End installation with apt and snap"
    ;;
  --pkg)
    setup_termux
    remove_zcompdump
    ;;
  #--------------------------------------------------
  # individual installation
  #--------------------------------------------------
  apt-packages)
    install_apt_package
    ;;
  fnm)
    install_fnm
    ;;
  fzf)
    install_fzf_via_git
    ;;
  gum)
    install_gum
    ;;
  hackgen)
    install_hackgen
    ;;
  docker)
    install_docker
    ;;
  lazydocker)
    install_lazdocker
    ;;
  lazygit)
    build_install_lazygit
    ;;
  lazyvim)
    install_lazyvim
    ;;
  neovim)
    build_install_neovim
    install_lazyvim
    ;;
  # nvm)
  #   install_nvm
  #   ;;
  rustdesk)
    install_rustdesk
    ;;
  rustup)
    install_rustup
    ;;
  snap-packages)
    install_snap_package
    ;;
  starship)
    install_or_update_starship
    ;;
  zed)
    install_zed
    ;;
  *)
    echo_allcommand_usage
    exit 1
    ;;
  esac
  ;;

#--------------------------------------------------
# setup
#--------------------------------------------------
setup)
  if [ $# -le 1 ]; then
    echo_allcommand_usage
    exit 1
  fi

  case "$2" in
  git)
    setup_git
    ;;
  tmux)
    setup_tmux
    ;;
  zellij)
    setup_zellij
    ;;
  zsh)
    setup_zsh
    ;;
    # terminator)
    #   setup_terminator
    #   ;;
  *)
    echo_allcommand_usage
    exit 1
    ;;
  esac
  ;;

#--------------------------------------------------
# update all
#--------------------------------------------------
up | update | upgrade)
  if [ $# -le 1 ]; then
    update_packages
  else
    case "${2:-}" in
    all)
      update_packages
      ;;
    *)
      echo_allcommand_usage
      exit 1
      ;;
    esac
  fi
  ;;

#--------------------------------------------------
# docker
#--------------------------------------------------
docker)
  if [ $# -le 1 ]; then
    echo_allcommand_usage
    exit 1
  fi

  case "${2:-}" in
  test)
    check_command docker

    docker_test "${3:-}"
    #exit 0
    ;;
  *)
    echo_allcommand_usage
    exit 1
    ;;
  esac
  ;;

#--------------------------------------------------
# clean
#--------------------------------------------------
clean)
  if [ $# -le 1 ]; then
    clean
    exit 0
  fi

  case "${2:-}" in
  backup | config | all)
    clean "${2:-}"
    exit 0
    ;;
  *)
    echo_allcommand_usage
    exit 1
    ;;
  esac
  ;;

apply)
  apply_settings
  ;;
# bash)
#   setup_bash
#   ;;
backup)
  backup_dotfiles
  ;;
ls | list)
  echo_list "${2:-}"
  ;;
help | -h | --help)
  echo_allcommand_usage
  echo_each_command_usage
  exit 0
  ;;
version | -v | --version)
  VERSION=$(cat "$SCRIPT_DIR"/assets/txt/version.txt)
  echo "dotfiles version: $VERSION"
  echo "MIT License (c) 2025 irichu"
  exit 0
  ;;
theme)
  get_theme
  exit 0
  ;;
set-theme)
  set_theme "${2:-}"
  ;;
set-lang)
  set_lang "${2:-}"
  ;;
*)
  info -cw "No parameter found."
  echo_allcommand_usage
  echo_each_command_usage
  exit 2
  ;;
esac

success "completed!"
