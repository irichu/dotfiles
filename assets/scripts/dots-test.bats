#!/usr/bin/env bats

set -ue
set -o pipefail

@test "dots help command works" {
    run dots help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage:"* ]]
}

@test "dots version command works" {
    run dots version
    [ "$status" -eq 0 ]
    [[ "$output" == *"dotfiles version"* ]]
}

@test "dots list command works" {
    run dots list --apt
    [ "$status" -eq 0 ]

    run dots list --brew
    [ "$status" -eq 0 ]

    run dots list --pkg
    [ "$status" -eq 0 ]

    run dots list --snap
    [ "$status" -eq 0 ]
}
