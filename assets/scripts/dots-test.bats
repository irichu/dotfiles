#!/usr/bin/env bats

setup() {
  export TEST_REPO_ROOT
  TEST_REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  export HOME="$BATS_TEST_TMPDIR/home"
  export XDG_CONFIG_HOME="$HOME/.config"
  export XDG_CACHE_HOME="$HOME/.cache"
  export XDG_STATE_HOME="$HOME/.local/state"
  export XDG_DATA_HOME="$HOME/.local/share"
  export PATH="$HOME/.local/bin:$PATH"
  mkdir -p "$XDG_CONFIG_HOME/zsh/completions"
  printf 'legacy-history\n' >"$XDG_CONFIG_HOME/zsh/.zsh_history"
  printf '# legacy completion\n' >"$XDG_CONFIG_HOME/zsh/completions/_legacy"
  (cd "$TEST_REPO_ROOT" && bash install.sh)
}

dots_run() {
  run "$HOME/.local/bin/dots" "$@"
}

@test "batch installation modes enable automatic confirmation" {
  for mode in --apt --brew --flatpak --pkg --snap --ubuntu-desktop; do
    run bash -c 'AUTO_YES=false; source "$1"; enable_batch_install_auto_yes install "$2"; "$AUTO_YES"' \
      bash "$TEST_REPO_ROOT/assets/scripts/lib/core.sh" "$mode"
    [ "$status" -eq 0 ]
  done

  run bash -c 'AUTO_YES=false; source "$1"; enable_batch_install_auto_yes apply core; "$AUTO_YES"' \
    bash "$TEST_REPO_ROOT/assets/scripts/lib/core.sh"
  [ "$status" -ne 0 ]
}

@test "Ubuntu Desktop selects the Ghostty package source by Ubuntu version" {
  while IFS='|' read -r version expected; do
    os_release="$BATS_TEST_TMPDIR/os-release-$version"
    printf 'ID=ubuntu\nVERSION_ID="%s"\n' "$version" >"$os_release"

    run bash -c 'source "$1"; DOTS_OS_RELEASE_FILE="$2"; ubuntu_desktop_ghostty_method' \
      bash "$TEST_REPO_ROOT/assets/scripts/lib/core.sh" "$os_release"
    [ "$status" -eq 0 ]
    [ "$output" = "$expected" ]
  done <<'EOF'
22.04|snap
24.04|snap
26.04|apt
26.10|apt
EOF
}

@test "batch runner continues after a failed step and reports partial failure" {
  run bash -c '
    info() { :; }; success() { :; }; warning() { :; }; error() { :; }
    source "$1"
    failed() { return 7; }
    continued() { printf continued >"$2"; }
    reset_batch_results
    run_batch_plan failed continued
    [ "$BATCH_FAILURES" -eq 1 ] && [ -f "$2" ] && ! finish_batch_install
  ' bash "$TEST_REPO_ROOT/assets/scripts/lib/batch.sh" "$BATS_TEST_TMPDIR/continued"
  [ "$status" -eq 0 ]
}

@test "help and version are available after a local install" {
  dots_run help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]

  dots_run version
  [ "$status" -eq 0 ]
  [[ "$output" == *"dotfiles version"* ]]
}

@test "Flatpak package list and completion are exposed" {
  dots_run list --flatpak
  [ "$status" -eq 0 ]
  [[ "$output" == *"org.gimp.GIMP"* ]]
  [[ "$output" == *"us.zoom.Zoom"* ]]

  dots_run completion
  [ "$status" -eq 0 ]
  [[ "$output" == *"--flatpak[Install Flatpak desktop applications]"* ]]
  [[ "$output" == *"gimp[GIMP from Flathub]"* ]]
}

@test "installer retains the --gum compatibility option and writes debug logs" {
  run bash "$TEST_REPO_ROOT/install.sh" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"--gum"* ]]
  [ -s "$XDG_STATE_HOME/dotfiles/debug.log" ]
  grep -Fq '[SUCCESS] Installation completed' "$XDG_STATE_HOME/dotfiles/debug.log"
}

@test "doctor validates the installed tree" {
  dots_run doctor
  [ "$status" -eq 0 ]
  [[ "$output" == *"Doctor found no problems"* ]]
}

@test "install preserves mutable Zsh history and completions" {
  [ "$(cat "$XDG_STATE_HOME/zsh/history")" = "legacy-history" ]
  [ "$(cat "$XDG_DATA_HOME/zsh/completions/_legacy")" = "# legacy completion" ]

  dots_run --yes apply zsh
  [ "$status" -eq 0 ]
  [ -L "$XDG_CONFIG_HOME/zsh" ]
  [ "$(cat "$XDG_STATE_HOME/zsh/history")" = "legacy-history" ]
  [ -f "$XDG_DATA_HOME/zsh/completions/_legacy" ]
}

@test "noninteractive apply requires explicit consent" {
  dots_run apply bat
  [ "$status" -ne 0 ]
  [[ "$output" == *"pass --yes"* ]]
  [ ! -e "$XDG_CONFIG_HOME/bat" ]
}

@test "apply is idempotent and creates managed links" {
  dots_run --yes apply bat
  [ "$status" -eq 0 ]
  [ -L "$XDG_CONFIG_HOME/bat" ]

  first_target="$(readlink "$XDG_CONFIG_HOME/bat")"
  dots_run --yes apply bat
  [ "$status" -eq 0 ]
  [ "$(readlink "$XDG_CONFIG_HOME/bat")" = "$first_target" ]
  [[ "$output" == *"No configuration changes were necessary"* ]]
}

@test "rollback restores the previous configuration" {
  mkdir -p "$XDG_CONFIG_HOME/bat"
  printf 'keep-me\n' >"$XDG_CONFIG_HOME/bat/local.conf"
  mkdir -p "$XDG_CONFIG_HOME/zsh"
  printf 'keep-zsh\n' >"$XDG_CONFIG_HOME/zsh/local.zsh"

  dots_run --yes apply bat zsh
  [ "$status" -eq 0 ]
  [ -L "$XDG_CONFIG_HOME/bat" ]
  [ -L "$XDG_CONFIG_HOME/zsh" ]

  dots_run --yes rollback latest
  [ "$status" -eq 0 ]
  [ ! -L "$XDG_CONFIG_HOME/bat" ]
  [ ! -L "$XDG_CONFIG_HOME/zsh" ]
  [ "$(cat "$XDG_CONFIG_HOME/bat/local.conf")" = "keep-me" ]
  [ "$(cat "$XDG_CONFIG_HOME/zsh/local.zsh")" = "keep-zsh" ]
}

@test "uninstall only removes managed links and keeps copied overlays" {
  dots_run --yes apply bat nvim
  [ "$status" -eq 0 ]
  [ -L "$XDG_CONFIG_HOME/bat" ]
  [ -f "$XDG_CONFIG_HOME/nvim/lazyvim.json" ]

  dots_run --yes uninstall
  [ "$status" -eq 0 ]
  [ ! -e "$XDG_CONFIG_HOME/bat" ]
  [ -f "$XDG_CONFIG_HOME/nvim/lazyvim.json" ]
  [ ! -e "$HOME/.local/bin/dots" ]
}
