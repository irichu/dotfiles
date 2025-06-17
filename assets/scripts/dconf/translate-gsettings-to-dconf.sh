#!/bin/bash

# Converts a script of `gsettings set` commands to equivalent `dconf write` commands.
# Usage: ./gsettings_to_dconf.sh gsettings_script.sh > dconf_script.sh

input="$1"

if [[ -z "$input" ]]; then
  echo "Usage: $0 <gsettings_script.sh>" >&2
  exit 1
fi

while IFS= read -r line; do
  # Skip empty lines and comments
  [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue

  # Match lines like: gsettings set SCHEMA KEY VALUE
  if [[ "$line" =~ ^[[:space:]]*gsettings[[:space:]]+set[[:space:]]+([^[:space:]]+)[[:space:]]+([^[:space:]]+)[[:space:]]+(.+)$ ]]; then
    schema="${BASH_REMATCH[1]}"
    key="${BASH_REMATCH[2]}"
    value="${BASH_REMATCH[3]}"

    # Convert schema to path (dots to slashes)
    dconf_path="/${schema//./\/}/${key}"

    # Output the equivalent dconf write command
    echo "dconf write ${dconf_path} ${value}"
  else
    echo "# Skipped (unrecognized format): $line" >&2
  fi
done <"$input"
