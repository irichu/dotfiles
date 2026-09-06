#!/usr/bin/env bats

setup() {
  TEST_REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  export HOME="$BATS_TEST_TMPDIR/home"
  export PATH="$BATS_TEST_TMPDIR/bin:$PATH"
  PREFS_PATH="$HOME/.config/google-chrome/Default/Preferences"
  mkdir -p "$(dirname "$PREFS_PATH")" "$BATS_TEST_TMPDIR/bin"
  printf '#!/usr/bin/env bash\nprintf "font.ttf: M PLUS 2\\nfont.ttf: Noto Sans CJK JP\\n"\n' >"$BATS_TEST_TMPDIR/bin/fc-list"
  printf '#!/usr/bin/env bash\nexit 0\n' >"$BATS_TEST_TMPDIR/bin/google-chrome"
  printf '#!/usr/bin/env bash\nexit 1\n' >"$BATS_TEST_TMPDIR/bin/pgrep"
  chmod +x "$BATS_TEST_TMPDIR/bin/"*
}

@test "Chrome fonts creates missing parent objects and font families" {
  for input in '{}' '{"webkit":{}}' '{"webkit":{"webprefs":{}}}' '{"webkit":{"webprefs":{"fonts":{}}}}'; do
    printf '%s\n' "$input" >"$PREFS_PATH"
    run bash "$TEST_REPO_ROOT/assets/scripts/desktop/set-chrome-fonts.sh"
    [ "$status" -eq 0 ]
    jq -e '.webkit.webprefs.fonts | length == 7 and all(.[]; .Zyyy == "M PLUS 2")' "$PREFS_PATH"
    [ "$(cat "${PREFS_PATH}.bak")" = "$input" ]
    [ ! -e "${PREFS_PATH}.tmp" ]
  done
}

@test "Chrome fonts updates existing values and preserves other preferences" {
  cat >"$PREFS_PATH" <<'EOF'
{"profile":{"name":"Person 1"},"webkit":{"webprefs":{"default_font_size":16,"fonts":{"standard":{"Zyyy":"Old","Jpan":"Japanese"},"serif":{},"pictograph":{"Zyyy":"Legacy"}}}}}
EOF
  run bash "$TEST_REPO_ROOT/assets/scripts/desktop/set-chrome-fonts.sh" 'Noto Sans CJK JP'
  [ "$status" -eq 0 ]
  jq -e '
    .profile.name == "Person 1" and
    .webkit.webprefs.default_font_size == 16 and
    .webkit.webprefs.fonts.standard.Jpan == "Japanese" and
    (.webkit.webprefs.fonts | length == 8 and all(.[]; .Zyyy == "Noto Sans CJK JP"))
  ' "$PREFS_PATH"
  cp "$PREFS_PATH" "$BATS_TEST_TMPDIR/expected.json"
  run bash "$TEST_REPO_ROOT/assets/scripts/desktop/set-chrome-fonts.sh" 'Noto Sans CJK JP'
  [ "$status" -eq 0 ]
  cmp "$PREFS_PATH" "$BATS_TEST_TMPDIR/expected.json"
}

@test "invalid Chrome preferences remain unchanged and report failure" {
  printf 'invalid json\n' >"$PREFS_PATH"
  run bash "$TEST_REPO_ROOT/assets/scripts/desktop/set-chrome-fonts.sh"
  [ "$status" -ne 0 ]
  [[ "$output" != *"Updated all"* ]]
  [ "$(cat "$PREFS_PATH")" = 'invalid json' ]
  cmp "$PREFS_PATH" "${PREFS_PATH}.bak"
  [ ! -e "${PREFS_PATH}.tmp" ]
}
