#!/usr/bin/env bash

#
# convert-md-links.sh
#
# Description:
# This script converts inline Markdown links `[text](url)` into reference-style links:
# `[text]` with corresponding references at the bottom of the file.
# It also automatically removes duplicate links.
#
# Usage:
#   ./convert-md-links.sh <markdown_file>
#
# Example:
#   ./convert-md-links.sh README.md
#
# What it does:
# - Replaces inline links like `[GitHub](https://github.com)` with `[GitHub]`
# - Appends corresponding reference links at the end of the file:
#     [GitHub]: https://github.com
#
# Requirements:
# - ripgrep (rg)
# - sd (sed alternative with simpler syntax)
#
# Notes:
# - Make sure to back up your file before running the script, as it performs in-place editing.

set -ue
set -o pipefail

export LC_ALL=C

# Check argument
if [ ! -f "${1:-}" ]; then
  echo 'Please specify a markdown file as an argument.'
  exit 1
fi

check_command() {
  if ! command -v "$1" &>/dev/null; then
    echo "Error: $1 command not found."
    exit 1
  fi
}

# Check if rg and sd commands exist
check_command "rg"
check_command "sd"

# Generate reference links
extracted="$(rg -oN '\[([^\[\]]+?)\]\(([^\(\)]+?)\)' "$1")"
reference_links="$(echo "$extracted" | sd '\[([^\[\]]+?)\]\((.+?)\)' '[$1]: $2' | awk '!a[$0]++')"

# Check if there are any links
if [ -n "$reference_links" ]; then
  echo '' >> "$1"
  echo '<!-- Reference-style links -->' >> "$1"
  echo "$reference_links" >> "$1"

  # Replace inline links with reference links
  sd '\[([^\[\]]+?)\]\([^\(\)]+?\)' '[$1]' "$1"
  
  echo "Links have been converted to reference style in $1."
  echo ''
  echo "--- Before ---------------------------------------"  
  echo "$extracted"
  echo ''
  echo "--- After ----------------------------------------"
  echo "$reference_links"
  echo ''

else
  echo "No links found in $1."
fi
