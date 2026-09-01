#!/usr/bin/env bash

desktop_entry_dirs() {
  if [ -n "${DOTS_DESKTOP_ENTRY_DIRS:-}" ]; then
    printf '%s\n' "$DOTS_DESKTOP_ENTRY_DIRS"
    return 0
  fi

  printf '%s\n' "${XDG_DATA_HOME:-$HOME/.local/share}/applications:$HOME/.local/share/flatpak/exports/share/applications:/var/lib/flatpak/exports/share/applications:/var/lib/snapd/desktop/applications:/usr/local/share/applications:/usr/share/applications"
}

desktop_entry_exists() {
  local desktop_id="$1"
  local directory
  local directories
  local -a directory_list
  directories="$(desktop_entry_dirs)"
  IFS=':' read -r -a directory_list <<<"$directories"

  for directory in "${directory_list[@]}"; do
    [ -n "$directory" ] && [ -f "$directory/$desktop_id" ] && return 0
  done

  return 1
}

first_existing_desktop_entry() {
  local desktop_id
  for desktop_id in "$@"; do
    if desktop_entry_exists "$desktop_id"; then
      printf '%s\n' "$desktop_id"
      return 0
    fi
  done
  return 1
}

build_desktop_favorites() {
  local desktop_id
  local candidates
  local -a candidate_ids

  while IFS= read -r candidates; do
    [ -z "$candidates" ] && continue
    # Candidate IDs never contain spaces. Prefer the first ID available from
    # the current installation method, and omit applications not installed.
    read -r -a candidate_ids <<<"$candidates"
    if desktop_id="$(first_existing_desktop_entry "${candidate_ids[@]}")"; then
      printf '%s\n' "$desktop_id"
    fi
  done <<'EOF'
google-chrome.desktop
firefox_firefox.desktop firefox.desktop
org.mozilla.thunderbird_esr.desktop org.mozilla.Thunderbird.desktop thunderbird_thunderbird.desktop
org.gnome.Nautilus.desktop
org.gimp.GIMP.desktop gimp_gimp.desktop
com.github.PintaProject.Pinta.desktop pinta_pinta.desktop
vlc.desktop
code.desktop
dev.zed.Zed.desktop
Alacritty.desktop alacritty.desktop alacritty_alacritty.desktop
com.mitchellh.ghostty.desktop ghostty_ghostty.desktop
obsidian.desktop
Waydroid.desktop
localsend_app.desktop
signal-desktop.desktop
rustdesk.desktop
us.zoom.Zoom.desktop zoom-client_zoom-client.desktop
org.gnome.Settings.desktop gnome-control-center.desktop
EOF
}

desktop_favorites_gvariant() {
  local favorites=()
  local desktop_id value='@as ['
  mapfile -t favorites < <(build_desktop_favorites)

  for desktop_id in "${favorites[@]}"; do
    if [ "$value" != '@as [' ]; then
      value+=', '
    fi
    value+="'$desktop_id'"
  done
  value+=']'
  printf '%s\n' "$value"
}

set_desktop_favorites() {
  dconf write /org/gnome/shell/favorite-apps "$(desktop_favorites_gvariant)"
}
