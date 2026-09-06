#!/usr/bin/env bats

setup() {
  export TEST_REPO_ROOT
  TEST_REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  export MOCK_BIN="$BATS_TEST_TMPDIR/bin"
  export MOCK_LOG="$BATS_TEST_TMPDIR/commands.log"
  export MOCK_COUNT="$BATS_TEST_TMPDIR/count"
  export HOME="$BATS_TEST_TMPDIR/home"
  export PATH="$MOCK_BIN:$PATH"
  export TMPDIR="$BATS_TEST_TMPDIR/tmp"
  mkdir -p "$MOCK_BIN" "$TMPDIR" "$HOME/.cache/dotfiles"
  : >"$MOCK_LOG"
  printf '0\n' >"$MOCK_COUNT"
  cat >"$MOCK_BIN/sudo" <<'EOF'
#!/usr/bin/env bash
"$@"
EOF
  cat >"$MOCK_BIN/apt-get" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"$MOCK_LOG"
count=$(cat "$MOCK_COUNT")
count=$((count + 1))
printf '%s\n' "$count" >"$MOCK_COUNT"
case "${MOCK_MODE:-success}" in
lock-once)
  if [ "$count" -eq 1 ]; then
    echo 'E: Could not get lock /var/lib/apt/lists/lock. It is held by another process.'
    exit 100
  fi ;;
locked)
  echo 'E: Could not get lock /var/lib/dpkg/lock-frontend. It is held by unattended-upgr.'
  exit 100 ;;
dependencies)
  echo 'E: Unmet dependencies.'
  exit 100 ;;
interrupt) exit 130 ;;
bootstrap)
  if [[ "$*" == *'install -y flatpak' ]]; then
    printf '#!/usr/bin/env bash\nprintf "flatpak %%s\\n" "$*" >>"$MOCK_LOG"\n' >"$MOCK_BIN/flatpak"
    chmod +x "$MOCK_BIN/flatpak"
  fi ;;
esac
EOF
  cat >"$MOCK_BIN/wget" <<'EOF'
#!/usr/bin/env bash
[ "$1" = -O ] || exit 99
printf 'mock deb\n' >"$2"
EOF
  printf '#!/usr/bin/env bash\nexit 0\n' >"$MOCK_BIN/xdg-settings"
  chmod +x "$MOCK_BIN/"*
}

apt_run() {
  run bash -c 'source "$1/assets/scripts/lib/apt.sh"; shift; dots_apt_get "$@"' bash "$TEST_REPO_ROOT" "$@"
}

@test "APT installs with bounded dpkg lock waiting and download retries" {
  apt_run install -y 'package with spaces.deb'
  [ "$status" -eq 0 ]
  grep -Fq 'DPkg::Lock::Timeout=600' "$MOCK_LOG"
  grep -Fq 'Acquire::Retries=3' "$MOCK_LOG"
  grep -Fq 'install -y package with spaces.deb' "$MOCK_LOG"
  [ -z "$(ls -A "$TMPDIR")" ]
}

@test "APT update retries a transient package-list lock" {
  export MOCK_MODE=lock-once
  run bash -c '
    source "$1/assets/scripts/lib/apt.sh"
    sleep() { :; }
    dots_apt_get update
  ' bash "$TEST_REPO_ROOT"
  [ "$status" -eq 0 ]
  [ "$(cat "$MOCK_COUNT")" -eq 2 ]
  [[ "$output" == *'retrying in'* ]]
}

@test "APT lock timeout dependency errors and interruption propagate without repeated installs" {
  while read -r mode operation expected; do
    export MOCK_MODE="$mode" DOTS_APT_LOCK_TIMEOUT=0
    printf '0\n' >"$MOCK_COUNT"
    apt_run "$operation"
    [ "$status" -eq "$expected" ]
    [ "$(cat "$MOCK_COUNT")" -eq 1 ]
    [ -z "$(ls -A "$TMPDIR")" ]
  done <<'EOF'
locked update 100
locked install 100
dependencies install 100
dependencies update 100
interrupt install 130
EOF
}

@test "APT rejects an invalid lock timeout without invoking the package manager" {
  export DOTS_APT_LOCK_TIMEOUT=invalid
  apt_run install flatpak
  [ "$status" -eq 2 ]
  [ ! -s "$MOCK_LOG" ]
}

@test "Flatpak bootstrap uses the waiting APT helper before registering Flathub" {
  export MOCK_MODE=bootstrap
  run bash -c '
    command() {
      if [[ "$*" == "-v flatpak" ]]; then [ -x "$MOCK_BIN/flatpak" ]; return $?; fi
      builtin command "$@"
    }
    export -f command
    bash "$1/assets/scripts/desktop/flatpak/install-flatpak.sh"
  ' bash "$TEST_REPO_ROOT"
  [ "$status" -eq 0 ]
  [ "$(cat "$MOCK_COUNT")" -eq 2 ]
  grep -Fq 'DPkg::Lock::Timeout=600' "$MOCK_LOG"
  grep -Fq 'flatpak remote-add --system --if-not-exists flathub' "$MOCK_LOG"
}

@test "RustDesk and Chrome install local debs using APT dependency resolution" {
  run bash -c '
    source "$1/assets/scripts/lib/apt.sh"
    info() { :; }
    get_github_latest_version() { echo 1.4.9; }
    ARCH=x86_64
    CACHE_DIR="$HOME/.cache/dotfiles"
    eval "$(sed -n "/^install_rustdesk() {$/,/^}$/p" "$1/assets/scripts/main.sh" | tr -d "\r")"
    install_rustdesk
  ' bash "$TEST_REPO_ROOT"
  [ "$status" -eq 0 ]
  grep -Fq "install -y $HOME/.cache/dotfiles/rustdesk-1.4.9-x86_64.deb" "$MOCK_LOG"
  run bash "$TEST_REPO_ROOT/assets/scripts/desktop/install-chrome.sh"
  [ "$status" -eq 0 ]
  grep -Fq 'install -y ./google-chrome-stable_current_amd64.deb' "$MOCK_LOG"
}

@test "failed Flatpak prerequisite skips dependent apps but independent work continues" {
  run bash -c '
    set -Eeuo pipefail
    source "$1/assets/scripts/lib/batch.sh"
    info() { :; }; success() { :; }; warning() { echo "$*"; }; error() { :; }
    prerequisite() { return 100; }
    dependent() { echo unexpected; }
    independent() { echo continued; }
    reset_batch_results
    run_batch_dependent_plan prerequisite dependent
    run_batch_plan independent
    [ "$BATCH_FAILURES" -eq 1 ]
    finish_batch_install
  ' bash "$TEST_REPO_ROOT"
  [ "$status" -eq 1 ]
  [[ "$output" == *Skipping* && "$output" == *continued* && "$output" != *unexpected* ]]
}

@test "successful prerequisite runs dependent apps despite earlier unrelated failures" {
  run bash -c '
    set -Eeuo pipefail
    source "$1/assets/scripts/lib/batch.sh"
    info() { :; }; success() { :; }; warning() { :; }; error() { :; }
    prerequisite() { :; }
    dependent() { echo installed; }
    reset_batch_results
    BATCH_FAILURES=1
    run_batch_dependent_plan prerequisite dependent
    [ "$BATCH_FAILURES" -eq 1 ]
  ' bash "$TEST_REPO_ROOT"
  [ "$status" -eq 0 ]
  [[ "$output" == *installed* ]]
}

@test "dependent batch preserves fail-fast behavior inside the prerequisite" {
  run bash -c '
    source "$1/assets/scripts/lib/batch.sh"
    info() { :; }; success() { :; }; warning() { :; }; error() { :; }
    prerequisite() { false; echo unexpected-success; }
    dependent() { echo unexpected-dependent; }
    reset_batch_results
    run_batch_dependent_plan prerequisite dependent
    finish_batch_install
  ' bash "$TEST_REPO_ROOT"
  [ "$status" -eq 1 ]
  [[ "$output" != *unexpected* ]]
}

@test "dependent batch propagates interruption without running subsequent steps" {
  run bash -c '
    source "$1/assets/scripts/lib/batch.sh"
    info() { :; }; success() { :; }; warning() { :; }; error() { :; }
    prerequisite() { return 130; }
    dependent() { echo unexpected-dependent; }
    reset_batch_results
    run_batch_dependent_plan prerequisite dependent
    echo unexpected-continued
  ' bash "$TEST_REPO_ROOT"
  [ "$status" -eq 130 ]
  [[ "$output" != *unexpected* ]]
}
