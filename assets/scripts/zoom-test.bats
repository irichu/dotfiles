#!/usr/bin/env bats

setup() {
  export TEST_REPO_ROOT
  TEST_REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  export MOCK_BIN="$BATS_TEST_TMPDIR/bin"
  export MOCK_LOG="$BATS_TEST_TMPDIR/commands.log"
  export PATH="$MOCK_BIN:$PATH"
  mkdir -p "$MOCK_BIN"
  : >"$MOCK_LOG"
  cat >"$MOCK_BIN/sudo" <<'EOF'
#!/usr/bin/env bash
printf 'sudo %s\n' "$*" >>"$MOCK_LOG"
"$@"
EOF
  cat >"$MOCK_BIN/snap" <<'EOF'
#!/usr/bin/env bash
printf 'snap %s\n' "$*" >>"$MOCK_LOG"
case "$1" in
list) [ "${MOCK_INSTALLED:-false}" = true ] ;;
install) exit "${MOCK_INSTALL_STATUS:-0}" ;;
*) exit 99 ;;
esac
EOF
  chmod +x "$MOCK_BIN/sudo" "$MOCK_BIN/snap"
}

@test "Zoom installs the Snap package" {
  run bash "$TEST_REPO_ROOT/assets/scripts/desktop/install-zoom.sh"
  [ "$status" -eq 0 ]
  grep -Fxq 'sudo snap install zoom-client' "$MOCK_LOG"
}

@test "Zoom skips an installed Snap package" {
  export MOCK_INSTALLED=true
  run bash "$TEST_REPO_ROOT/assets/scripts/desktop/install-zoom.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *"already installed from Snap"* ]]
  ! grep -q 'snap install' "$MOCK_LOG"
}

@test "Zoom fails when Snap is unavailable" {
  run bash -c '
    command() {
      if [[ "$*" == "-v snap" ]]; then return 1; fi
      builtin command "$@"
    }
    source "$1"
  ' bash "$TEST_REPO_ROOT/assets/scripts/desktop/install-zoom.sh"
  [ "$status" -ne 0 ]
  [[ "$output" == *"snap command not found"* ]]
  [ ! -s "$MOCK_LOG" ]
}

@test "Zoom CLI propagates Snap installation failures" {
  export MOCK_INSTALL_STATUS=7
  run bash -c '
    SCRIPT_DIR="$1"
    info() { :; }
    eval "$(sed -n "/^install_snap_zoom() {$/,/^}$/p" "$1/assets/scripts/main.sh" | tr -d "\r")"
    eval "$(sed -n "/^  zoom)$/,/^    ;;$/p" "$1/assets/scripts/main.sh" | sed "1d;\$d" | tr -d "\r")"
    echo unexpected-success
  ' bash "$TEST_REPO_ROOT"
  [ "$status" -eq 7 ]
  [[ "$output" != *unexpected-success* ]]
  grep -Fxq 'sudo snap install zoom-client' "$MOCK_LOG"
}

@test "Ubuntu Desktop always schedules Snap Zoom while Flatpak excludes Zoom" {
  for mode in --ubuntu-desktop --flatpak; do
    run bash -c '
      reset_batch_results() { :; }; info() { :; }
      show_ubuntu_desktop_install_notice() { :; }
      confirm_unless_explicit_yes() { return 0; }
      ubuntu_desktop_ghostty_method() { echo apt; }
      run_batch_step() { printf "%s\n" "$*"; }
      run_batch_plan() { printf "%s\n" "$@"; }
      finish_batch_install() { :; }
      start_desktop_inhibit() { :; }; stop_desktop_inhibit() { :; }
      eval "$(sed -n "/^  $2)$/,/^    ;;$/p" "$1/assets/scripts/main.sh" | sed "1d;\$d" | tr -d "\r")"
    ' bash "$TEST_REPO_ROOT" "$mode"
    [ "$status" -eq 0 ]
    [[ "$output" == *install_flatpak_thunderbird* ]]
    if [ "$mode" = --ubuntu-desktop ]; then
      [[ "$output" == *"check snap check_command snap"* ]]
      [[ "$output" == *install_snap_zoom* ]]
    else
      [[ "$output" != *zoom* && "$output" != *snap* ]]
    fi
  done
}

@test "GNOME favorites prefer Snap Zoom and retain Flatpak fallback" {
  desktop_dir="$BATS_TEST_TMPDIR/applications"
  mkdir -p "$desktop_dir"
  touch "$desktop_dir/us.zoom.Zoom.desktop"
  for expected in us.zoom.Zoom.desktop zoom-client_zoom-client.desktop; do
    touch "$desktop_dir/$expected"
    run env DOTS_DESKTOP_ENTRY_DIRS="$desktop_dir" bash -c 'source "$1"; desktop_favorites_gvariant' \
      bash "$TEST_REPO_ROOT/assets/scripts/desktop/desktop-favorites.sh"
    [ "$status" -eq 0 ]
    [ "$output" = "@as ['$expected']" ]
  done
}
