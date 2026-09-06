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

  cat >"$MOCK_BIN/flatpak" <<'EOF'
#!/usr/bin/env bash
printf 'flatpak %s\n' "$*" >>"$MOCK_LOG"
app_id="${*: -1}"
case "${1:-}" in
info)
  [ "${MOCK_INSTALLED:-}" = "$app_id" ]
  ;;
remote-info)
  [ "${MOCK_UNAVAILABLE:-}" != "$app_id" ]
  ;;
*)
  exit 0
  ;;
esac
EOF

  chmod +x "$MOCK_BIN/sudo" "$MOCK_BIN/flatpak"
}

@test "Flatpak setup registers the system Flathub remote" {
  run bash "$TEST_REPO_ROOT/assets/scripts/desktop/flatpak/install-flatpak.sh"
  [ "$status" -eq 0 ]
  grep -Fq "sudo flatpak remote-add --system --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo" "$MOCK_LOG"
}

@test "each application script installs exactly its Flathub application" {
  while IFS='|' read -r script app_id; do
    : >"$MOCK_LOG"
    run bash "$TEST_REPO_ROOT/assets/scripts/desktop/flatpak/$script"
    [ "$status" -eq 0 ]
    grep -Fq "sudo flatpak install --system -y flathub $app_id" "$MOCK_LOG"
  done <<'EOF'
install-gimp.sh|org.gimp.GIMP
install-pinta.sh|com.github.PintaProject.Pinta
install-thunderbird.sh|org.mozilla.thunderbird_esr
EOF
}

@test "an installed Flatpak application is skipped" {
  export MOCK_INSTALLED="org.gimp.GIMP"

  run bash "$TEST_REPO_ROOT/assets/scripts/desktop/flatpak/install-gimp.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *"already installed"* ]]
  ! grep -Fq "flatpak install" "$MOCK_LOG"
}

@test "an unavailable Flatpak application fails without installing" {
  export MOCK_UNAVAILABLE="org.gimp.GIMP"

  run bash "$TEST_REPO_ROOT/assets/scripts/desktop/flatpak/install-gimp.sh"
  [ "$status" -ne 0 ]
  [[ "$output" == *"not available from Flathub"* ]]
  ! grep -Fq "flatpak install" "$MOCK_LOG"
}
