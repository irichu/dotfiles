#!/usr/bin/env bash

# Shared safety helpers. This file is sourced by assets/scripts/main.sh after
# its UI helpers have been defined.

set -Eeuo pipefail

enable_batch_install_auto_yes() {
  [ "${1:-}" = install ] || return 0
  case "${2:-}" in
  --apt | --brew | --flatpak | --pkg | --snap | --ubuntu-desktop)
    AUTO_YES=true
    ;;
  esac
}

os_release_value() {
  local requested_key="${1:-}"
  local os_release_file="${DOTS_OS_RELEASE_FILE:-/etc/os-release}"
  local key value

  [ -n "$requested_key" ] || return 1
  [ -r "$os_release_file" ] || return 1

  while IFS='=' read -r key value; do
    [ "$key" = "$requested_key" ] || continue
    value="${value#\"}"
    value="${value%\"}"
    value="${value#\'}"
    value="${value%\'}"
    printf '%s\n' "$value"
    return 0
  done <"$os_release_file"

  return 1
}

ubuntu_version_at_least() {
  local required_major="${1:-0}"
  local required_minor="${2:-0}"
  local distro_id version_id
  local major minor

  distro_id="$(os_release_value ID)" || return 1
  [ "$distro_id" = ubuntu ] || return 1

  version_id="$(os_release_value VERSION_ID)" || return 1
  [[ "$version_id" =~ ^([0-9]+)\.([0-9]+) ]] || return 1
  major=$((10#${BASH_REMATCH[1]}))
  minor=$((10#${BASH_REMATCH[2]}))

  ((major > required_major || (major == required_major && minor >= required_minor)))
}

ubuntu_desktop_ghostty_method() {
  if ubuntu_version_at_least 26 4; then
    printf '%s\n' apt
  else
    printf '%s\n' snap
  fi
}

ubuntu_desktop_apt_terminal_packages() {
  if [ "$(ubuntu_desktop_ghostty_method)" = apt ]; then
    printf '%s\n' alacritty ghostty
  fi
}

show_ubuntu_desktop_install_notice() {
  echo "This process will download and install many packages (~15 minutes)."
  echo "Automatic screen blanking and suspend will be temporarily inhibited when available; saved power settings are unchanged."
  echo "At the beginning of the installation, GNOME extension installation dialogs may appear."
  echo "Please review the extension names below and click \"Install\" when prompted:"
  echo "- Alphabetical App Grid"
  echo "- Blur my Shell"
  echo "- Compiz alike magic lamp effect"
  echo "- Compiz windows effect"
  if ubuntu_version_at_least 26 4; then
    echo "- Copyous"
  fi
  echo "- Just Perfection"
  echo "- Space Bar"
  echo "- Tactile"
  echo "- TopHat"
  echo "- Undecorate Window"
  echo "- User Themes"
  echo "- Workspace Matrix"
  echo
}

prompt_for_confirmation() {
  local prompt="${1:-Are you sure?}"
  local reply

  if [[ ! -t 0 ]]; then
    error "Confirmation requires an interactive terminal; pass --yes to continue."
    return 1
  fi

  while true; do
    read -r -p "$prompt [y/N]: " reply
    case "$reply" in
    [Yy]) return 0 ;;
    [Nn] | "") return 1 ;;
    *) echo "Please answer y or n." ;;
    esac
  done
}

confirm() {
  local prompt="${1:-Are you sure?}"

  if "$AUTO_YES"; then
    echo "$prompt [y/N]: yes (auto)"
    return 0
  fi

  prompt_for_confirmation "$prompt"
}

confirm_unless_explicit_yes() {
  local prompt="${1:-Are you sure?}"

  if "${EXPLICIT_YES:-false}"; then
    echo "$prompt [y/N]: yes (--yes)"
    return 0
  fi

  prompt_for_confirmation "$prompt"
}

dots_platform() {
  if [ -n "${TERMUX_VERSION:-}" ]; then
    printf '%s\n' termux
    return
  fi
  case "$(uname -s)" in
  Darwin) printf '%s\n' darwin ;;
  Linux) printf '%s\n' linux ;;
  *) printf '%s\n' unknown ;;
  esac
}

path_is_within() {
  local path="$1"
  local parent="$2"
  case "$path/" in
  "$parent"/*) return 0 ;;
  *) return 1 ;;
  esac
}

safe_clear_directory() {
  local target="$1"
  local allowed_parent="$2"
  [ -n "$target" ] || { error "Refusing to clear an empty path"; return 1; }
  [ -d "$target" ] || return 0
  path_is_within "$target" "$allowed_parent" || {
    error "Refusing to clear path outside $allowed_parent: $target"
    return 1
  }
  find "$target" -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +
}
