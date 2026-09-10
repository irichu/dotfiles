# Changelog

## 0.11.2

### Added

- Restic installation via APT, Homebrew, and Termux pkg.
- RustDesk server and client setup commands.

### Fixed

- Restored Snap CLI package installation in Ubuntu Desktop setup.

## 0.11.1 - 2026-09-06

### Fixed

- Homebrew environment changes now persist across batch steps, including installations on Arch Linux and Fedora.
- Fedora Homebrew prerequisites use explicit compiler packages compatible with DNF4 and DNF5.
- Neovim reinstalls replace existing libraries and runtime files together with the binary, removing obsolete files and stopping on installation failures.
- Chrome font setup accepts an omitted font name and creates missing preference entries while preserving unrelated settings and language-specific fonts.
- APT installations wait for package-manager locks and retry downloads; local Debian packages use APT to resolve dependencies instead of leaving packages unconfigured through direct `dpkg -i` installation.
- Flatpak applications are skipped when their shared setup fails, while independent installation steps continue.
- CI secret scanning and isolated batch continuation tests are more reliable.

### Changed

- Zoom is installed from Snap by the individual command and Ubuntu Desktop setup, and is no longer included in the Flatpak batch.
- Ubuntu Desktop temporarily inhibits automatic screen blanking and suspend during installation, with cleanup on completion and interruption and no changes to saved power settings.
- GNOME desktop setup explicitly selects the purple accent color when supported, alongside the existing dark style.

### Added

- Manual rebuilding and repair of release archives and checksums for an existing tag.
- Regression tests for APT contention, dependency handling, Neovim replacement, Chrome fonts, Zoom installation, and desktop inhibition.

## 0.11.0

### Added

- Release-based, SHA-256-verified installation with version pinning.
- Manifest-driven configuration presets and explicit non-interactive confirmation.
- Transaction history, `dots rollback`, `dots doctor`, and recoverable `dots uninstall`.
- Preservation and XDG-based storage for mutable Zsh history, generated completions, and completion caches.
- Backward-compatible `install.sh --gum` support and persistent installer debug/error logs.
- Automatic confirmation for batch installs, with a one-time Ubuntu Desktop notice that explicit `--yes` can skip.
- Best-effort batch execution with an end-of-run failure summary while retaining fail-fast individual installs.
- Flatpak setup and per-application installers for GIMP, Pinta, Thunderbird, and Zoom.
- Isolated smoke and Bats tests plus repository validation in CI.
- Documented platform support tiers and a v0.11 migration guide.

### Changed

- Strict shell error handling is enabled for the command runtime.
- `dots self-update` is separate from `dots packages update`.
- `dots clean` is limited to disposable caches.
- Completion and package metadata now have one canonical source.
- Starship Nerd Font preset generation is idempotent and overwrites an existing generated preset.
- Ubuntu Desktop uses APT for Ghostty on Ubuntu 26.04 and newer, with Snap retained for older releases.
- Desktop installation and CI cover additional architectures and Ubuntu versions.
- VS Code and VS Code Insiders use separate installers.
- Zed settings, keymaps, extension automation, and shell aliases have been expanded.

### Removed

- Duplicate CI Brewfile and Dockerfile copies.
- Unused `assets/csv` command data.

## 0.10.0 - 2026-05-16

### Added

- Ubuntu 26.04 installation and compatibility support.

### Changed

- Alacritty window decorations now follow the dark theme.

### Fixed

- Package and desktop setup scripts were updated for Ubuntu 26.04 compatibility.

## 0.9.0 - 2026-03-24

### Added

- Reusable Zsh completion generation and `dots` commands for installing completions.
- Ubuntu Desktop autoinstall configuration with APT mirror customization.
- Devbox configuration and updated data-directory handling.
- Alacritty desktop installation and additional mise-managed tools.
- CODEOWNERS and expanded Ulauncher configuration.

### Changed

- Shell scripts use the portable `/usr/bin/env bash` shebang.
- LazyVim bootstrap is skipped during installation to avoid intermittent failures.
- GNOME desktop setup, Yazi, LazyGit, and LazyVim configurations were refreshed.

### Fixed

- Rustup installation detection, configuration paths, Ulauncher autostart, and Chrome installation errors.

## 0.8.0 - 2026-02-07

### Added

- Bottom configuration and installation support.
- M PLUS 2 font setup, Chrome font configuration, AppImageLauncher, and LibreOffice installers.
- Difftastic, `jj`, Ulauncher, and additional CLI/TUI packages.
- Optional `cargo-binstall` support for faster Rust package installation.
- Broad Bats coverage for `dots` commands and automated Tokei repository statistics.
- ShogiHome and shogi-engine installation support.

### Changed

- Termux extra keys, terminal opacity defaults, application documentation, and editor configurations were expanded.

### Fixed

- Completion restoration and several GNOME dconf installation details were made more robust.

## 0.7.0 - 2025-08-07

### Added

- Installers for Google Chrome, Visual Studio Code, LocalSend, Obsidian, and Signal Desktop.
- GNOME favorite-app integration and the WSMatrix extension.
- Chrome font customization and expanded GUI application documentation.

### Changed

- Font configuration and tmux theme commands were updated.

## 0.6.3 - 2025-07-28

### Added

- Direct mise installation support.
- Go language support for LazyVim.

### Changed

- The default Starship layout changed from multiline to single-line.
- LazyGit, colorscheme, and package configurations were refreshed.

### Fixed

- Desktop theme installation now creates required icon directories and handles failures more robustly.

## 0.6.2 - 2025-07-21

### Added

- Mozc installation and additional desktop setup options.
- Wayland-aware custom keybindings and shortcuts.

### Changed

- Visual Studio Code installation and package lists were updated.

### Fixed

- VS Code desktop entries and the Alacritty paste binding were corrected.

## 0.6.1 - 2025-07-19

### Added

- Waydroid installation support.
- GNOME shell, GTK, and icon theme setup for a complete desktop appearance.
- The User Themes GNOME extension and `tldr` tooling.

### Changed

- Blink completion keymaps and Ubuntu Desktop documentation were updated.

## 0.6.0 - 2025-07-04

### Added

- `dots install --ubuntu-desktop` with GNOME settings, extensions, and desktop applications.
- Snap installation of GIMP, Thunderbird, Zoom, VS Code, and VS Code Insiders.
- GNOME favorite applications, Nautilus preferences, and GTK title-bar styling.
- Debug-mode support for installation troubleshooting.

### Changed

- Desktop setup scripts and paths were reorganized.
- Neovim paragraph navigation and desktop documentation were improved.

## 0.5.0 - 2025-06-16

### Added

- mise, GitUI, and Fastfetch configurations and installation support.
- Starship theme and terminal opacity management commands.
- Flameshot shortcuts and GNOME desktop settings managed through dconf.
- Zsh helpers for UFW and isolated `pip-audit` execution.
- Docker Compose v2 test configuration.

### Changed

- Alacritty and Ghostty gained configurable opacity presets.
- Fastfetch gained laptop, server, and logo variants.
- Neovim colorscheme configuration moved to a customized Sonokai setup.

## 0.4.0 - 2025-04-23

### Added

- macOS support and Ghostty configuration.
- GNOME custom-keybinding management, CopyQ, and Wake-on-LAN tooling.
- Zsh helpers for formatting Markdown, CSV, and TSV output.
- Additional Git aliases and autoloaded Zsh completions.

### Changed

- Configuration linking was refactored and VS Code settings were expanded.
- tmux plugin loading now accounts for architecture-specific support.

### Fixed

- Git user restoration and conditional tmux plugin loading.

## 0.3.0 - 2025-03-27

### Added

- Gum installation and Homebrew package support.
- Zsh completion definitions for the `dots` command.

## 0.2.2 - 2025-03-24

### Added

- Yazi configuration and backup handling.
- VS Code settings, keybindings, extension import/export, and additional extensions.
- Cargo-based Alacritty installation.
- Language-setting commands and additional Git, FNM, npm, and environment aliases.

### Changed

- Alacritty, Starship, theme management, and Docker distribution testing were expanded.

## 0.2.1 - 2025-03-19

### Added

- Random theme selection.
- Starship configuration, Zsh functions, and additional shell aliases.
- Additional terminal and development packages.

### Changed

- Alacritty, tmux status styling, and LazyGit configuration were updated.

### Fixed

- Locale handling on Arch Linux, symlink-aware backups, Alacritty keybindings, and Ripgrep paths.

## 0.2.0 - 2025-03-07

### Added

- Top-level `dots install` and `dots setup` command groups.
- Color-theme selection by number or name.
- Version reporting and command test coverage.

### Changed

- tmux bindings and Termux command usage were updated for the new command structure.

## 0.1.2 - 2025-03-02

### Changed

- Temporary-file handling and LazyVim configuration were updated.

### Fixed

- Release archives exclude `.git` metadata.
- Ripgrep configuration installation and several minor installer issues.

## 0.1.1 - 2025-03-01

### Added

- `dots update`, `dots docker test`, and `dots clean` commands.
- Ripgrep configuration, the `sd` utility, and broader container testing.
- Dependabot, security policy, contribution guides, and GitHub Pages support.

### Changed

- Scripts and documentation were reorganized into the current project structure.

### Fixed

- Unbound-variable handling in command dispatch.

## 0.1.0 - 2025-02-20

### Added

- Initial dotfiles, configuration files, and installation scripts.
- The `dots` command with Linux, Homebrew/Linuxbrew, and Termux setup paths.
- Installation through curl, wget, or a Git clone.
- Container tests for Ubuntu, Fedora, and Arch Linux.
- GitHub Actions release automation and the initial shell-alias documentation.
