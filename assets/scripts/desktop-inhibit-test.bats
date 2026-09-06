#!/usr/bin/env bats

setup() {
  export TEST_REPO_ROOT
  TEST_REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  export MOCK_LOG="$BATS_TEST_TMPDIR/commands.log"
  export MOCK_PID_FILE="$BATS_TEST_TMPDIR/inhibitor.pid"
  export TMPDIR="$BATS_TEST_TMPDIR/tmp"
  export PATH="$BATS_TEST_TMPDIR/bin:$PATH"
  mkdir -p "$BATS_TEST_TMPDIR/bin" "$TMPDIR"
  : >"$MOCK_LOG"
  cat >"$BATS_TEST_TMPDIR/bin/gnome-session-inhibit" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"$MOCK_LOG"
printf '%s\n' "$$" >"$MOCK_PID_FILE"
if [[ "${MOCK_MODE:-}" == fail ]]; then
  echo 'Failed to connect to session bus' >&2
  exit 1
fi
trap 'echo stopped >>"$MOCK_LOG"; exit 0' TERM HUP
if [[ "${MOCK_MODE:-}" != hang ]]; then
  echo 'Inhibiting until Ctrl+C is pressed...'
fi
while :; do sleep 0.05; done
EOF
  # Any accidental persistent settings write must fail and be visible.
  for tool in gsettings dconf; do
    printf '#!/usr/bin/env bash\necho unexpected-settings-write >>"$MOCK_LOG"\nexit 99\n' >"$BATS_TEST_TMPDIR/bin/$tool"
  done
  chmod +x "$BATS_TEST_TMPDIR/bin/"*
}

teardown() {
  if [ -f "$MOCK_PID_FILE" ]; then
    kill "$(cat "$MOCK_PID_FILE")" 2>/dev/null || true
  fi
}

assert_released() {
  ! kill -0 "$(cat "$MOCK_PID_FILE")" 2>/dev/null
  [ -z "$(ls -A "$TMPDIR")" ]
  ! grep -q unexpected-settings-write "$MOCK_LOG"
}

@test "desktop inhibition lasts until explicit cleanup and leaves no settings changes" {
  run bash -c '
    set -Eeuo pipefail
    info() { :; }; warning() { echo "$*"; }
    source "$1/assets/scripts/lib/desktop-inhibit.sh"
    start_desktop_inhibit
    kill -0 "$DESKTOP_INHIBIT_PID"
    ( stop_desktop_inhibit; exit 0 )
    kill -0 "$DESKTOP_INHIBIT_PID"
    stop_desktop_inhibit
    stop_desktop_inhibit
    [ -z "$(trap -p EXIT INT TERM HUP)" ]
  ' bash "$TEST_REPO_ROOT"
  [ "$status" -eq 0 ]
  grep -q -- '--inhibit idle:suspend --inhibit-only' "$MOCK_LOG"
  [ "$(grep -c stopped "$MOCK_LOG")" -eq 1 ]
  assert_released
}

@test "desktop inhibition is released on normal and error exits with status preserved" {
  for expected in 0 7; do
    run bash -c '
      set -Eeuo pipefail
      info() { :; }; warning() { echo "$*"; }
      source "$1/assets/scripts/lib/desktop-inhibit.sh"
      start_desktop_inhibit
      bash -c "exit $2"
    ' bash "$TEST_REPO_ROOT" "$expected"
    [ "$status" -eq "$expected" ]
    assert_released
  done
}

@test "desktop inhibition is released on INT TERM and HUP" {
  while read -r signal expected; do
    run bash -c '
      set -Eeuo pipefail
      info() { :; }; warning() { echo "$*"; }
      source "$1/assets/scripts/lib/desktop-inhibit.sh"
      start_desktop_inhibit
      kill -s "$2" "$BASHPID"
      exit 99
    ' bash "$TEST_REPO_ROOT" "$signal"
    [ "$status" -eq "$expected" ]
    assert_released
  done <<'EOF'
INT 130
TERM 143
HUP 129
EOF
}

@test "desktop installation continues if the inhibitor is unavailable" {
  run bash -c '
    set -Eeuo pipefail
    command() {
      if [[ "$*" == "-v gnome-session-inhibit" ]]; then return 1; fi
      builtin command "$@"
    }
    info() { :; }; warning() { echo "$*"; }
    source "$1/assets/scripts/lib/desktop-inhibit.sh"
    start_desktop_inhibit
    stop_desktop_inhibit
    echo continued
  ' bash "$TEST_REPO_ROOT"
  [ "$status" -eq 0 ]
  [[ "$output" == *unavailable* && "$output" == *continued* ]]
  [ ! -s "$MOCK_LOG" ]
}

@test "desktop installation continues on session failure and startup timeout" {
  for MOCK_MODE in fail hang; do
    export MOCK_MODE
    run bash -c '
      set -Eeuo pipefail
      info() { :; }; warning() { echo "$*"; }
      source "$1/assets/scripts/lib/desktop-inhibit.sh"
      start_desktop_inhibit
      echo continued
      [ -z "$(trap -p EXIT INT TERM HUP)" ]
    ' bash "$TEST_REPO_ROOT"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Continuing without it"* && "$output" == *continued* ]]
    assert_released
  done
}

@test "only confirmed Ubuntu Desktop setup acquires inhibition" {
  while read -r mode confirm expected; do
    : >"$MOCK_LOG"
    run bash -c '
      set -Eeuo pipefail
      info() { :; }; warning() { echo "$*"; }
      source "$1/assets/scripts/lib/desktop-inhibit.sh"
      reset_batch_results() { :; }; finish_batch_install() { :; }
      show_ubuntu_desktop_install_notice() { :; }
      confirm_unless_explicit_yes() { [ "$confirmation" = yes ]; }
      run_batch_step() {
        if [ "$1" = setup_desktop_interactive ]; then
          kill -0 "$DESKTOP_INHIBIT_PID" || exit 98
        fi
      }
      run_batch_plan() { :; }
      confirmation="$3"
      eval "$(sed -n "/^  $2)$/,/^    ;;$/p" "$1/assets/scripts/main.sh" | sed "1d;\$d" | tr -d "\r")"
    ' bash "$TEST_REPO_ROOT" "$mode" "$confirm"
    [ "$status" -eq "$expected" ]
    if [ "$mode/$confirm" = --ubuntu-desktop/yes ]; then
      grep -q stopped "$MOCK_LOG"
      assert_released
    else
      [ ! -s "$MOCK_LOG" ]
    fi
  done <<'EOF'
--ubuntu-desktop yes 0
--ubuntu-desktop no 1
--flatpak yes 0
--apt yes 0
--snap yes 0
EOF
}
