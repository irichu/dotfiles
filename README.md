# Dotfiles

<p>
  <img src="https://img.shields.io/github/languages/code-size/irichu/dotfiles?style=for-the-badge&logo=github&color=%2377aaff" alt="GitHub code size in bytes" height="22">
  <img src="https://img.shields.io/github/repo-size/irichu/dotfiles?style=for-the-badge&logo=github&color=%2377aaff" alt="GitHub repo size" height="22">
  <a href="https://github.com/irichu/dotfiles">
    <img src="https://tokei.rs/b1/github/irichu/dotfiles?category=lines&style=for-the-badge&logo=https://simpleicons.org/icons/github.svg&color=%2377aaff"
        alt="Tokei total line"
        height="22">
  </a>
</p>

<!--
<img src="https://img.shields.io/github/created-at/irichu/dotfiles?style=for-the-badge&logo=github&color=%2355ff99" alt="GitHub Created At" height="22"> 
-->

<p>
  <img src="https://img.shields.io/github/license/irichu/dotfiles?style=for-the-badge&logo=github&color=%2355ff99" alt="GitHub License" height="22">
  <img src="https://img.shields.io/github/last-commit/irichu/dotfiles?style=for-the-badge&logo=github&color=%2355ff99" alt="GitHub last commit" height="22">
  <img src="https://img.shields.io/github/stars/irichu/dotfiles?style=for-the-badge&logo=github&color=%23ffdd33" alt="GitHub Repo stars" height="22">
</p>

[English] [[日本語](docs/README-ja.md)]

## 😸 Welcome

Welcome to my dotfiles. This repository helps easily set up a fast and intuitive terminal environment. This setup installs Zsh with starship prompt, tmux, Neovim, and Golang and Rust-based command-line tools that starts and operates quickly. Grateful that you found this project and took a look!

### Linux

<img src="https://github.com/user-attachments/assets/29e13d2f-a04b-428e-9126-e02b5c5c5911" width="800">

### Android Termux

<img src="https://github.com/user-attachments/assets/4f64bb0f-6e57-4fd7-8318-8d92da2b109a" width="320">

### WSL2

<img src="https://github.com/user-attachments/assets/3c3860f3-f184-4a50-8c5d-15aaa8079800" width="800" alt="wsl_zsh_nvim_startuptime">

### Neovim / Tmux Screenshots

|                                          LazyVim tokyonight.nvim style=night                                          |
| :-------------------------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/53567c2d-8bf2-4f4b-81d8-c6f126895606" width="800" alt="LazyVim"> |


|                                                        Tmux split window                                                        |
| :-----------------------------------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/2be4ac55-e412-4fa4-a8c8-ec517c70dec0" width="800" alt="Tmux split window"> |

|                                                        Tmux synchronize-panes mode                                                        |
| :---------------------------------------------------------------------------------------------------------------------------------------: |
|                <span style="font-size:12px">alias tid='tmux display -pt "${TMUX_PANE:?}" "#{pane_index}"'</span>                          |
| <img src="https://github.com/user-attachments/assets/7effb2bf-b3c8-47bb-91e9-e80e73090d3a" width="800" alt="Tmux synchronize-panes mode"> |

## 🚀 Installation

1. Download

```bash
git clone https://github.com/irichu/dotfiles.git
cd dotfiles
```

2. Install

> [!NOTE] 
> Install all components using your preferred package manager:<br>
> ./install.sh all [apt|brew|snap|pkg]<br>
> Replace [apt|brew|snap|pkg] with your package manager of choice.

For example, to use brew on Linux

```bash
./install.sh all brew
```

To use pkg on Termux

```bash
./install.sh all pkg
```

## ✅ Supported OS

- Linux 🐧
  - Ubuntu 22.04 and newer (recommended)
  - Arch Linux
  - Fedora
- Android 📱
  - The latest version of Termux

## ✨ Features

- **Shell**: zsh with the starship prompt
- **Editor**: Neovim configured via LazyVim
- **Terminal Multiplexers**: tmux for session management, zellij for workspace management
- **TUI File Managers**: broot for efficient navigation, yazi for rapid file access
- **Terminal Emulator**: Alacritty for performance, Termux for Android environments

## 📗 Basic commands

Show help and available commands:

```bash
./install.sh --help
```

Copy $XDG_CONFIG_HOME to $XDG_DATA_HOME/dotfiles/backup dir:

```bash
./install.sh backup
```

Show install target package list:

```bash
./install.sh list [apt|brew|snap|pkg]
```

Install individual package:

```bash
./install.sh [package_name]
```

|                                                     Help image                                                     |
| :----------------------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/2be34e8d-4dfa-4c3e-9a85-6d3c9cfd6053" width="800" alt="help"> |

### 🖥️ Install individual package

| Package Name    | Description                                 |
| --------------- | ------------------------------------------- |
| `hackgen`       | HackGen font (Nerd Font)                    |
| `docker`        | docker-ce (additional repository)           |
| `fnm`           | latest FNM (Fast Node Manager) and Node.js  |
| `fzf`           | fzf (fuzzy finder) from github              |
| `lazydocker`    | LazyDocker                                  |
| `lazygit`       | LazyGit                                     |
| `lazyvim`       | LazyVim                                     |
| `neovim`        | Neovim and LazyVim                          |
| `rustdesk`      | RustDesk on Ubuntu Desktop                  |
| `starship`      | starship.rs                                 |
| `zed`           | Zed editor on Linux Desktop                 |

<!--
### 😸 All preferred packages

- [apt packages](assets/txt/apt-packages.txt)
- [brew packages](Brewfile)
- [snap packages](assets/txt/snap-packages.txt)
- [pkg packages](assets/txt/pkg-packages.txt)
-->

## 🐳 Docker

You can build and enter a container with the following commands.

```bash
docker build -t dotfiles-img .
docker run -it -d --name dotfiles-con dotfiles-img
docker exec -it dotfiles-con /bin/zsh
```

In container, install apt packages

```bash
cd dotfiles
./install all apt
```

or install Homebrew with following command.

```bash
cd dotfiles
./install all brew
```

## ⌨️ Keymaps

### Zsh

Based on Emacs mode with `bindkey -e`, with some additional key bindings added.

| Key                                         | Action                        |
| ------------------------------------------- | ----------------------------- |
| <kbd>Ctrl</kbd>+(<kbd>↑</kbd>/<kbd>↓</kbd>) | Undo / Redo                   |
| <kbd>Ctrl</kbd>+(<kbd>←</kbd>/<kbd>→</kbd>) | Backward-word / Forward-word  |

### Tmux

#### prefix key

The tmux prefix key is configured to `Ctrl + \` for easier access.

| Key                             | Description                   |
| ------------------------------- | ------------------------------|
| <kbd>I</kbd>                    | Install tmux plugins with tpm |
| <kbd>U</kbd>                    | Update tmux plugins with tpm  |
| <kbd>Ctrl</kbd>+<kbd>s</kbd>    | Save tmux env                 |
| <kbd>Ctrl</kbd>+<kbd>r</kbd>    | Restore tmux env              |
| <kbd>d</kbd>                    | Detach the tmux session       |
| <kbd>e</kbd>                    | Switch pane-synchronize mode  |

##### tmux plugins

The tmux plugins installed by default are as follows:

- tpm
- tmux-continuum
- tmux-logging
- tmux-resurrect
- tmux-fingers

#### alt key shortcut

| Key                                        | Description                           | Prefix key +                                        |
| ------------------------------------------ | ------------------------------------- | --------------------------------------------------- |
| <kbd>Alt</kbd>+(<kbd>↑</kbd>/<kbd>↓</kbd>) | Create/delete the window              | <kbd>c</kbd>/<kbd>&</kbd>                           |
| <kbd>Alt</kbd>+(<kbd>←</kbd>/<kbd>→</kbd>) | Switch to the previous/next window    | <kbd>p</kbd>/<kbd>n</kbd>                           |
| <kbd>Alt</kbd>+<kbd>[0-9]</kbd>            | Switch to the 1-10 window             | <kbd>[0-9]</kbd>                                    |
| <kbd>Alt</kbd>+<kbd>-</kbd>                | Split the window horizontally         | <kbd>-</kbd>                                        |
| <kbd>Alt</kbd>+<kbd>\\</kbd>               | Split the window vertically           | <kbd>\\</kbd>                                       |
| <kbd>Alt</kbd>+<kbd>[hjkl]</kbd>           | Switch to the left/down/up/right pane | <kbd>←</kbd>/<kbd>↓</kbd>/<kbd>↑</kbd>/<kbd>→</kbd> |

#### alt+shift key shortcut

| Key                                                         | Description                         | Prefix key +                |
| ----------------------------------------------------------- | ----------------------------------- | --------------------------- |
| <kbd>Alt</kbd>+<kbd>Shift</kbd>+(<kbd>↑</kbd>/<kbd>↓</kbd>) | Create/delete a session             |                             |
| <kbd>Alt</kbd>+<kbd>Shift</kbd>+(<kbd>←</kbd>/<kbd>→</kbd>) | Switch to the previous/next session | <kbd>(</kbd>/<kbd>)</kbd>   |

### Neovim

Based on [LazyVim keymaps](https://www.lazyvim.org/keymaps), with some additional key bindings added.

| Mode  | Key                                         | Description                                                             |
| ----- | ------------------------------------------- | ----------------------------------------------------------------------- |
| n,v   | <kbd>Ctrl</kbd>+(<kbd>↑</kbd>/<kbd>↓</kbd>) | Move to (the end of the previous / the beginning of the next) paragraph |
| n,v,i | <kbd>Ctrl</kbd>+(<kbd>←</kbd>/<kbd>→</kbd>) | Backward word / Forward word                                            |
| i     | <kbd>Ctrl</kbd>+<kbd>/</kbd>                | Undo                                                                    |
| i     | <kbd>Ctrl</kbd>+<kbd>r</kbd>                | Redo                                                                    |

[Emacs-like shortcuts](docs/neovim.md#emacs-like) are configured in insert mode.

- <kbd>Ctrl</kbd>+<kbd>[abdefnpuwy]</kbd>
- <kbd>Alt</kbd>+<kbd>[bdf]</kbd>

## 📜 License

This project is licensed under the [MIT License](LICENSE.md).
