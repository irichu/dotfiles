<img src="https://github.com/user-attachments/assets/44037309-be0e-4cba-88a5-730dcac8cbda" alt="Dotfiles" height="32">

# Dotfiles for Linux and Termux

<!-- Badges -->
<p>
  <!-- CODE SIZE -->
  <img src="https://img.shields.io/github/languages/code-size/irichu/dotfiles?style=for-the-badge&logo=github&color=%2377aaff" alt="GitHub code size in bytes" height="22">
  <!-- REPO SIZE -->
  <img src="https://img.shields.io/github/repo-size/irichu/dotfiles?style=for-the-badge&logo=github&color=%2377aaff" alt="GitHub repo size" height="22">
  <!-- Tokei LOC -->
  <a href="https://github.com/irichu/dotfiles">
    <img src="https://tokei.rs/b1/github/irichu/dotfiles?category=lines&style=for-the-badge&logo=https://simpleicons.org/icons/github.svg&color=%2377aaff"
        alt="Tokei total line"
        height="22">
  </a>
</p>

<p>
  <!-- LICENSE -->
  <img src="https://img.shields.io/github/license/irichu/dotfiles?style=for-the-badge&logo=github&color=%2355ff99" alt="GitHub License" height="22">
  <!-- CREATED AT -->
  <img src="https://img.shields.io/github/created-at/irichu/dotfiles?style=for-the-badge&logo=github&color=%2355ff99" alt="GitHub Created At" height="22"> 
  <!-- LAST COMMIT -->
  <img src="https://img.shields.io/github/last-commit/irichu/dotfiles?style=for-the-badge&logo=github&color=%2355ff99" alt="GitHub last commit" height="22">
  <!-- STARS -->
  <img src="https://img.shields.io/github/stars/irichu/dotfiles?style=for-the-badge&logo=github&color=%23ffdd33" alt="GitHub Repo stars" height="22">
</p>

[English] [[日本語]]

## 🎉 Welcome

Welcome to my dotfiles. This repository helps easily set up a fast and intuitive terminal environment. This setup installs Zsh with starship prompt, tmux, Neovim, and Golang and Rust-based command-line tools that starts and operates quickly. I would be delighted if even a single element leads to a new discovery for you. Grateful that you found this project and took a look!

### Linux

<img src="https://github.com/user-attachments/assets/29e13d2f-a04b-428e-9126-e02b5c5c5911" width="800">

### Android Termux

<img src="https://github.com/user-attachments/assets/4f64bb0f-6e57-4fd7-8318-8d92da2b109a" width="320">

### WSL2

<img src="https://github.com/user-attachments/assets/3c3860f3-f184-4a50-8c5d-15aaa8079800" width="800" alt="wsl_zsh_nvim_startuptime">

## 🚀 Installation

**1. Download and Install dotfiles**

Use the following `git`, `curl`, or `wget` command:

- git (>=2.35.0 recommended)

```bash
git clone https://github.com/irichu/dotfiles.git && cd dotfiles && ./install.sh
```

- curl

```bash
curl -sL https://raw.githubusercontent.com/irichu/dotfiles/main/install.sh | bash
```

- wget

```bash
wget -qO- https://raw.githubusercontent.com/irichu/dotfiles/main/install.sh | bash
```

**2. Bulk installation**

> [!IMPORTANT]  
> On Linux (Ubuntu/Fedora/Arch Linux), automatic setup is available using `brew`.  
> On Ubuntu, fast installation is possible with `apt` or `snap`.  
> On Termux, setup can be done using `pkg`.
> 

> [!NOTE]  
> On Linux, `sudo` access is required for installation.  
> This is needed to install Homebrew itself with `brew` and to install packages using `apt`, `snap`.
> 

Install all components using your preferred package manager:  
`dots all [apt|brew|snap|pkg]`  
Replace `[apt|brew|snap|pkg]` with your package manager of choice.

**Examples:**

- To use brew on Linux:

```bash
dots all brew
```

- To use pkg on Termux:

```bash
dots all pkg
```

> [!NOTE]  
> If `dots` command not found,  
> please run the following command to add the path to ~/.local/bin.
> 

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**3. Start**

Relogin or execute the following command:

```bash
exec -l $(which zsh)
```

> [!NOTE] 
> In a login shell, such as an SSH session, Tmux will start automatically.<br>
> If a Tmux server is already running, you can select a session to connect to.
>

## ✅ Supported OS

- Linux 🐧
  - Ubuntu 22.04 and newer (recommended)
  - Arch Linux
  - Fedora
- Android 📱
  - The latest version of Termux

> [!WARNING] 
> The Google Play Store version of Termux may not work properly with some commands.<br>
> It is recommended to install it from [F-Droid].
>

## ✨ Features

- **Shell**: Zsh with the [starship] prompt
- **Editor**: [Neovim] configured via [LazyVim]
- **Terminal Multiplexers**: [tmux] for session management, [zellij] for workspace management
- **TUI File Managers**: [broot] for efficient navigation, [yazi] for rapid file access
- **Terminal Emulator**: [Alacritty] for performance, [Termux] for Android environments

## 📗 Basic commands

Show help and available commands:

```bash
dots --help
```

Copy $XDG_CONFIG_HOME to $XDG_DATA_HOME/dotfiles-main/backup dir:

```bash
dots backup
```

Show install target package list:

```bash
dots list [apt|brew|snap|pkg]
```

Install individual package:

```bash
dots <package_name>
```

|                                                     Help image                                                     |
| :----------------------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/2be34e8d-4dfa-4c3e-9a85-6d3c9cfd6053" width="800" alt="help"> |

### 🖥️ Install individual package

The following apps can be installed individually from the `dots <package_name>` command

#### >_ CLI/TUI Apps

| Package Name | Description                                |
| ------------ | ------------------------------------------ |
| `docker`     | docker-ce (additional repository)          |
| `fnm`        | latest FNM (Fast Node Manager) and Node.js |
| `fzf`        | fzf (fuzzy finder) from github             |
| `lazydocker` | LazyDocker                                 |
| `lazygit`    | LazyGit                                    |
| `lazyvim`    | LazyVim                                    |
| `neovim`     | Neovim and LazyVim                         |
| `starship`   | starship.rs                                |

#### 🖥️ GUI Apps

| Package Name | Description                 |
| ------------ | --------------------------- |
| `rustdesk`   | RustDesk on Ubuntu Desktop  |
| `zed`        | Zed editor on Linux Desktop |

#### 🪴 Others

| Package Name | Description              |
| ------------ | ------------------------ |
| `hackgen`    | HackGen font (Nerd Font) |

### 🍺 Brew Apps

The `dots all brew` command mainly installs the following apps

| Package Name              | Description                                               |
| ------------------------- | --------------------------------------------------------- |
| `bat`                     | cat replacement                                           |
| `bottom`                  | TUI system resource monitor                               |
| `broot`                   | Interactive directory navigation tool                     |
| `cloc`                    | Count lines of code in a project                          |
| `duf`                     | df replacement with better visualization                  |
| `dust`                    | du replacement with intuitive output                      |
| `eza`                     | ls replacement with modern features                       |
| `fastfetch`               | Fast system information fetcher                           |
| `fd`                      | find replacement with simpler syntax                      |
| `fnm`                     | Fast Node Manager for managing Node.js versions           |
| `fzf`                     | Fuzzy finder for the command line                         |
| `gh`                      | GitHub CLI tool for interacting with GitHub               |
| `git-delta`               | Syntax-highlighting pager for git and diff output         |
| `gping`                   | Graphical ping tool with live visualization               |
| `jq`                      | Command-line JSON processor                               |
| `just`                    | Handy command runner similar to Make                      |
| `lazygit`                 | Simple TUI for Git repositories                           |
| `ripgrep`                 | grep replacement with blazing fast search                 |
| `ruff`                    | Fast Python linter and formatter                          |
| `sd`                      | Simplified and faster replacement for sed                 |
| `starship`                | Minimal and customizable shell prompt                     |
| `tmux`                    | Terminal multiplexer for managing multiple panes          |
| `tokei`                   | Code statistics tool for counting lines and files         |
| `typst`                   | Modern markup-based typesetting system                    |
| `uv`                      | Python version manager with seamless virtual environments |
| `yazi`                    | TUI file manager inspired by ranger                       |
| `zellij`                  | Rust-based terminal multiplexer with workspace support    |
| `zoxide`                  | cd replacement with smart directory jumping               |
| `zsh`                     | Powerful and customizable shell                           |
| `zsh-autosuggestions`     | Fish-like command suggestions for zsh                     |
| `zsh-completions`         | Additional completions for zsh commands                   |
| `zsh-syntax-highlighting` | Syntax highlighting for zsh command line                  |


### 📓 Target apps

If you want to check all applications per package manager, please refer:

- [apt packages]
- [brew packages]
- [snap packages]
- [pkg packages]

## 🐳 Docker

You can build and enter a container with the following commands.

```bash
cd ~/.local/share/dotfiles-main

docker build -t dotfiles-img .
docker run -it -d --name dotfiles-con dotfiles-img
docker exec -it dotfiles-con /bin/zsh
```

In container, install apt packages

```bash
dots all apt
```

or install Homebrew with following command.

```bash
dots all brew
```

## 🖼️ Gallery

### Neovim

|                                          LazyVim tokyonight.nvim style=night                                          |
| :-------------------------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/53567c2d-8bf2-4f4b-81d8-c6f126895606" width="800" alt="LazyVim"> |

### Tmux

|                                                        Tmux split window                                                        |
| :-----------------------------------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/2be4ac55-e412-4fa4-a8c8-ec517c70dec0" width="800" alt="Tmux split window"> |

|                                                        Tmux synchronize-panes mode                                                        |
| :---------------------------------------------------------------------------------------------------------------------------------------: |
|                     <span style="font-size:12px">alias tid='tmux display -pt "${TMUX_PANE:?}" "#{pane_index}"'</span>                     |
| <img src="https://github.com/user-attachments/assets/7effb2bf-b3c8-47bb-91e9-e80e73090d3a" width="800" alt="Tmux synchronize-panes mode"> |

## ⚡ Aliases for quick start

### Tmux

#### Create a session

Quickly start a new tmux session.

```bash
t # tmux new
```

#### Attach the last session

Reconnect to the most recent tmux session.

```bash
ta # tmux attach
```

#### Show all sessions

List all tmux sessions that are currently running.

```bash
tls # tmux ls
```

#### Terminate tmux server

Kill the entire tmux server and all running sessions.

```bash
tks # tmux kill-server
```

#### Reload tmux config

Reload .tmux.conf

```bash
.t # source ~/.config/tmux/.tmux.conf
```

### Neovim

#### Search and Open 

Search and open files by fd and fzf.

```bash
v # fd --type f --hidden --exclude .git | fzf-tmux -p | xargs -o nvim
```

## ⌨️ Keymaps

### Zsh

Based on Emacs mode with `bindkey -e`, with some additional key bindings added.

| Key                                         | Action                       |
| ------------------------------------------- | ---------------------------- |
| <kbd>Ctrl</kbd>+(<kbd>↑</kbd>/<kbd>↓</kbd>) | Undo / Redo                  |
| <kbd>Ctrl</kbd>+(<kbd>←</kbd>/<kbd>→</kbd>) | Backward-word / Forward-word |

### Tmux

#### prefix key

> [!NOTE]  
> The tmux prefix key is configured to `Ctrl + \` for easier access.
> 

| Key                          | Description                   |
| ---------------------------- | ----------------------------- |
| <kbd>I</kbd>                 | Install tmux plugins with tpm |
| <kbd>U</kbd>                 | Update tmux plugins with tpm  |
| <kbd>Ctrl</kbd>+<kbd>s</kbd> | Save tmux env                 |
| <kbd>Ctrl</kbd>+<kbd>r</kbd> | Restore tmux env              |
| <kbd>d</kbd>                 | Detach the tmux session       |
| <kbd>e</kbd>                 | Switch pane-synchronize mode  |

> [!TIP]
> In nested Tmux sessions, pressing the prefix key (`Ctrl-\`) multiple times
> will send it to the innermost session.
> The number of times you need to press it equals the depth of nesting.
>
> For example, if you are running Tmux inside another Tmux session (nested once),
> pressing `Ctrl-\` twice will send the prefix key to the inner session. 
> If you are three levels deep, you need to press `Ctrl-\` three times.
> Additionally, pressing `Ctrl-\` sends the key input to the shell within the session.
> 

##### tmux plugins

The tmux plugins installed by default are as follows:

- [tpm]
- [tmux-continuum]
- [tmux-logging]
- [tmux-resurrect]
- [tmux-fingers]

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

| Key                                                         | Description                         | Prefix key +              |
| ----------------------------------------------------------- | ----------------------------------- | ------------------------- |
| <kbd>Alt</kbd>+<kbd>Shift</kbd>+(<kbd>↑</kbd>/<kbd>↓</kbd>) | Create/delete a session             |                           |
| <kbd>Alt</kbd>+<kbd>Shift</kbd>+(<kbd>←</kbd>/<kbd>→</kbd>) | Switch to the previous/next session | <kbd>(</kbd>/<kbd>)</kbd> |

### Neovim

Based on [LazyVim keymaps], with some additional key bindings added.

| Mode  | Key                                         | Description                                                             |
| :---: | ------------------------------------------- | ----------------------------------------------------------------------- |
|  n,v  | <kbd>Ctrl</kbd>+(<kbd>↑</kbd>/<kbd>↓</kbd>) | Move to (the end of the previous / the beginning of the next) paragraph |
| n,v,i | <kbd>Ctrl</kbd>+(<kbd>←</kbd>/<kbd>→</kbd>) | Backward word / Forward word                                            |
|   i   | <kbd>Ctrl</kbd>+<kbd>/</kbd>                | Undo                                                                    |
|   i   | <kbd>Ctrl</kbd>+<kbd>r</kbd>                | Redo                                                                    |

[Emacs-like shortcuts] are configured in insert mode.

- <kbd>Ctrl</kbd>+<kbd>[abdefnpuwy]</kbd>
- <kbd>Alt</kbd>+<kbd>[bdf]</kbd>

## 📜 License

This project is licensed under the [MIT License].

<!-- Reference-style links -->
[日本語]: docs/README-ja.md
[F-Droid]: https://f-droid.org/
[starship]: https://starship.rs/
[Neovim]: https://github.com/neovim/neovim
[LazyVim]: https://www.lazyvim.org/
[tmux]: https://github.com/tmux/tmux
[zellij]: https://github.com/zellij-org/zellij
[broot]: https://github.com/Canop/broot
[yazi]: https://github.com/sxyazi/yazi
[Alacritty]: https://github.com/alacritty/alacritty
[Termux]: https://github.com/termux/termux-app
[apt packages]: assets/txt/apt-packages.txt
[brew packages]: Brewfile
[snap packages]: assets/txt/snap-packages.txt
[pkg packages]: assets/txt/pkg-packages.txt
[tpm]: https://github.com/tmux-plugins/tpm
[tmux-continuum]: https://github.com/tmux-plugins/tmux-continuum
[tmux-logging]: https://github.com/tmux-plugins/tmux-logging
[tmux-resurrect]: https://github.com/tmux-plugins/tmux-resurrect
[tmux-fingers]: https://github.com/Morantron/tmux-fingers
[LazyVim keymaps]: https://www.lazyvim.org/keymaps
[Emacs-like shortcuts]: docs/neovim.md#emacs-like
[MIT License]: LICENSE.md
