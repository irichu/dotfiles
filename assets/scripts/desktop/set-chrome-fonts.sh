#!/usr/bin/env bash

# Font name to set for Zyyy in Chrome
FONT_NAME="${1:-M PLUS 2}"

# Japanese font examples:
#   'Noto Sans CJK JP'
#   'M PLUS 1'
#   'M PLUS 2'
#   'BIZ UDGothic'
#   'BIZ UDPGothic'
#   'HackGen Console NF'
#   'HackGen35 Console NF'
# (SIL OPEN FONT LICENSE Version 1.1.)

# Chrome Preferences File Path
PREFS_PATH="$HOME/.config/google-chrome/Default/Preferences"

# Check if $FONT_NAME is installed
if ! fc-list | cut -d: -f2 | cut -d, -f1 | grep -Pq "^\s*${FONT_NAME}$"; then
  echo "⚠️ Font '$FONT_NAME' is not installed. Please install it first."
  exit 1
fi

# Check if jq is installed
if ! command -v jq >/dev/null; then
  echo "⚠️ jq is not installed. Please install jq to modify the Preferences file."
  exit 1
fi

# Check chrome installation and running status
if ! command -v google-chrome >/dev/null; then
  echo "Chrome is not installed. Please install Chrome first."
  exit 1
fi

if pgrep -x "chrome" >/dev/null; then
  echo "⚠️ Chrome is running. Please close it before modifying preferences."
  exit 1
fi

if google-chrome --version >/dev/null 2>&1; then
  echo "✅ Chrome is installed and not running."
else
  echo "Chrome is not properly installed or cannot be executed."
  exit 1
fi

# Preferences file existence check
if [ ! -f "$PREFS_PATH" ]; then
  echo "Chrome preferences file is not found at $PREFS_PATH."
  echo "Additional font settings are skipped."
  exit 1
fi

# backup Preferences file
cp "$PREFS_PATH" "${PREFS_PATH}.bak" || exit 1

# Create missing font families as well as updating existing ones. Chrome does
# not persist default font preferences until the user changes them.
if ! jq --arg font "$FONT_NAME" '
  .webkit.webprefs.fonts |= (
    . // {} |
    reduce ((keys + ["standard", "serif", "sansserif", "fixed", "cursive", "fantasy", "math"]) | unique[]) as $family
      (.; .[$family].Zyyy = $font)
  )
' "$PREFS_PATH" >"${PREFS_PATH}.tmp"; then
  rm -f -- "${PREFS_PATH}.tmp"
  echo "Failed to update Chrome font preferences." >&2
  exit 1
fi
mv -- "${PREFS_PATH}.tmp" "$PREFS_PATH" || exit 1

echo "✅ Updated all Zyyy font settings to '$FONT_NAME'"
