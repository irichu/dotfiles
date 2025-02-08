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
  cd $(dirname $BASH_SOURCE)
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
DATA_DIR="$DATA_HOME/dotfiles"
mkdir -p "$DATA_DIR"
#echo $HOME/.{cache,config,local/state}/dotfiles | read cache_dir config_dir state_dir
#printf "%s\n" $HOME/.{cache,config,local/state}/dotfiles | xargs -I{} sh -c "mkdir -p $1" && echo "$1"' sh {}

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

  backup_dir "$CONFIG_HOME/zsh"
  ln -s "$SCRIPT_DIR/config/zsh" "$CONFIG_HOME/"

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

  unzip "$CACHE_DIR/HackGen_NF_v${LATEST_VERSION}.zip" -d $CACHE_DIR

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
  cat "$SCRIPT_DIR"/assets/txt/apt-packages.txt | xargs sudo apt-get install -y

  # .local install
  mkdir -p ~/.local/bin
  [ ! -f ~/.local/bin/bat ] && ln -s /usr/bin/batcat ~/.local/bin/bat
  [ ! -f ~/.local/bin/fd ] && ln -s /usr/bin/fdfind ~/.local/bin/fd

  backup_dir "$CONFIG_HOME/bat"
  ln -s "$SCRIPT_DIR/config/bat" "$CONFIG_HOME/"

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
    sudo dnf groupinstall -y 'Development Tools'
    sudo dnf install -y procps-ng curl file git
    sudo dnf install -y wget util-linux-user # for chsh
  elif cmd_exists pacman; then
    sudo pacman -S base-devel procps-ng curl file git --noconfirm
  fi

  if ! cmd_exists brew; then
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

  backup_dir "$CONFIG_HOME/starship"
  ln -s "$SCRIPT_DIR/config/starship" "$CONFIG_HOME/"

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
  cargo install --locked typst-cli
  cargo install --locked yazi-fm yazi-cli

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

  sudo groupadd docker
  sudo usermod -aG docker $CURRENT_USER

  sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  info 'docker --version'
  docker --version

  info 'docker compose version'
  docker compose version

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
  cp -r "$CONFIG_HOME"/* "$backup_path"

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

  #cp -r "$SCRIPT_DIR"/config/git "$CONFIG_HOME"
  backup_dir "$CONFIG_HOME/git"
  ln -s "$SCRIPT_DIR/config/git" "$CONFIG_HOME/"

  current_name=$(git config user.name)
  current_email=$(git config user.email)

  if [ -z "${GITHUB_ACTIONS:-}" ]; then
    read -rp "git user.name [$current_name]:" name
    read -rp "git user.email [$current_email]:" email
  fi

  git config -f ~/.config/git/config user.name "${name:-$current_name}"
  git config -f ~/.config/git/config user.email "${email:-$current_email}"

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
  for pn in {zsh,starship,alacritty,lazygit,tmux,zellij}; do
    backup_dir "$CONFIG_HOME/$pn"
  done

  cp -r "$SCRIPT_DIR/config/zsh" "$CONFIG_HOME/"

  # cp -r "$SCRIPT_DIR"/config/terminator "$CONFIG_HOME"
  cp -r "$SCRIPT_DIR"/config/starship "$CONFIG_HOME"
  cp -r "$SCRIPT_DIR"/config/alacritty "$CONFIG_HOME"
  cp -r "$SCRIPT_DIR"/config/lazygit "$CONFIG_HOME"

  cp "$SCRIPT_DIR"/config/nvim/lua/config/*.lua "$CONFIG_HOME/nvim/lua/config/"
  cp "$SCRIPT_DIR"/config/nvim/lua/plugins/*.lua "$CONFIG_HOME/nvim/lua/plugins/"
  cp "$SCRIPT_DIR"/config/nvim/lazy-lock.json "$CONFIG_HOME/nvim/"
  cp "$SCRIPT_DIR"/config/nvim/lazyvim.json "$CONFIG_HOME/nvim/"

  cp -r "$SCRIPT_DIR"/config/tmux "$CONFIG_HOME"
  cp -r "$SCRIPT_DIR/config/zellij" "$CONFIG_HOME"

  info "End: ${FUNCNAME[0]}"
}

echo_list() {
  target="$1"

  case "$1" in
  apt)
    info '# Basic packages'
    cat "$SCRIPT_DIR"/assets/txt/apt-basic-packages.txt | sort | xargs -i echo '- {}'

    info ""
    info '# Packages'
    cat "$SCRIPT_DIR"/assets/txt/apt-packages.txt | sort | xargs -i echo '- {}'
    ;;
  brew)
    info '# Homebrew packages'
    grep -v ^# "$SCRIPT_DIR"/Brewfile | grep -o "\".*\"" | sort | xargs -i -n1 echo '- {}'
    ;;
  snap)
    info '# Snap packages'
    cat "$SCRIPT_DIR"/assets/txt/snap-packages.txt | sort | xargs -i echo '- {}'
    ;;
  pkg)
    info '# Termux pkg packages'
    cat "$SCRIPT_DIR"/assets/txt/pkg-packages.txt | sort | xargs -i echo '- {}'
    ;;
  *)
    error 'No list found. Usage: ./install.sh list (apt|brew|snap)'
    ;;
  esac

  return 0
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
all)
  if [ $# -le 1 ]; then
    echo_allcommand_usage
    exit 1
  fi
  case "$2" in
  apt)
    check_command apt

    info "Start installation with apt"
    install_apt_package
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
    echo_completion_message
    info "End installation with apt"
    ;;
  brew)
    info "Start installation with homebrew"
    install_homebrew
    setup_zsh
    install_node_by_fnm
    install_lazyvim
    setup_tmux
    setup_zellij
    install_hackgen
    setup_git
    echo_completion_message
    info "End installation with homebrew"
    ;;
  snap)
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
    echo_completion_message
    info "End installation with apt and snap"
    ;;
  pkg | termux)
    setup_termux
    ;;
  *)
    echo_allcommand_usage
    exit 1
    ;;
  esac
  ;;
#--------------------------------------------------
# individual installation
#--------------------------------------------------
apply)
  apply_settings
  ;;
apt-packages)
  install_apt_package
  ;;
fnm)
  install_fnm
  ;;
fzf)
  install_fzf_via_git
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
#--------------------------------------------------
# setup
#--------------------------------------------------
# bash)
#   setup_bash
#   ;;
backup)
  backup_dotfiles
  ;;
git)
  setup_git
  ;;
# terminator)
#   setup_terminator
#   ;;
tmux)
  setup_tmux
  ;;
zellij)
  setup_zellij
  ;;
zsh)
  setup_zsh
  ;;
ls | list)
  echo_list "${2:-}"
  ;;
help | -h | --help)
  echo_allcommand_usage
  echo_each_command_usage
  exit 0
  ;;
*)
  info -cw "No parameter found."
  echo_allcommand_usage
  echo_each_command_usage
  exit 2
  ;;
esac

success "completed!"
