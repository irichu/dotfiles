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

@test "dots starship command works" {
    run dots starship
    [ "$status" -eq 0 ]

    run dots starship default
    [ "$status" -eq 0 ]

    run dots starship simple
    [ "$status" -eq 0 ]

    run dots set-starship default
    [ "$status" -eq 0 ]

    run dots set-starship simple
    [ "$status" -eq 0 ]
}

@test "dots set-lang command works" {
    run dots set-lang en_US.UTF-8
    [ "$status" -eq 0 ]

    run dots set-lang ja_JP.UTF-8
    [ "$status" -eq 0 ]
}

@test "dots set-opacity command works" {
    run dots opacity
    [ "$status" -eq 0 ]

    run dots set-opacity 0.0
    [ "$status" -eq 0 ]

    run dots opacity
    [ "$status" -eq 0 ]

    run dots set-opacity 1.0
    [ "$status" -eq 0 ]

    run dots opacity
    [ "$status" -eq 0 ]

    run dots set-opacity 0.5
    [ "$status" -eq 0 ]

    run dots set-opacity 1.5
    [ "$status" -eq 1 ]

    run dots set-opacity 2
    [ "$status" -eq 1 ]

    run dots set-opacity -0.1
    [ "$status" -eq 1 ]
}

@test "dots upgrade command works" {
    run dots upgrade
    [ "$status" -eq 0 ]
}
