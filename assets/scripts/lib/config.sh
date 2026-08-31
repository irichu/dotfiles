#!/usr/bin/env bash

readonly CONFIG_MANIFEST="$SCRIPT_DIR/assets/tsv/configs.tsv"
TRANSACTION_ACTIVE=false
TRANSACTION_ID=""
TRANSACTION_DIR=""
TRANSACTION_INDEX=0
BACKUP_RESULT="-"

transaction_begin() {
  local kind="${1:-apply}"
  if "$TRANSACTION_ACTIVE"; then
    return 0
  fi
  mkdir -p "$STATE_DIR/transactions"
  TRANSACTION_DIR="$(mktemp -d "$STATE_DIR/transactions/$(date +'%Y%m%d-%H%M%S')-XXXXXX")"
  TRANSACTION_ID="$(basename "$TRANSACTION_DIR")"
  mkdir -p "$TRANSACTION_DIR/backups"
  printf 'action\ttarget\tbackup\tsource\n' >"$TRANSACTION_DIR/operations.tsv"
  printf '%s\n' "$kind" >"$TRANSACTION_DIR/kind"
  TRANSACTION_ACTIVE=true
}

transaction_record() {
  printf '%s\t%s\t%s\t%s\n' "$1" "$2" "${3:--}" "${4:--}" >>"$TRANSACTION_DIR/operations.tsv"
}

transaction_commit() {
  if ! "$TRANSACTION_ACTIVE"; then
    return 0
  fi
  if [ "$(wc -l <"$TRANSACTION_DIR/operations.tsv")" -le 1 ]; then
    rm -rf -- "$TRANSACTION_DIR"
    info "No configuration changes were necessary."
  else
    printf 'complete\n' >"$TRANSACTION_DIR/status"
    success "Transaction recorded: $TRANSACTION_ID"
  fi
  TRANSACTION_ACTIVE=false
}

platform_matches() {
  local supported="$1"
  local platform
  platform="$(dots_platform)"
  [ "$supported" = all ] || [[ ",$supported," == *",$platform,"* ]]
}

manifest_rows() {
  [ -f "$CONFIG_MANIFEST" ] || { error "Configuration manifest not found: $CONFIG_MANIFEST"; return 1; }
  grep -v '^[[:space:]]*#' "$CONFIG_MANIFEST" | grep -v '^[[:space:]]*$'
}

manifest_row_selected() {
  local app="$1" preset="$2" default_value="$3"
  shift 3
  if [ "$#" -eq 0 ]; then
    [ "$default_value" = yes ]
    return
  fi
  local selector
  for selector in "$@"; do
    if [ "$selector" = all ] || [ "$selector" = "$app" ] || [ "$selector" = "$preset" ]; then
      return 0
    fi
  done
  return 1
}

migrate_zsh_state() {
  local legacy_history="$CONFIG_HOME/zsh/.zsh_history"
  local history_dir="$STATE_HOME/zsh"
  local history_file="$history_dir/history"
  local legacy_completions="$CONFIG_HOME/zsh/completions"
  local completions_dir="$DATA_HOME/zsh/completions"
  local entry destination

  mkdir -p "$history_dir" "$completions_dir"
  if [ -f "$legacy_history" ] && [ ! -e "$history_file" ]; then
    cp -p -- "$legacy_history" "$history_file"
    info "Preserved Zsh history at: $history_file"
  fi
  if [ -d "$legacy_completions" ]; then
    while IFS= read -r entry; do
      destination="$completions_dir/$(basename "$entry")"
      if [ ! -e "$destination" ] && [ ! -L "$destination" ]; then
        cp -a -- "$entry" "$destination"
      fi
    done < <(find "$legacy_completions" -mindepth 1 -maxdepth 1 -print)
    info "Preserved Zsh completions at: $completions_dir"
  fi
}

backup_target() {
  local target="$1"
  BACKUP_RESULT="-"
  if [ -e "$target" ] || [ -L "$target" ]; then
    TRANSACTION_INDEX=$((TRANSACTION_INDEX + 1))
    BACKUP_RESULT="$TRANSACTION_DIR/backups/$TRANSACTION_INDEX"
    mv -- "$target" "$BACKUP_RESULT"
  fi
}

apply_link_entry() {
  local source="$1" target="$2"
  local current=""
  if [ -L "$target" ]; then
    current="$(readlink "$target")"
    [ "$current" = "$source" ] && return 0
  fi
  local backup
  backup_target "$target"
  backup="$BACKUP_RESULT"
  transaction_record link "$target" "$backup" "$source"
  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
}

apply_copy_entry() {
  local source="$1" target="$2"
  if [ -f "$target" ] && cmp -s "$source" "$target"; then
    return 0
  fi
  local backup
  backup_target "$target"
  backup="$BACKUP_RESULT"
  transaction_record copy "$target" "$backup" "$source"
  mkdir -p "$(dirname "$target")"
  cp -a -- "$source" "$target"
}

apply_manifest_entry() {
  local app="$1" source_rel="$2" target_rel="$3" strategy="$4"
  local source="$SCRIPT_DIR/$source_rel"
  local target="$CONFIG_HOME/$target_rel"
  [ -e "$source" ] || { error "Missing source for $app: $source"; return 1; }
  path_is_within "$target" "$CONFIG_HOME" || { error "Unsafe config target: $target"; return 1; }
  case "$strategy" in
  link) apply_link_entry "$source" "$target" ;;
  copy) apply_copy_entry "$source" "$target" ;;
  *) error "Unknown configuration strategy: $strategy"; return 1 ;;
  esac
}

set_config() {
  local package_name="${1:-}"
  [ -n "$package_name" ] || { error "A configuration name is required"; return 1; }
  local row
  row="$(manifest_rows | awk -F '\t' -v app="$package_name" '$1 == app && $6 == "link" {print; exit}')"
  [ -n "$row" ] || { error "No link configuration found for $package_name"; return 1; }
  local app source_rel target_rel platforms preset strategy default_value
  IFS=$'\t' read -r app source_rel target_rel platforms preset strategy default_value <<<"$row"
  platform_matches "$platforms" || { warning "$app is not supported on $(dots_platform)"; return 0; }
  info "Configuration change: $CONFIG_HOME/$target_rel -> $SCRIPT_DIR/$source_rel"
  confirm "Apply $app configuration?" || { info "Canceled."; return 1; }
  [ "$app" != zsh ] || migrate_zsh_state
  transaction_begin "setup-$app"
  if ! apply_manifest_entry "$app" "$source_rel" "$target_rel" "$strategy"; then
    rollback_directory "$TRANSACTION_DIR"
    return 1
  fi
  transaction_commit
}

apply_settings() {
  local -a selectors=("$@")
  local -a selected_rows=()
  local app source_rel target_rel platforms preset strategy default_value row
  while IFS=$'\t' read -r app source_rel target_rel platforms preset strategy default_value; do
    platform_matches "$platforms" || continue
    if manifest_row_selected "$app" "$preset" "$default_value" "${selectors[@]}"; then
      selected_rows+=("$app"$'\t'"$source_rel"$'\t'"$target_rel"$'\t'"$strategy")
    fi
  done < <(manifest_rows)

  [ "${#selected_rows[@]}" -gt 0 ] || { error "No matching configurations found"; return 1; }
  info "The following configuration entries will be applied:"
  printf '  - %s\n' "${selected_rows[@]}" | cut -f1,3
  confirm "Continue with configuration changes?" || { info "Canceled."; return 1; }

  for row in "${selected_rows[@]}"; do
    IFS=$'\t' read -r app source_rel target_rel strategy <<<"$row"
    if [ "$app" = zsh ]; then
      migrate_zsh_state
      break
    fi
  done

  transaction_begin apply
  for row in "${selected_rows[@]}"; do
    IFS=$'\t' read -r app source_rel target_rel strategy <<<"$row"
    if ! apply_manifest_entry "$app" "$source_rel" "$target_rel" "$strategy"; then
      error "Configuration failed; restoring the previous state."
      rollback_directory "$TRANSACTION_DIR"
      return 1
    fi
  done
  transaction_commit
}

latest_transaction() {
  local directory latest=""
  while IFS= read -r directory; do
    [ "$(cat "$directory/status" 2>/dev/null || true)" = complete ] && latest="$directory"
  done < <(find "$STATE_DIR/transactions" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort)
  printf '%s\n' "$latest"
}

rollback_directory() {
  local directory="$1"
  awk 'NR > 1 {line[NR]=$0} END {for (i=NR; i>1; i--) print line[i]}' "$directory/operations.tsv" \
    | while IFS=$'\t' read -r action target backup source; do
        case "$action" in
        link)
          if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
            unlink "$target"
          elif [ -e "$target" ] || [ -L "$target" ]; then
            warning "Rollback retained a changed target; its backup remains at $backup: $target"
            continue
          fi
          ;;
        copy)
          if [ -f "$target" ] && cmp -s "$target" "$source"; then
            rm -f -- "$target"
          elif [ -e "$target" ] || [ -L "$target" ]; then
            warning "Rollback retained a changed target; its backup remains at $backup: $target"
            continue
          fi
          ;;
        esac
        if [ "$backup" != "-" ] && { [ -e "$backup" ] || [ -L "$backup" ]; }; then
          mkdir -p "$(dirname "$target")"
          mv -- "$backup" "$target"
        fi
      done
  printf 'rolled-back\n' >"$directory/status"
  TRANSACTION_ACTIVE=false
}

rollback_transaction() {
  local requested="${1:-latest}"
  local directory
  if [ "$requested" = latest ]; then
    directory="$(latest_transaction)"
  else
    case "$requested" in
    *[!A-Za-z0-9._-]*) error "Invalid transaction ID: $requested"; return 2 ;;
    esac
    directory="$STATE_DIR/transactions/$requested"
  fi
  [ -n "$directory" ] && [ -f "$directory/operations.tsv" ] || {
    error "Transaction not found: $requested"
    return 1
  }
  confirm "Rollback transaction $(basename "$directory")?" || { info "Canceled."; return 1; }

  rollback_directory "$directory"
  success "Rolled back transaction $(basename "$directory")"
}
