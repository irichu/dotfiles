#!/usr/bin/env bash

set -ue pipefail

sessions=$(tmux ls -F '#S' | grep '^[0-9]\+$' | sort)

new_number=0
for number in $sessions; do
  tmux rename -t "$number" $new_number
  ((new_number += 1))
done
