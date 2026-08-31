# Migration guide: v0.11

Version 0.11 focuses on reproducibility and safe recovery. Existing configurations are not removed automatically.

## Installation and updates

- `install.sh` now installs the latest GitHub Release by default and verifies its SHA-256 checksum.
- Use `install.sh --version v0.11.0` to pin a release.
- Use `install.sh --channel main` only when you intentionally want an unverified development snapshot.
- The legacy `install.sh --gum` option remains available and installs Gum plus its Zsh completion.
- Installer activity is recorded in `${XDG_STATE_HOME:-~/.local/state}/dotfiles/debug.log`; failures are also appended to `errors.log`.
- Use `dots self-update` to update the dotfiles themselves.
- Use `dots packages update` to update installed packages. The old `up`, `update`, and `upgrade` aliases warn and remain temporarily for migration.

## Configuration changes

- `dots apply` displays the selected entries and asks once before modifying files.
- Non-interactive use must pass `--yes`, for example `dots --yes apply core`.
- Every changed target is recorded under `${XDG_STATE_HOME:-~/.local/state}/dotfiles/transactions`.
- `dots rollback [latest|TRANSACTION_ID]` restores the previous state.
- Neovim overlay files use copy semantics. `dots uninstall` retains those copied files to avoid deleting later user edits.
- Existing Zsh history is migrated to `${XDG_STATE_HOME:-~/.local/state}/zsh/history`.
- Existing and generated Zsh completions are preserved under `${XDG_DATA_HOME:-~/.local/share}/zsh/completions`; completion caches use `${XDG_CACHE_HOME:-~/.cache}/zsh`.

## Cleanup and removal

- `dots clean` removes only disposable dotfiles caches. It no longer removes configuration backups.
- `dots uninstall` removes managed symlinks and the command, then moves the installed data directory into the state directory so it remains recoverable.
- The unused `assets/csv` compatibility data was removed. Command and configuration metadata now live in `assets/tsv`.

Run `dots doctor` after upgrading to verify paths, manifests, and managed links.
