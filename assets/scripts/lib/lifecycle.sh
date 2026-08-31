#!/usr/bin/env bash

dots_doctor() {
  local failures=0
  info "Platform: $(dots_platform) ($(uname -m))"
  info "Repository: $SCRIPT_DIR"
  info "Config home: $CONFIG_HOME"
  info "State home: $STATE_DIR"

  for command_name in bash git tar; do
    if cmd_exists "$command_name"; then
      success "Found $command_name"
    else
      error "Missing required command: $command_name"
      failures=$((failures + 1))
    fi
  done

  if [ ! -f "$CONFIG_MANIFEST" ]; then
    error "Missing configuration manifest"
    failures=$((failures + 1))
  fi

  local app source_rel target_rel platforms preset strategy default_value
  while IFS=$'\t' read -r app source_rel target_rel platforms preset strategy default_value; do
    [ -e "$SCRIPT_DIR/$source_rel" ] || {
      error "Manifest source is missing: $source_rel"
      failures=$((failures + 1))
    }
  done < <(manifest_rows)

  if [ "$failures" -eq 0 ]; then
    success "Doctor found no problems."
  else
    error "Doctor found $failures problem(s)."
    return 1
  fi
}

self_update() {
  local installer="$SCRIPT_DIR/install.sh"
  [ -f "$installer" ] || { error "Installer not found: $installer"; return 1; }
  bash "$installer" --remote "$@"
}

uninstall_dotfiles() {
  info "Managed configuration links and the dots command will be removed."
  info "Copied configuration overlays are retained."
  confirm "Uninstall managed dotfiles?" || { info "Canceled."; return 1; }

  local app source_rel target_rel platforms preset strategy default_value target source
  while IFS=$'\t' read -r app source_rel target_rel platforms preset strategy default_value; do
    [ "$strategy" = link ] || continue
    target="$CONFIG_HOME/$target_rel"
    source="$SCRIPT_DIR/$source_rel"
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
      unlink "$target"
      info "Removed link: $target"
    fi
  done < <(manifest_rows)

  local command_path
  for command_path in "$HOME/.local/bin/dots" /data/data/com.termux/files/usr/bin/dots; do
    if [ -f "$command_path" ] && cmp -s "$command_path" "$SCRIPT_DIR/assets/scripts/main.sh"; then
      rm -f -- "$command_path"
    elif [ -e "$command_path" ] || [ -L "$command_path" ]; then
      warning "Retained command not owned by this installation: $command_path"
    fi
  done

  if [ "$SCRIPT_DIR" = "$DATA_DIR" ] && [ -d "$DATA_DIR" ]; then
    local recovery_root="$STATE_DIR/uninstall"
    local recovery_container recovery_dir
    mkdir -p "$recovery_root"
    recovery_container="$(mktemp -d "$recovery_root/$(date +'%Y%m%d-%H%M%S')-XXXXXX")"
    recovery_dir="$recovery_container/dotfiles-main"
    mv -- "$DATA_DIR" "$recovery_dir"
    success "Installation moved to recoverable location: $recovery_dir"
  fi
  success "Managed dotfiles were uninstalled."
}

clean() {
  local mode="${1:-cache}"
  case "$mode" in
  cache)
    info "Cache contents to remove: $CACHE_DIR"
    confirm "Clear the dotfiles cache?" || { info "Canceled."; return 1; }
    safe_clear_directory "$CACHE_DIR" "$CACHE_HOME"
    ;;
  backup)
    info "Backups are retained for rollback safety. Remove individual transaction directories manually."
    ;;
  config)
    info "Legacy config backups are not automatically removed."
    ;;
  all)
    info "Only cache data is automatically removable; transaction and config backups are retained."
    confirm "Clear the dotfiles cache?" || { info "Canceled."; return 1; }
    safe_clear_directory "$CACHE_DIR" "$CACHE_HOME"
    ;;
  *) error "Usage: dots clean {cache|backup|config|all}"; return 1 ;;
  esac
}
