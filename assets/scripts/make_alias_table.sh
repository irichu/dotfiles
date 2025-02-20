#!/usr/bin/env bash

set -ue
set -o pipefail

export LC_ALL=C

# check arg
if [ -z "$1" ]; then
  echo 'please specify a file or directory'
  exit 1
fi

# markdown table header
echo '| alias | entity |'
echo '| :- | :- |'

# print alias table with csview
rg -v '^\s*#' "$1" | rg -o 'alias .+=.+' | cut -d' ' -f2- | sed "s/=/\t/" | sed "s/|/\&#124;/g" | sed "s/'/\`/g" | csview --tsv --no-headers --style=markdown
