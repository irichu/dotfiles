#!/usr/bin/env bash

# Use APT's own dpkg lock waiting and dependency resolution. Never remove locks
# or stop unattended-upgrades; it may be configuring packages.
dots_apt_get() (
  set -o pipefail
  local lock_timeout="${DOTS_APT_LOCK_TIMEOUT:-600}"
  local log_file status deadline delay
  local -a pipeline_status
  if [[ ! "$lock_timeout" =~ ^[0-9]+$ ]]; then
    echo 'DOTS_APT_LOCK_TIMEOUT must be a non-negative number of seconds.' >&2
    return 2
  fi
  lock_timeout=$((10#$lock_timeout))
  log_file=$(mktemp) || return 1
  trap 'rm -f -- "$log_file"' EXIT
  deadline=$((SECONDS + lock_timeout))

  while :; do
    # Keep progress visible while retaining errors for lock-specific retries.
    if sudo env LC_ALL=C apt-get -o "DPkg::Lock::Timeout=$lock_timeout" \
      -o Acquire::Retries=3 -o APT::Update::Error-Mode=any "$@" 2>&1 | tee "$log_file"; then
      return 0
    else
      pipeline_status=("${PIPESTATUS[@]}")
      status=${pipeline_status[0]}
      [ "$status" -ne 0 ] || return "${pipeline_status[1]}"
    fi
    # DPkg::Lock::Timeout does not cover the package-list lock used by update.
    # Retry only lock contention, never dependency or package-script failures.
    if [ "${1:-}" != update ] || [ "$status" -ne 100 ] ||
      ! grep -Eq '^E: (Could not get lock |Unable to lock directory )' "$log_file" ||
      [ "$SECONDS" -ge "$deadline" ]; then
      return "$status"
    fi
    delay=$((deadline - SECONDS))
    [ "$delay" -le 5 ] || delay=5
    echo "APT package lists are locked by another process; retrying in $delay seconds." >&2
    sleep "$delay"
  done
)
