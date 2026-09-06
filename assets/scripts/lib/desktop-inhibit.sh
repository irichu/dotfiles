#!/usr/bin/env bash

stop_desktop_inhibit() {
  # Batch steps run in subshells. Only the shell that started the inhibitor owns it.
  [ "${DESKTOP_INHIBIT_OWNER:-}" = "$BASHPID" ] || return 0
  if [ -n "${DESKTOP_INHIBIT_PID:-}" ]; then
    kill "$DESKTOP_INHIBIT_PID" 2>/dev/null || true
    wait "$DESKTOP_INHIBIT_PID" 2>/dev/null || true
  fi
  rm -f -- "$DESKTOP_INHIBIT_LOG"
  DESKTOP_INHIBIT_PID=""
  DESKTOP_INHIBIT_OWNER=""
  trap - EXIT INT TERM HUP
}

desktop_inhibit_exit() {
  local status="$1"
  stop_desktop_inhibit
  exit "$status"
}

start_desktop_inhibit() {
  local attempt
  [ -z "${DESKTOP_INHIBIT_OWNER:-}" ] || return 0
  if ! command -v gnome-session-inhibit >/dev/null 2>&1; then
    warning "Automatic screen blanking and suspend cannot be inhibited: gnome-session-inhibit is unavailable. Continuing."
    return 0
  fi
  if ! DESKTOP_INHIBIT_LOG=$(mktemp); then
    warning "Cannot prepare automatic screen blanking and suspend inhibition. Continuing."
    return 0
  fi

  # The main command has no other exit/signal traps; install these only for the
  # lifetime of the Ubuntu Desktop operation, after its start confirmation.
  DESKTOP_INHIBIT_OWNER="$BASHPID"
  trap 'desktop_inhibit_exit "$?"' EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM
  trap 'exit 129' HUP
  LC_ALL=C gnome-session-inhibit --app-id dots-ubuntu-desktop \
    --reason "Installing Ubuntu Desktop applications and settings" \
    --inhibit idle:suspend --inhibit-only >"$DESKTOP_INHIBIT_LOG" 2>&1 &
  DESKTOP_INHIBIT_PID=$!

  # GNOME 42 and later print this after the synchronous Inhibit call succeeds.
  # Bound startup time so an unavailable session bus cannot stall installation.
  for ((attempt = 0; attempt < 50; attempt++)); do
    if ! kill -0 "$DESKTOP_INHIBIT_PID" 2>/dev/null; then
      break
    fi
    if grep -Fxq 'Inhibiting until Ctrl+C is pressed...' "$DESKTOP_INHIBIT_LOG"; then
      info "Automatic screen blanking and suspend are inhibited during installation. Saved settings are unchanged."
      return 0
    fi
    sleep 0.1
  done

  warning "Could not confirm GNOME screen blanking and suspend inhibition. Continuing without it."
  cat "$DESKTOP_INHIBIT_LOG" >&2
  stop_desktop_inhibit
  return 0
}
