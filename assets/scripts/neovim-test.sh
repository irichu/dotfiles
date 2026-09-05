#!/usr/bin/env bash

set -Eeuo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
test_root=$(mktemp -d)
trap 'rm -rf -- "$test_root"' EXIT
source "$repo_root/assets/scripts/lib/neovim.sh"

error() { printf '%s\n' "$*" >&2; }
info() { :; }

# Use real archives and file operations, but redirect every privileged path.
sudo() {
  local operation="$1" arg
  local args=()
  shift
  for arg in "$@"; do
    case "$arg" in
    /usr/bin | /usr/lib | /usr/share | /usr/bin/nvim | /usr/lib/nvim | /usr/share/nvim)
      args+=("$test_root/system$arg")
      ;;
    /*)
      [[ "$arg" == "$TMPDIR/"* ]] || return 99
      args+=("$arg")
      ;;
    *) args+=("$arg") ;;
    esac
  done
  if [[ "$scenario" == "fail-$operation" ]]; then
    return 1
  fi
  command "$operation" "${args[@]}"
}

wget() {
  [[ "$1" == -O ]]
  [[ "$3" == "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-${ARCH_GH}.tar.gz" ]]
  if [[ "$scenario" == download-failure ]]; then
    return 1
  fi
  cp "$test_root/release.tar.gz" "$2"
}

for scenario in fresh upgrade arm64 download-failure corrupt missing-binary missing-lib missing-share fail-mkdir fail-rm fail-mv fail-install; do
  rm -rf -- "$test_root/system" "$test_root/fixture" "$test_root/staging"
  export TMPDIR="$test_root/staging"
  mkdir -p "$TMPDIR"
  ARCH_GH=x86_64
  [[ "$scenario" != arm64 ]] || ARCH_GH=arm64
  release="$test_root/fixture/nvim-linux-$ARCH_GH"
  mkdir -p "$release/bin" "$release/lib/nvim" "$release/share/nvim/runtime"
  printf 'new binary\n' >"$release/bin/nvim"
  printf 'new library\n' >"$release/lib/nvim/new.so"
  printf 'new runtime\n' >"$release/share/nvim/runtime/new.vim"
  case "$scenario" in
  missing-binary) rm "$release/bin/nvim" ;;
  missing-lib) rm -r "$release/lib/nvim" ;;
  missing-share) rm -r "$release/share/nvim" ;;
  esac
  tar -czf "$test_root/release.tar.gz" -C "$test_root/fixture" "nvim-linux-$ARCH_GH"
  [[ "$scenario" != corrupt ]] || printf 'invalid archive\n' >"$test_root/release.tar.gz"

  if [[ "$scenario" != fresh ]]; then
    mkdir -p "$test_root/system/usr/bin" "$test_root/system/usr/lib/nvim" "$test_root/system/usr/share/nvim"
    printf 'old binary\n' >"$test_root/system/usr/bin/nvim"
    touch "$test_root/system/usr/lib/nvim/obsolete.so" "$test_root/system/usr/share/nvim/obsolete.vim"
  fi

  status=0
  install_neovim_release >"$test_root/output" 2>&1 || status=$?
  case "$scenario" in
  fresh | upgrade | arm64)
    [[ "$status" == 0 ]]
    [[ "$(cat "$test_root/system/usr/bin/nvim")" == 'new binary' ]]
    [[ "$(cat "$test_root/system/usr/lib/nvim/new.so")" == 'new library' ]]
    [[ "$(cat "$test_root/system/usr/share/nvim/runtime/new.vim")" == 'new runtime' ]]
    [[ ! -e "$test_root/system/usr/lib/nvim/obsolete.so" ]]
    [[ ! -e "$test_root/system/usr/share/nvim/obsolete.vim" ]]
    [[ ! -e "$test_root/system/usr/lib/nvim/nvim" ]]
    [[ ! -e "$test_root/system/usr/share/nvim/nvim" ]]
    ;;
  *)
    [[ "$status" != 0 ]]
    case "$scenario" in
    download-failure | corrupt | missing-* | fail-mkdir | fail-rm)
      [[ "$(cat "$test_root/system/usr/bin/nvim")" == 'old binary' ]]
      [[ -f "$test_root/system/usr/lib/nvim/obsolete.so" ]]
      [[ -f "$test_root/system/usr/share/nvim/obsolete.vim" ]]
      ;;
    esac
    ;;
  esac
  [[ -z "$(ls -A "$TMPDIR")" ]]
  printf 'PASS: %s\n' "$scenario"
done

# Exercise the real function and CLI branch without running global setup.
eval "$(sed -n '/^build_install_neovim() {$/,/^}$/p' "$repo_root/assets/scripts/main.sh" | tr -d '\r')"
install_neovim_release() { return 1; }
mkdir() { touch "$test_root/unexpected-config"; return 1; }
install_lazyvim() { touch "$test_root/unexpected-lazyvim"; }
export CONFIG_HOME="$test_root/config"
status=0
build_install_neovim || status=$?
[[ "$status" != 0 && ! -e "$test_root/unexpected-config" ]]
status=0
(
  eval "$(sed -n '/^  neovim)$/,/^    ;;$/p' "$repo_root/assets/scripts/main.sh" | sed '1d;$d' | tr -d '\r')"
  touch "$test_root/unexpected-success"
) || status=$?
[[ "$status" != 0 ]]
[[ ! -e "$test_root/unexpected-lazyvim" && ! -e "$test_root/unexpected-success" ]]
printf 'PASS: installer and CLI stop on Neovim failure\n'
