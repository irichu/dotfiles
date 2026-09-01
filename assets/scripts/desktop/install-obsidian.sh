#!/usr/bin/env bash

set -Eeuo pipefail

readonly OBSIDIAN_DESKTOP_RELEASES_URL="${OBSIDIAN_DESKTOP_RELEASES_URL:-https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/desktop-releases.json}"

parse_obsidian_desktop_version() {
  grep -o '"latestVersion"[[:space:]]*:[[:space:]]*"[^"]*"' |
    head -n 1 |
    sed 's/.*"\([^"]*\)"$/\1/'
}

obsidian_asset_name() {
  local arch="$1"
  local version="$2"

  case "$arch" in
  x86_64)
    printf 'obsidian_%s_amd64.deb\n' "$version"
    ;;
  aarch64 | arm64)
    printf 'Obsidian-%s-arm64.AppImage\n' "$version"
    ;;
  *)
    return 1
    ;;
  esac
}

obsidian_download_url() {
  local arch="$1"
  local version="$2"
  local asset

  asset="$(obsidian_asset_name "$arch" "$version")" || return 1
  printf 'https://github.com/obsidianmd/obsidian-releases/releases/download/v%s/%s\n' "$version" "$asset"
}

install_obsidian_desktop() (
  local arch manifest version asset url work_dir ubuntu_version
  arch="$(uname -m)"

  if ! manifest="$(curl -fsSL "$OBSIDIAN_DESKTOP_RELEASES_URL")"; then
    echo 'Failed to download the Obsidian desktop release metadata.' >&2
    return 1
  fi
  version="$(printf '%s\n' "$manifest" | parse_obsidian_desktop_version || true)"
  if [ -z "$version" ]; then
    echo 'Could not determine the latest Obsidian desktop version.' >&2
    return 1
  fi

  asset="$(obsidian_asset_name "$arch" "$version")" || {
    echo "Unsupported architecture: $arch" >&2
    return 1
  }
  url="$(obsidian_download_url "$arch" "$version")"

  mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles"
  work_dir="$(mktemp -d "${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles/obsidian.XXXXXX")"
  trap 'rm -rf -- "$work_dir"' EXIT

  curl -fL --retry 3 -o "$work_dir/$asset" "$url"
  test -s "$work_dir/$asset"

  case "$arch" in
  x86_64)
    sudo apt-get install -y "$work_dir/$asset"
    ;;
  aarch64 | arm64)
    ubuntu_version="$(. /etc/os-release && printf '%s' "${VERSION_ID:-0}")"
    if dpkg --compare-versions "$ubuntu_version" ge 24.04; then
      sudo apt-get install -y libfuse2t64
    else
      sudo apt-get install -y libfuse2
    fi

    chmod +x "$work_dir/$asset"
    (
      cd "$work_dir"
      "./$asset" --appimage-extract
    )
    mkdir -p "$HOME/.local/bin" "$HOME/.local/share"
    cp -rf "$work_dir/squashfs-root/usr/share/icons" "$HOME/.local/share/"
    install -m 0755 "$work_dir/$asset" "$HOME/.local/bin/obsidian"
    ;;
  esac

  export PATH="$HOME/.local/bin:$PATH"
  if ! command -v obsidian >/dev/null 2>&1; then
    echo 'Obsidian installation completed without providing the obsidian command.' >&2
    return 1
  fi

  echo "Installed Obsidian desktop $version successfully."
)

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  install_obsidian_desktop
fi
