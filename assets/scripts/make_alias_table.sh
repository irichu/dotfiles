#!/bin/bash

if [ -z "$1" ]; then
  echo 'please specify a file or directory'
  exit 1
fi

# show alias table with csview
rg -v '^\s*#' "$1" | rg -o 'alias .+=.+' | cut -d' ' -f2- | sed "s/=/\t/" | sed "s/'//g" | sed "s/|/\&#124;/g" | csview --tsv --no-headers --style=markdown

