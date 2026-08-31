#!/usr/bin/env bash

set -Eeuo pipefail

export LC_ALL=C

readonly DOTFILES_REPOSITORY="${DOTFILES_REPOSITORY:-irichu/dotfiles}"
readonly CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
readonly CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
readonly STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
readonly DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
readonly CACHE_DIR="$CACHE_HOME/dotfiles"
readonly STATE_DIR="$STATE_HOME/dotfiles"
readonly DATA_DIR="$DATA_HOME/dotfiles-main"
readonly BIN_DIR="$HOME/.local/bin"

CHANNEL="stable"
REQUESTED_VERSION=""
FORCE_REMOTE=false
DEBUG="${DEBUG:-false}"
INSTALL_GUM=false

usage() {
  cat <<'EOF'
Usage: install.sh [options]

Options:
  --version <tag>   Install a specific release tag (for example v1.2.0)
  --channel <name>  Install from "stable" (default) or "main"
  --remote          Ignore a local checkout and download the selected channel
  --gum             Install Gum and generate its Zsh completion
  --debug           Enable verbose shell tracing
  -h, --help        Show this help
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
  --version)
    [ "$#" -ge 2 ] || { echo "--version requires a tag" >&2; exit 2; }
    REQUESTED_VERSION="$2"
    shift 2
    ;;
  --channel)
    [ "$#" -ge 2 ] || { echo "--channel requires stable or main" >&2; exit 2; }
    CHANNEL="$2"
    shift 2
    ;;
  --remote)
    FORCE_REMOTE=true
    shift
    ;;
  --gum)
    INSTALL_GUM=true
    shift
    ;;
  --debug)
    DEBUG=true
    shift
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echo "Unknown option: $1" >&2
    usage >&2
    exit 2
    ;;
  esac
done

case "$CHANNEL" in
stable | main) ;;
*)
  echo "Unsupported channel: $CHANNEL (expected stable or main)" >&2
  exit 2
  ;;
esac

if [ -n "$REQUESTED_VERSION" ] && [ "$CHANNEL" = "main" ]; then
  echo "--version and --channel main cannot be used together" >&2
  exit 2
fi

[ "$DEBUG" = true ] && set -x

mkdir -p "$CONFIG_HOME" "$CACHE_DIR" "$STATE_DIR" "$DATA_HOME" "$BIN_DIR"

GIT_USER_NAME=""
GIT_USER_EMAIL=""
if command -v git >/dev/null 2>&1; then
  GIT_USER_NAME="$(git config user.name || true)"
  GIT_USER_EMAIL="$(git config user.email || true)"
fi

TEMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-install.XXXXXX")"
STAGING_DIR="$DATA_HOME/.dotfiles-main.staging.$$"

cleanup() {
  rm -rf -- "$TEMP_DIR"
  if [ -d "$STAGING_DIR" ]; then
    rm -rf -- "$STAGING_DIR"
  fi
}
trap cleanup EXIT INT TERM

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  COLOR_BLUE='\033[0;34m'
  COLOR_GREEN='\033[0;32m'
  COLOR_RED='\033[0;31m'
  COLOR_YELLOW='\033[1;33m'
  COLOR_RESET='\033[0m'
else
  COLOR_BLUE=''
  COLOR_GREEN=''
  COLOR_RED=''
  COLOR_YELLOW=''
  COLOR_RESET=''
fi

log() {
  write_log INFO "$*"
  printf '%b[dotfiles] %s%b\n' "$COLOR_BLUE" "$*" "$COLOR_RESET"
}

success() {
  write_log SUCCESS "$*"
  printf '%b[dotfiles] %s%b\n' "$COLOR_GREEN" "$*" "$COLOR_RESET"
}

warning() {
  write_log WARNING "$*"
  printf '%b[dotfiles] WARNING: %s%b\n' "$COLOR_YELLOW" "$*" "$COLOR_RESET" >&2
}

die() {
  write_log ERROR "$*"
  printf '%b[dotfiles] ERROR: %s%b\n' "$COLOR_RED" "$*" "$COLOR_RESET" >&2
  exit 1
}

write_log() {
  local level="$1"
  shift
  local timestamp
  timestamp="$(date +'%Y-%m-%d %H:%M:%S')"
  printf '[%s][%s] %s\n' "$timestamp" "$level" "$*" >>"$STATE_DIR/debug.log"
  if [ "$level" = ERROR ]; then
    printf '[%s][%s] %s\n' "$timestamp" "$level" "$*" >>"$STATE_DIR/errors.log"
  fi
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

download() {
  url="$1"
  destination="$2"
  if command_exists curl; then
    curl --fail --location --silent --show-error "$url" --output "$destination"
  elif command_exists wget; then
    wget --quiet "$url" --output-document="$destination"
  else
    die "curl or wget is required"
  fi
}

sha256_file() {
  if command_exists sha256sum; then
    sha256sum "$1" | awk '{print $1}'
  elif command_exists shasum; then
    shasum -a 256 "$1" | awk '{print $1}'
  else
    die "sha256sum or shasum is required to verify a release"
  fi
}

latest_release_tag() {
  redirect_url=""
  if command_exists curl; then
    redirect_url="$(curl --fail --location --silent --show-error --output /dev/null --write-out '%{url_effective}' \
      "https://github.com/$DOTFILES_REPOSITORY/releases/latest")"
  elif command_exists wget; then
    redirect_url="$(wget --server-response --max-redirect=0 \
      "https://github.com/$DOTFILES_REPOSITORY/releases/latest" 2>&1 \
      | awk '/^  Location: / {print $2}' | tr -d '\r' | tail -n 1)"
  fi
  tag="${redirect_url##*/}"
  [ -n "$tag" ] || die "could not determine the latest release"
  printf '%s\n' "$tag"
}

copy_local_checkout() {
  source_dir="$1"
  log "Installing from local checkout: $source_dir"
  mkdir -p "$STAGING_DIR"
  cp -a "$source_dir/." "$STAGING_DIR/"
  rm -rf -- "$STAGING_DIR/.git"
}

download_release() {
  tag="${REQUESTED_VERSION:-$(latest_release_tag)}"
  version="${tag#v}"
  archive_name="dotfiles-$version.tar.gz"
  archive_path="$TEMP_DIR/$archive_name"
  checksum_path="$TEMP_DIR/SHA256SUMS"
  base_url="https://github.com/$DOTFILES_REPOSITORY/releases/download/$tag"

  log "Downloading stable release $tag"
  download "$base_url/$archive_name" "$archive_path"
  download "$base_url/SHA256SUMS" "$checksum_path"

  expected="$(awk -v name="$archive_name" '$2 == name || $2 == "*" name {print $1}' "$checksum_path" | head -n 1)"
  [ -n "$expected" ] || die "$archive_name is missing from SHA256SUMS"
  actual="$(sha256_file "$archive_path")"
  [ "$actual" = "$expected" ] || die "checksum verification failed for $archive_name"

  mkdir -p "$TEMP_DIR/extracted"
  tar -xzf "$archive_path" -C "$TEMP_DIR/extracted"
  extracted_root="$TEMP_DIR/extracted/dotfiles"
  if [ ! -d "$extracted_root" ]; then
    extracted_root="$TEMP_DIR/extracted"
  fi
  mkdir -p "$STAGING_DIR"
  cp -a "$extracted_root/." "$STAGING_DIR/"
}

download_main() {
  archive_path="$TEMP_DIR/main.tar.gz"
  log "Downloading the main development channel (checksum verification unavailable)"
  download "https://github.com/$DOTFILES_REPOSITORY/archive/refs/heads/main.tar.gz" "$archive_path"
  mkdir -p "$TEMP_DIR/extracted"
  tar -xzf "$archive_path" -C "$TEMP_DIR/extracted"
  extracted_root="$(find "$TEMP_DIR/extracted" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
  [ -n "$extracted_root" ] || die "downloaded archive has an unexpected layout"
  mkdir -p "$STAGING_DIR"
  cp -a "$extracted_root/." "$STAGING_DIR/"
}

install_command() {
  local destination="$1"
  local source="$DATA_DIR/assets/scripts/main.sh"
  if { [ -e "$destination" ] || [ -L "$destination" ]; } && ! cmp -s "$destination" "$source"; then
    local backup_root="$STATE_DIR/install-backups"
    local backup_dir
    mkdir -p "$backup_root"
    backup_dir="$(mktemp -d "$backup_root/$(date +'%Y%m%d-%H%M%S')-XXXXXX")"
    local backup="$backup_dir/dots"
    mv -- "$destination" "$backup"
    log "Existing command preserved at: $backup"
  fi
  cp -f -- "$source" "$destination"
  chmod +x "$destination"
}

preserve_zsh_state() {
  local legacy_history="$CONFIG_HOME/zsh/.zsh_history"
  local history_dir="$STATE_HOME/zsh"
  local history_file="$history_dir/history"
  local legacy_completions="$CONFIG_HOME/zsh/completions"
  local completions_dir="$DATA_HOME/zsh/completions"
  local entry destination

  mkdir -p "$history_dir" "$completions_dir"
  if [ -f "$legacy_history" ] && [ ! -e "$history_file" ]; then
    cp -p -- "$legacy_history" "$history_file"
    log "Preserved Zsh history at: $history_file"
  fi

  if [ -d "$legacy_completions" ]; then
    while IFS= read -r entry; do
      destination="$completions_dir/$(basename "$entry")"
      if [ ! -e "$destination" ] && [ ! -L "$destination" ]; then
        cp -a -- "$entry" "$destination"
      fi
    done < <(find "$legacy_completions" -mindepth 1 -maxdepth 1 -print)
    log "Preserved Zsh completions at: $completions_dir"
  fi
}

install_staged_tree() {
  # Local checkouts created on Windows may contain CRLF even though these files
  # execute in a Unix environment. Normalize only the staged copy.
  while IFS= read -r script_file; do
    if grep -q $'\r$' "$script_file"; then
      sed -i 's/\r$//' "$script_file"
    fi
  done < <(find "$STAGING_DIR" -type f \( -name '*.sh' -o -name '*.bash' -o -name '*.zsh' \))

  [ -f "$STAGING_DIR/assets/scripts/main.sh" ] || die "staged tree is missing assets/scripts/main.sh"
  [ -d "$STAGING_DIR/config" ] || die "staged tree is missing config"

  previous_dir=""
  if [ -e "$DATA_DIR" ] || [ -L "$DATA_DIR" ]; then
    previous_dir="$(mktemp -d "$DATA_HOME/dotfiles-main.bak$(date +'%Y%m%d-%H%M%S')-XXXXXX")"
    rmdir "$previous_dir"
    mv -- "$DATA_DIR" "$previous_dir"
  fi

  if ! mv -- "$STAGING_DIR" "$DATA_DIR"; then
    if [ -n "$previous_dir" ] && [ -e "$previous_dir" ]; then
      mv -- "$previous_dir" "$DATA_DIR"
    fi
    die "could not activate the staged dotfiles tree"
  fi

  chmod +x "$DATA_DIR/assets/scripts/main.sh"
  install_command "$BIN_DIR/dots"
  if [ -d /data/data/com.termux/files/usr/bin ]; then
    install_command /data/data/com.termux/files/usr/bin/dots
  fi
}

preserve_user_state() {
  if command_exists git; then
    if [ -n "$GIT_USER_NAME" ] || [ -n "$GIT_USER_EMAIL" ]; then
      mkdir -p "$CONFIG_HOME/git"
      [ -e "$CONFIG_HOME/git/config" ] || touch "$CONFIG_HOME/git/config"
      [ -n "$GIT_USER_NAME" ] && git config -f "$CONFIG_HOME/git/config" user.name "$GIT_USER_NAME"
      [ -n "$GIT_USER_EMAIL" ] && git config -f "$CONFIG_HOME/git/config" user.email "$GIT_USER_EMAIL"
    fi
  fi

  [ -f "$HOME/.bashrc" ] || touch "$HOME/.bashrc"
  if ! grep -Fqx 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
    printf '%s\n' 'export PATH="$HOME/.local/bin:$PATH"' >>"$HOME/.bashrc"
  fi
}

ORIGINAL_DIR="$(pwd -P)"
preserve_zsh_state
if [ "$FORCE_REMOTE" = false ] && [ -f "$ORIGINAL_DIR/assets/scripts/main.sh" ]; then
  copy_local_checkout "$ORIGINAL_DIR"
elif [ "$CHANNEL" = "main" ]; then
  download_main
else
  download_release
fi

install_staged_tree
preserve_user_state

if "$INSTALL_GUM"; then
  log "Installing Gum (--gum compatibility mode)"
  "$BIN_DIR/dots" --yes install gum
fi

success "Installation completed"
log "Run: $BIN_DIR/dots doctor"
log "Then apply settings with: $BIN_DIR/dots apply"
printf '\n'
success "If you like this repository, please consider starring it on GitHub!"
success "https://github.com/$DOTFILES_REPOSITORY"
