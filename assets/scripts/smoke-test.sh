#!/usr/bin/env bash

set -Eeuo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
test_root="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-smoke.XXXXXX")"
trap 'rm -rf -- "$test_root"' EXIT

export HOME="$test_root/home"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_HOME="$HOME/.local/share"
export PATH="$HOME/.local/bin:$PATH"
mkdir -p "$HOME/.local/bin"
printf '#!/bin/sh\necho user-command\n' >"$HOME/.local/bin/dots"
mkdir -p "$XDG_CONFIG_HOME/zsh/completions"
printf 'legacy-history\n' >"$XDG_CONFIG_HOME/zsh/.zsh_history"
printf '# legacy completion\n' >"$XDG_CONFIG_HOME/zsh/completions/_legacy"

cd "$repo_root"
install_output="$(NO_COLOR=1 bash install.sh)"
printf '%s\n' "$install_output"
[[ "$install_output" == *"please consider starring it on GitHub"* ]]
[[ "$install_output" != *$'\033'* ]]
grep -Fq '[INFO] Installing from local checkout:' "$XDG_STATE_HOME/dotfiles/debug.log"
grep -Fq '[SUCCESS] Installation completed' "$XDG_STATE_HOME/dotfiles/debug.log"
bash install.sh --help | grep -Fq -- '--gum'
grep -Rqx 'echo user-command' "$XDG_STATE_HOME/dotfiles/install-backups"
grep -qx 'legacy-history' "$XDG_STATE_HOME/zsh/history"
grep -qx '# legacy completion' "$XDG_DATA_HOME/zsh/completions/_legacy"
printf 'current-history\n' >"$XDG_STATE_HOME/zsh/history"
printf '# current completion\n' >"$XDG_DATA_HOME/zsh/completions/_legacy"
NO_COLOR=1 bash install.sh >/dev/null
grep -qx 'current-history' "$XDG_STATE_HOME/zsh/history"
grep -qx '# current completion' "$XDG_DATA_HOME/zsh/completions/_legacy"

source "$XDG_DATA_HOME/dotfiles-main/assets/scripts/lib/core.sh"
for batch_mode in --apt --brew --flatpak --pkg --snap --ubuntu-desktop; do
  AUTO_YES=false
  enable_batch_install_auto_yes install "$batch_mode"
  [ "$AUTO_YES" = true ]
done
AUTO_YES=false
enable_batch_install_auto_yes apply core
[ "$AUTO_YES" = false ]

AUTO_YES=true
EXPLICIT_YES=true
confirm_unless_explicit_yes "Proceed?" | grep -Fq 'yes (--yes)'

ubuntu_os_release="$test_root/ubuntu-os-release"
printf 'ID=ubuntu\nVERSION_ID="26.04"\n' >"$ubuntu_os_release"
DOTS_OS_RELEASE_FILE="$ubuntu_os_release"
[ "$(ubuntu_desktop_apt_terminal_packages)" = $'alacritty\nghostty' ]
unset DOTS_OS_RELEASE_FILE

source "$XDG_DATA_HOME/dotfiles-main/assets/scripts/desktop/install-obsidian.sh"
obsidian_version="$(printf '%s\n' '{"latestVersion":"1.13.7","beta":{"latestVersion":"1.13.8"}}' | parse_obsidian_desktop_version)"
[ "$obsidian_version" = 1.13.7 ]
[[ "$(obsidian_download_url x86_64 "$obsidian_version")" == */v1.13.7/obsidian_1.13.7_amd64.deb ]]

desktop_entry_test_dir="$test_root/applications"
mkdir -p "$desktop_entry_test_dir"
touch \
  "$desktop_entry_test_dir/Alacritty.desktop" \
  "$desktop_entry_test_dir/com.mitchellh.ghostty.desktop" \
  "$desktop_entry_test_dir/org.mozilla.thunderbird_esr.desktop"
DOTS_DESKTOP_ENTRY_DIRS="$desktop_entry_test_dir"
source "$XDG_DATA_HOME/dotfiles-main/assets/scripts/desktop/desktop-favorites.sh"
[ "$(desktop_favorites_gvariant)" = "@as ['org.mozilla.thunderbird_esr.desktop', 'Alacritty.desktop', 'com.mitchellh.ghostty.desktop']" ]
unset DOTS_DESKTOP_ENTRY_DIRS

info() { :; }
success() { :; }
warning() { :; }
error() { :; }
source "$XDG_DATA_HOME/dotfiles-main/assets/scripts/lib/batch.sh"
batch_test_fail() { return 7; }
batch_test_continue() { printf 'continued\n' >"$test_root/batch-continued"; }
reset_batch_results
run_batch_plan batch_test_fail batch_test_continue
[ "$BATCH_FAILURES" -eq 1 ]
[ -f "$test_root/batch-continued" ]
if finish_batch_install; then
  echo "Batch failure summary unexpectedly succeeded" >&2
  exit 1
fi
reset_batch_results

dots doctor

mkdir -p "$XDG_CONFIG_HOME/bat"
printf 'keep-me\n' >"$XDG_CONFIG_HOME/bat/local.conf"
mkdir -p "$XDG_CONFIG_HOME/zsh"
printf 'keep-zsh\n' >"$XDG_CONFIG_HOME/zsh/local.zsh"
dots --yes apply bat zsh
[ -L "$XDG_CONFIG_HOME/bat" ]
[ -L "$XDG_CONFIG_HOME/zsh" ]
[ -f "$XDG_STATE_HOME/zsh/history" ]
[ -f "$XDG_DATA_HOME/zsh/completions/_legacy" ]

dots --yes rollback latest
[ ! -L "$XDG_CONFIG_HOME/bat" ]
[ ! -L "$XDG_CONFIG_HOME/zsh" ]
grep -qx 'keep-me' "$XDG_CONFIG_HOME/bat/local.conf"
grep -qx 'keep-zsh' "$XDG_CONFIG_HOME/zsh/local.zsh"

dots --yes apply bat nvim
[ -L "$XDG_CONFIG_HOME/bat" ]
[ -f "$XDG_CONFIG_HOME/nvim/lazyvim.json" ]

dots --yes uninstall
[ ! -e "$XDG_CONFIG_HOME/bat" ]
[ -f "$XDG_CONFIG_HOME/nvim/lazyvim.json" ]
[ ! -e "$HOME/.local/bin/dots" ]

echo "Dotfiles smoke test passed."
