#!/usr/bin/env bats

setup() {
  export TEST_ROOT="$BATS_TEST_TMPDIR/gnome-extensions"
  export GNOME_EXTENSIONS_DIR="$TEST_ROOT/extensions"
  export GEXT_COMMAND="$TEST_ROOT/gext"
  export GNOME_EXTENSIONS_COMMAND="$TEST_ROOT/gnome-extensions"
  export DOTS_EXTENSION_VERIFY_ATTEMPTS=1
  export SCRIPT="$BATS_TEST_DIRNAME/desktop/install-gnome-extensions.sh"
  mkdir -p "$GNOME_EXTENSIONS_DIR"

  cat >"$GEXT_COMMAND" <<'EOF'
#!/usr/bin/env bash
case "$GEXT_BEHAVIOR" in
  success)
    exit 0
    ;;
  recovered)
    mkdir -p "$GNOME_EXTENSIONS_DIR/$2"
    echo 'simulated D-Bus traceback' >&2
    exit 1
    ;;
  failure)
    echo 'simulated D-Bus traceback' >&2
    exit 1
    ;;
esac
EOF

  cat >"$GNOME_EXTENSIONS_COMMAND" <<'EOF'
#!/usr/bin/env bash
if [ "${1:-}" = list ]; then
  exit 0
fi
EOF
  chmod +x "$GEXT_COMMAND" "$GNOME_EXTENSIONS_COMMAND"
}

@test "a successful gext install succeeds" {
  export GEXT_BEHAVIOR=success

  run bash -c 'source "$SCRIPT"; install_one_gnome_extension test@example.com'

  [ "$status" -eq 0 ]
}

@test "a gext timeout is recovered when the extension was installed" {
  export GEXT_BEHAVIOR=recovered

  run bash -c 'source "$SCRIPT"; install_one_gnome_extension test@example.com'

  [ "$status" -eq 0 ]
  [[ "$output" == *"but the extension is installed"* ]]
  [[ "$output" != *"simulated D-Bus traceback"* ]]
}

@test "a real gext failure is reported" {
  export GEXT_BEHAVIOR=failure

  run bash -c 'source "$SCRIPT"; install_one_gnome_extension test@example.com'

  [ "$status" -ne 0 ]
  [[ "$output" == *"simulated D-Bus traceback"* ]]
  [[ "$output" == *"Failed to install GNOME extension: test@example.com"* ]]
}

@test "legacy Copilot extensions are not requested" {
  run grep -E '^github\.copilot(-chat)?$' "$BATS_TEST_DIRNAME/../../config/Code/User/myextensions/code-extensions.txt"

  [ "$status" -ne 0 ]
}
