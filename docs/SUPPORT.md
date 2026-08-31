# Support policy

Support levels describe what is continuously tested, not every environment where the dotfiles may work.

## Tier 1

- Ubuntu 24.04 LTS
- Ubuntu 26.04 LTS

Tier 1 is the primary target. Installation, configuration application, rollback, and core command smoke tests are expected to pass before release.

## Tier 2

- Ubuntu 22.04 LTS
- Fedora (current stable)
- Arch Linux (rolling)
- macOS (current and previous major release)
- Termux from F-Droid (current)

Tier 2 receives best-effort support and CI coverage where practical. Platform-specific package availability can differ.

## Experimental

- WSL2

WSL2 generally follows Ubuntu behavior, but desktop integration, services, and filesystem semantics are not release guarantees yet.

Windows without WSL is not currently supported.
