#!/usr/bin/env bats

setup() {
  export TEST_REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  export RD_TEST="$BATS_TEST_TMPDIR/rd"
  export MOCK_LOG="$RD_TEST/commands.log"
  export HOME="$RD_TEST/home" STATE_DIR="$RD_TEST/state"
  export REAL_DPKG="$(command -v dpkg)"
  export TEST_KEY="$(printf '01234567890123456789012345678901' | base64)"
  mkdir -p "$RD_TEST/bin" "$HOME" "$RD_TEST/options"
  : >"$MOCK_LOG"
  export PATH="$RD_TEST/bin:$PATH"
  cat >"$RD_TEST/harness.sh" <<'EOF'
source "$TEST_REPO_ROOT/assets/scripts/lib/rustdesk.sh"
dots_rd_platform() { [ "${MOCK_PLATFORM:-ubuntu}" = ubuntu ]; }
dots_rd_paths() {
  rd_config="$RD_TEST/etc"
  rd_data="$RD_TEST/data"
  rd_logs="$RD_TEST/logs"
  rd_units="$RD_TEST/units"
}
sleep() { :; }
dots_apt_get() {
  printf 'apt %s\n' "$*" >>"$MOCK_LOG"
  if [[ "$*" == *'.deb'* ]]; then
    # Simulate maintainer scripts: neither service may start at this point.
    [ ! -e "$RD_TEST/etc/dots-ready" ] || return 91
    grep -q 'User=rustdesk' "$RD_TEST/units/rustdesk-hbbs.service.d/90-dots.conf" || return 92
    grep -q 'ConditionPathExists=' "$RD_TEST/units/rustdesk-hbbr.service.d/90-dots.conf" || return 93
    [ "${MOCK_APT_FAIL:-false}" = false ] || return 100
    touch "$RD_TEST/packages"
  fi
}
EOF
  cat >"$RD_TEST/bin/sudo" <<'EOF'
#!/usr/bin/env bash
printf 'sudo %s\n' "$*" >>"$MOCK_LOG"
[ "${1:-}" != -v ] || exit 0
if [ "$1" = install ]; then
  shift
  args=()
  while [ "$#" -gt 0 ]; do
    case "$1" in
    -o|-g) shift 2 ;;
    *) args+=("$1"); shift ;;
    esac
  done
  exec install "${args[@]}"
fi
"$@"
EOF
  cat >"$RD_TEST/bin/getent" <<'EOF'
#!/usr/bin/env bash
case "$1" in
passwd)
  [ -f "$RD_TEST/account" ] || exit 2
  printf 'rustdesk:x:999:999::%s:%s\n' "$RD_TEST/data" "${MOCK_SHELL:-/usr/sbin/nologin}" ;;
group)
  [ -f "$RD_TEST/group" ] || exit 2
  echo 'rustdesk:x:999:' ;;
esac
EOF
  cat >"$RD_TEST/bin/id" <<'EOF'
#!/usr/bin/env bash
case "$1" in -gn) echo rustdesk ;; -u) echo 999 ;; esac
EOF
  cat >"$RD_TEST/bin/groupadd" <<'EOF'
#!/usr/bin/env bash
touch "$RD_TEST/group"
EOF
  cat >"$RD_TEST/bin/useradd" <<'EOF'
#!/usr/bin/env bash
touch "$RD_TEST/account"
EOF
  cat >"$RD_TEST/bin/dpkg" <<'EOF'
#!/usr/bin/env bash
if [ "$1" = --print-architecture ]; then echo "${MOCK_ARCH:-amd64}"
else "$REAL_DPKG" "$@"; fi
EOF
  cat >"$RD_TEST/bin/dpkg-query" <<'EOF'
#!/usr/bin/env bash
case "${*: -1}" in
ca-certificates) echo 'install ok installed' ;;
rustdesk) [ "${MOCK_CLIENT:-installed}" = installed ] || exit 1; echo 'install ok installed' ;;
*) [ -f "$RD_TEST/packages" ] || exit 1; echo 'install ok installed' ;;
esac
EOF
  cat >"$RD_TEST/bin/dpkg-deb" <<'EOF'
#!/usr/bin/env bash
case "$3" in
Package) name="${2##*/}"; echo "${name%%_*}" ;;
Architecture) echo "${MOCK_DEB_ARCH:-${MOCK_ARCH:-amd64}}" ;;
Version) echo 1.1.16 ;;
esac
EOF
  cat >"$RD_TEST/bin/curl" <<'EOF'
#!/usr/bin/env bash
[ "${MOCK_DOWNLOAD_FAIL:-false}" = false ] || exit 22
for ((i=1;i<=$#;i++)); do
  if [ "${!i}" = -o ]; then j=$((i+1)); output="${!j}"; fi
done
if [[ "$output" == *release.json ]]; then
  digest=$(printf 'mock deb' | sha256sum); digest="${digest%% *}"
  [ "${MOCK_BAD_HASH:-false}" = false ] || digest="$(printf '%064d' 0)"
  jq -n --arg digest "sha256:$digest" --arg arch "${MOCK_ASSET_ARCH:-amd64}" '{tag_name:"1.1.16",assets:[("hbbs","hbbr") as $c | {
    name:("rustdesk-server-"+$c+"_1.1.16_"+$arch+".deb"),digest:$digest,
    browser_download_url:("https://github.com/rustdesk/rustdesk-server/releases/download/1.1.16/rustdesk-server-"+$c+"_1.1.16_"+$arch+".deb")}]}' >"$output"
else printf 'mock deb' >"$output"; fi
EOF
  cat >"$RD_TEST/bin/systemctl" <<'EOF'
#!/usr/bin/env bash
printf 'systemctl %s\n' "$*" >>"$MOCK_LOG"
case "$1" in
show)
  case "$4" in
  LoadState) if [ -f "$RD_TEST/packages" ]; then echo loaded; else echo not-found; fi ;;
  User|Group) echo "${MOCK_SERVICE_USER:-rustdesk}" ;;
  esac ;;
start)
  if [ "$2" = rustdesk.service ]; then exit 0; fi
  [ -e "$RD_TEST/etc/dots-ready" ] || exit 0
  [ "${MOCK_START_FAIL:-}" != "$2" ] || exit 1
  if [ "$2" = rustdesk-hbbs.service ] && [ "${MOCK_NO_KEY:-false}" = false ]; then
    if [ ! -f "$RD_TEST/data/id_ed25519" ]; then
      echo private-key >"$RD_TEST/data/id_ed25519"
      printf '%s' "$TEST_KEY" >"$RD_TEST/data/id_ed25519.pub"
    fi
  elif [ "$2" = rustdesk-hbbr.service ]; then
    [ -s "$RD_TEST/data/id_ed25519" ] || exit 94
  fi ;;
is-active) [ "${MOCK_INACTIVE:-false}" = false ] ;;
esac
EOF
  cat >"$RD_TEST/bin/rustdesk" <<'EOF'
#!/usr/bin/env bash
if [ "$1" = --version ]; then echo "${MOCK_VERSION:-1.4.9}"; exit 0; fi
[ "$1" = --option ] || exit 2
if [ "$#" -eq 3 ]; then
  [ "${MOCK_IGNORE_OPTIONS:-false}" = false ] || exit 0
  printf '%s' "$3" >"$RD_TEST/options/$2"
elif [ -f "$RD_TEST/options/$2" ]; then cat "$RD_TEST/options/$2"; fi
EOF
  chmod +x "$RD_TEST/bin/"*
}

rd_run() {
  run bash -u -c 'source "$RD_TEST/harness.sh"; "$@"' bash "$@"
}

@test "RustDesk rejects missing, duplicate, and unsafe arguments before mutation" {
  rd_run install_rustdesk_server --host
  [ "$status" -eq 2 ]
  rd_run install_rustdesk_server --host example.com --host other.com
  [ "$status" -eq 2 ]
  for host in 'a..b' 'https://example.com' 'rd.example.com:21116' 'a%h' $'a\nUser=root' '999.1.2.3' '.'; do
    rd_run install_rustdesk_server --host "$host"
    [ "$status" -eq 2 ]
  done
  rd_run setup_rustdesk_client --host example.com --key invalid
  [ "$status" -eq 2 ]
  [ ! -s "$MOCK_LOG" ]
}

@test "RustDesk rejects unsupported platforms and unmanaged installations" {
  export MOCK_PLATFORM=other
  rd_run install_rustdesk_server --host example.com
  [ "$status" -ne 0 ]
  [ ! -s "$MOCK_LOG" ]
  unset MOCK_PLATFORM
  touch "$RD_TEST/account"
  rd_run install_rustdesk_server --host example.com
  [ "$status" -ne 0 ]
  [[ "$output" == *unmanaged* ]]
  [ ! -d "$RD_TEST/etc" ]
}

@test "RustDesk rejects missing architecture assets, failed downloads and bad digests" {
  export MOCK_ARCH=arm64
  rd_run install_rustdesk_server --host example.com
  [ "$status" -ne 0 ]
  unset MOCK_ARCH
  export MOCK_DOWNLOAD_FAIL=true
  rd_run install_rustdesk_server --host example.com
  [ "$status" -ne 0 ]
  unset MOCK_DOWNLOAD_FAIL
  export MOCK_BAD_HASH=true
  rd_run install_rustdesk_server --host example.com
  [ "$status" -ne 0 ]
  [ ! -d "$RD_TEST/etc" ]
}

@test "RustDesk installs both debs, uses nologin and starts hbbs before hbbr" {
  rd_run install_rustdesk_server --host rd.example.com
  [ "$status" -eq 0 ]
  grep -q -- '--shell /usr/sbin/nologin rustdesk' "$MOCK_LOG"
  grep -q 'ExecStart=/usr/bin/hbbs -r rd.example.com:21117 -k _' "$RD_TEST/units/rustdesk-hbbs.service.d/90-dots.conf"
  grep -q 'ExecStart=/usr/bin/hbbr -k _' "$RD_TEST/units/rustdesk-hbbr.service.d/90-dots.conf"
  grep -q 'systemctl enable rustdesk-hbbs.service rustdesk-hbbr.service' "$MOCK_LOG"
  [ "$(grep '^systemctl start rustdesk-hb' "$MOCK_LOG" | head -1)" = 'systemctl start rustdesk-hbbs.service' ]
  [ "$(stat -c %a "$RD_TEST/data/id_ed25519")" = 600 ]
  [[ "$output" == *'dots setup rustdesk-client --host rd.example.com --key'* ]]
  [[ "$output" != *private-key* ]]
}

@test "RustDesk rerun preserves key and data while updating the advertised host" {
  rd_run install_rustdesk_server --host first.example.com
  [ "$status" -eq 0 ]
  echo keep-this-key >"$RD_TEST/data/id_ed25519"
  echo database >"$RD_TEST/data/db_v2.sqlite3"
  rd_run install_rustdesk_server --host second.example.com
  [ "$status" -eq 0 ]
  [ "$(cat "$RD_TEST/data/id_ed25519")" = keep-this-key ]
  [ "$(cat "$RD_TEST/data/db_v2.sqlite3")" = database ]
  grep -q 'second.example.com:21117' "$RD_TEST/units/rustdesk-hbbs.service.d/90-dots.conf"
  [ "$(grep -c 'sudo useradd ' "$MOCK_LOG")" -eq 1 ]
}

@test "RustDesk APT failure leaves services inhibited and can be retried" {
  export MOCK_APT_FAIL=true
  rd_run install_rustdesk_server --host example.com
  [ "$status" -ne 0 ]
  [ -f "$RD_TEST/etc/dots-managed" ]
  [ ! -f "$RD_TEST/etc/dots-ready" ]
  ! grep -q '^systemctl start rustdesk-hb' "$MOCK_LOG"
  unset MOCK_APT_FAIL
  rd_run install_rustdesk_server --host example.com
  [ "$status" -eq 0 ]
}

@test "RustDesk rejects effective root services and failed key generation" {
  export MOCK_SERVICE_USER=root
  rd_run install_rustdesk_server --host example.com
  [ "$status" -ne 0 ]
  [ ! -f "$RD_TEST/etc/dots-ready" ]
  unset MOCK_SERVICE_USER
  export MOCK_NO_KEY=true
  rd_run install_rustdesk_server --host example.com
  [ "$status" -ne 0 ]
  [ ! -f "$RD_TEST/etc/dots-ready" ]
  ! grep -q '^systemctl start rustdesk-hbbr' "$MOCK_LOG"
}

@test "RustDesk relay startup failure retains keys and stops the server" {
  export MOCK_START_FAIL=rustdesk-hbbr.service
  rd_run install_rustdesk_server --host example.com
  [ "$status" -ne 0 ]
  [ -s "$RD_TEST/data/id_ed25519" ]
  [ ! -e "$RD_TEST/etc/dots-ready" ]
  grep -q '^systemctl stop rustdesk-hbbr.service rustdesk-hbbs.service' "$MOCK_LOG"
}

@test "RustDesk installs matching ARM64 debs and rejects mismatched package metadata" {
  export MOCK_ARCH=arm64 MOCK_ASSET_ARCH=arm64 MOCK_DEB_ARCH=amd64
  rd_run install_rustdesk_server --host 192.168.1.10
  [ "$status" -ne 0 ]
  [ ! -d "$RD_TEST/etc" ]
  unset MOCK_DEB_ARCH
  rd_run install_rustdesk_server --host 192.168.1.10
  [ "$status" -eq 0 ]
  grep -q 'apt install -y .*hbbs_1.1.16_arm64.deb .*hbbr_1.1.16_arm64.deb' "$MOCK_LOG"
}

@test "RustDesk preserves a running managed installation on download failure" {
  rd_run install_rustdesk_server --host example.com
  [ "$status" -eq 0 ]
  : >"$MOCK_LOG"
  export MOCK_DOWNLOAD_FAIL=true
  rd_run install_rustdesk_server --host other.example.com
  [ "$status" -ne 0 ]
  [ -e "$RD_TEST/etc/dots-ready" ]
  ! grep -q '^systemctl stop ' "$MOCK_LOG"
  grep -q 'example.com:21117' "$RD_TEST/units/rustdesk-hbbs.service.d/90-dots.conf"
}

@test "RustDesk refuses to overwrite an unmanaged data directory or changed login account" {
  mkdir -p "$RD_TEST/data"
  echo original >"$RD_TEST/data/id_ed25519"
  rd_run install_rustdesk_server --host example.com
  [ "$status" -ne 0 ]
  [ "$(cat "$RD_TEST/data/id_ed25519")" = original ]
  mkdir -p "$RD_TEST/etc"
  echo dots-rustdesk-server-v1 >"$RD_TEST/etc/dots-managed"
  touch "$RD_TEST/account"
  export MOCK_SHELL=/bin/bash
  rd_run install_rustdesk_server --host example.com
  [ "$status" -ne 0 ]
  [[ "$output" == *'unexpected settings'* ]]
}

@test "RustDesk removes readiness and stops services when setup is interrupted" {
  run bash -u -c '
    source "$RD_TEST/harness.sh"
    dots_rd_start() {
      touch "$rd_config/dots-ready"
      kill -TERM "$BASHPID"
    }
    install_rustdesk_server --host example.com
  '
  [ "$status" -eq 143 ]
  [ ! -e "$RD_TEST/etc/dots-ready" ]
  grep -q '^systemctl stop rustdesk-hbbr.service rustdesk-hbbs.service' "$MOCK_LOG"
}

@test "RustDesk client requires an installed supported deb client" {
  export MOCK_CLIENT=absent
  rd_run setup_rustdesk_client --host example.com --key "$TEST_KEY"
  [ "$status" -ne 0 ]
  [[ "$output" == *'dots install rustdesk'* ]]
  unset MOCK_CLIENT
  export MOCK_VERSION=1.3.0
  rd_run setup_rustdesk_client --host example.com --key "$TEST_KEY"
  [ "$status" -ne 0 ]
  [ ! -s "$MOCK_LOG" ]
}

@test "RustDesk client sets and verifies network options and backs up previous values" {
  echo -n old.example.com >"$RD_TEST/options/custom-rendezvous-server"
  echo -n keep-password >"$RD_TEST/options/password"
  rd_run setup_rustdesk_client --host example.com --key "$TEST_KEY"
  [ "$status" -eq 0 ]
  [ "$(cat "$RD_TEST/options/custom-rendezvous-server")" = example.com ]
  [ "$(cat "$RD_TEST/options/relay-server")" = example.com:21117 ]
  [ "$(cat "$RD_TEST/options/key")" = "$TEST_KEY" ]
  [ ! -s "$RD_TEST/options/api-server" ]
  [ "$(cat "$RD_TEST/options/password")" = keep-password ]
  backup=$(find "$STATE_DIR/rustdesk" -type f)
  [ "$(stat -c %a "$backup")" = 600 ]
  bash "$backup"
  [ "$(cat "$RD_TEST/options/custom-rendezvous-server")" = old.example.com ]
}

@test "RustDesk client reports a no-op CLI as failure even with exit code zero" {
  export MOCK_IGNORE_OPTIONS=true
  rd_run setup_rustdesk_client --host example.com --key "$TEST_KEY"
  [ "$status" -ne 0 ]
  [[ "$output" == *'could not be verified'* ]]
}

@test "dots forwards RustDesk arguments and propagates errors from both commands" {
  for entry in rustdesk-server rustdesk-client; do
    branch=$(sed -n "/^  $entry)/,/^    ;;/p" "$TEST_REPO_ROOT/assets/scripts/main.sh")
    run bash -u -c '
      install_rustdesk_server() { printf "%s\n" "$*"; return 17; }
      setup_rustdesk_client() { printf "%s\n" "$*"; return 17; }
      body=$(printf "%s\n" "$1" | sed "1d;\$d")
      set -- dots placeholder --host example.com --key test
      eval "$body"
      exit 0
    ' bash "$branch"
    [ "$status" -eq 17 ]
    [ "$output" = '--host example.com --key test' ]
  done
}
