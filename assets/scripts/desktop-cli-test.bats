#!/usr/bin/env bats

setup() {
  export TEST_REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  export CLI_LOG="$BATS_TEST_TMPDIR/cli.log"
  export CLI_HARNESS="$BATS_TEST_TMPDIR/harness.sh"
  : >"$CLI_LOG"
  cat >"$CLI_HARNESS" <<'EOF'
set -Eeuo pipefail
SCRIPT_DIR="$TEST_REPO_ROOT"
source "$SCRIPT_DIR/assets/scripts/lib/batch.sh"
info() { :; }; success() { :; }; warning() { echo "$*"; }; error() { echo "$*"; }
for name in install_desktop_cli_snap install_ubuntu_desktop_cli; do
  eval "$(sed -n "/^$name() {$/,/^}$/p" "$SCRIPT_DIR/assets/scripts/main.sh" | tr -d '\r')"
done
snap() { [ "$1" = list ] && [ "${CLI_INSTALLED:-}" = "$2" ]; }
sudo() {
  printf '%s\n' "$*" >>"$CLI_LOG"
  [ "${CLI_FAIL:-}" != "$3" ] || return 7
}
setup_zellij() { echo setup_zellij >>"$CLI_LOG"; }
EOF
}

@test "Desktop CLI installs the five Snap tools and configures Zellij after installation" {
  run bash -c 'source "$CLI_HARNESS"; install_ubuntu_desktop_cli; finish_batch_install'
  [ "$status" -eq 0 ]
  [ "$(cat "$CLI_LOG")" = $'snap install difftastic\nsnap install dog\nsnap install dust\nsnap install go --classic\nsnap install zellij --classic\nsetup_zellij' ]
}

@test "Desktop CLI skips installed packages and still configures installed Zellij" {
  export CLI_INSTALLED=zellij
  run bash -c 'source "$CLI_HARNESS"; install_desktop_cli_snap zellij --classic'
  [ "$status" -eq 0 ]
  [ "$(cat "$CLI_LOG")" = setup_zellij ]
}

@test "Desktop CLI reports failures while continuing independent packages" {
  for CLI_FAIL in dog zellij; do
    export CLI_FAIL
    : >"$CLI_LOG"
    run bash -c '
      source "$CLI_HARNESS"
      install_ubuntu_desktop_cli
      run_batch_step independent printf "independent completed\n"
      finish_batch_install
    '
    [ "$status" -eq 1 ]
    [[ "$output" == *"snap $CLI_FAIL (exit 7)"* && "$output" == *'independent completed'* ]]
    grep -q 'snap install go --classic' "$CLI_LOG"
    if [ "$CLI_FAIL" = zellij ]; then
      ! grep -q setup_zellij "$CLI_LOG"
    fi
  done
}

@test "Desktop shares APT Neovim and Rustup installers without scheduling their Snap versions" {
  for mode in --apt --ubuntu-desktop; do
    run bash -c '
      source "$CLI_HARNESS"
      show_ubuntu_desktop_install_notice() { :; }
      confirm_unless_explicit_yes() { return 0; }
      start_desktop_inhibit() { :; }; stop_desktop_inhibit() { :; }
      run_batch_step() { printf "%s\n" "$1"; }
      run_batch_plan() { printf "%s\n" "$@"; }
      run_batch_dependent_plan() { printf "%s\n" "$@"; }
      eval "$(sed -n "/^  $1)$/,/^    ;;$/p" "$SCRIPT_DIR/assets/scripts/main.sh" | sed "1d;\$d" | tr -d "\r")"
    ' bash "$mode"
    [ "$status" -eq 0 ]
    [[ "$output" == *$'build_install_neovim\ninstall_lazyvim'* ]]
    [[ "$output" == *install_rustup* ]]
    [[ "$output" != *'snap rustup'* && "$output" != *'snap nvim'* ]]
    if [ "$mode" = --ubuntu-desktop ]; then
      [[ "$output" == *'snap go'* && "$output" == *install_ubuntu_desktop_terminals* && "$output" == *install_chrome* ]]
    else
      [[ "$output" != *'snap go'* ]]
    fi
  done
}
