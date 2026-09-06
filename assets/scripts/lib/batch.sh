#!/usr/bin/env bash

BATCH_FAILURES=0
BATCH_FAILED_STEPS=()

reset_batch_results() {
  BATCH_FAILURES=0
  BATCH_FAILED_STEPS=()
}

record_batch_step_result() {
  local label="$1"
  local status="$2"

  if [ "$status" -eq 0 ]; then
    success "Batch step completed: $label"
    return 0
  fi

  # Explicit interruption should still stop the batch immediately.
  if [ "$status" -ge 128 ]; then
    error "Batch interrupted during $label (exit $status)."
    return "$status"
  fi

  BATCH_FAILURES=$((BATCH_FAILURES + 1))
  BATCH_FAILED_STEPS+=("$label (exit $status)")
  warning "Batch step failed: $label (exit $status). Continuing."
  return 0
}

run_batch_step() {
  local label="$1"
  shift
  local status

  info "Batch step: $label"
  set +e
  (
    set -Eeuo pipefail
    "$@"
  )
  status=$?
  set -e

  record_batch_step_result "$label" "$status"
}

# Run environment setup in the current shell so exported variables remain
# available to later isolated batch steps.
run_batch_environment_step() {
  local label="$1"
  shift
  local status

  info "Batch step: $label"
  set +e
  "$@"
  status=$?
  set -e

  record_batch_step_result "$label" "$status"
}

run_batch_plan() {
  local step
  for step in "$@"; do
    run_batch_step "$step" "$step"
  done
}

# Skip dependent applications when their shared prerequisite failed, while
# allowing unrelated batch steps to continue as usual.
run_batch_dependent_plan() {
  local prerequisite="$1"
  local failures_before="$BATCH_FAILURES"
  shift
  run_batch_step "$prerequisite" "$prerequisite"
  if [ "$BATCH_FAILURES" -ne "$failures_before" ]; then
    warning "Skipping dependent steps because $prerequisite failed: $*"
    return 0
  fi
  run_batch_plan "$@"
}

finish_batch_install() {
  if [ "$BATCH_FAILURES" -eq 0 ]; then
    success "All batch installation steps completed."
    return 0
  fi

  error "Batch installation finished with $BATCH_FAILURES failed step(s):"
  printf '  - %s\n' "${BATCH_FAILED_STEPS[@]}" >&2
  return 1
}

refresh_homebrew_environment() {
  local brew_candidate
  for brew_candidate in \
    /home/linuxbrew/.linuxbrew/bin/brew \
    /opt/homebrew/bin/brew \
    /usr/local/bin/brew; do
    if [ -x "$brew_candidate" ]; then
      eval "$("$brew_candidate" shellenv)"
      return 0
    fi
  done
  return 1
}
