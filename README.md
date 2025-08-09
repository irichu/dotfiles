<!-- Languages -->
English / [Japanese(日本語)]

<!-- Logo -->
<p align="center">
  <a href="https://github.com/irichu/dotfiles">
    <img
      src="https://github.com/user-attachments/assets/44037309-be0e-4cba-88a5-730dcac8cbda"
      alt="Dotfiles logo image"
      height="40"
    >
  </a>
</p>

<!-- Badges -->
<div align="center">
  <p style="width: 80%">
    <!-- CODE SIZE -->
    <img
      src="https://img.shields.io/github/languages/code-size/irichu/dotfiles?style=for-the-badge&logo=github&color=%2377aaff"
      alt="GitHub code size in bytes"
      height="22"
    >
    <!-- Tokei LOC -->
    <a href="https://github.com/irichu/dotfiles">
      <img
        src="https://tokei.rs/b1/github/irichu/dotfiles?category=lines&style=for-the-badge&logo=https://simpleicons.org/icons/github.svg&color=%2377aaff"
        alt="Tokei total line"
        height="22"
      >
    </a>
    <!-- CREATED AT -->
    <img
      src="https://img.shields.io/github/created-at/irichu/dotfiles?style=for-the-badge&logo=github&color=%239988FF"
      alt="GitHub Created At"
      height="22"
    >
    <!-- LAST COMMIT -->
    <img
      src="https://img.shields.io/github/last-commit/irichu/dotfiles?style=for-the-badge&logo=github&color=%239988FF"
      alt="GitHub last commit"
      height="22"
    >
    <!-- LICENSE -->
    <img
      src="https://img.shields.io/github/license/irichu/dotfiles?style=for-the-badge&logo=github&color=%2355ff99"
      alt="GitHub License"
      height="22"
    >
    <!-- RELEASE VERSION -->
    <img
      src="https://img.shields.io/github/v/release/irichu/dotfiles?category=lines&style=for-the-badge&logo=github&color=%2355ff99"
      alt="GitHub Release"
      height="22"
    >
    <!-- STARS -->
    <img
      src="https://img.shields.io/github/stars/irichu/dotfiles?style=for-the-badge&logo=github&color=%23ffdd33"
      alt="GitHub Repo stars"
      height="22"
    >
  </p>
</div>

# Dotfiles for Linux and Termux

## 🎉 Welcome

Welcome to my dotfiles. [This GitHub repository] helps easily set up a fast and intuitive desktop and terminal environment. This setup installs Zsh with starship prompt, tmux, Neovim, and Golang and Rust-based command-line tools that starts and operates quickly. I would be delighted if even a single element leads to a new discovery for you. Grateful that you found this project and took a look!

<img
  src="https://irichu.github.io/dotfiles/assets/images/irichu-dotfiles-ubuntu-desktop-terminal.png"
  width="800"
  alt="irichu dotfiles ubuntu desktop terminal">

<img
  src="https://irichu.github.io/dotfiles/assets/images/irichu-dotfiles-ubuntu-desktop-guiapps.png"
  width="800"
  alt="irichu dotfiles ubuntu desktop vscode nautilus">

## 🚀 Installation

**1. Download and Install dotfiles**

Use the following `curl`, `wget`, or `git` command:

<details open="">
<summary>curl</summary>

<pre>
<code class="language-bash">curl -sL https://raw.githubusercontent.com/irichu/dotfiles/main/install.sh | bash</code>
</pre>

</details>

<details open="">
<summary>wget</summary>

<pre>
<code class="language-bash">wget -qO- https://raw.githubusercontent.com/irichu/dotfiles/main/install.sh | bash</code>
</pre>

</details>

<details>
<summary>git (>=2.35.0 recommended)</summary>

<pre>
<code class="language-bash">git clone --depth=1 https://github.com/irichu/dotfiles.git && cd dotfiles && ./install.sh</code>
</pre>

</details>
<br>

**2. Automatic package installation**

> [!IMPORTANT]
> On Ubuntu Desktop, automatic setup is possible `--ubuntu-desktop`.<br>
> On Ubuntu, fast installation is possible with `--apt` or `--snap`.<br>
> On Linux (Ubuntu/Fedora/Arch Linux) or macOS, automatic setup is available using `--brew`.<br>
> On Termux, setup can be done using `--pkg`.
>

> [!NOTE]
> On Linux or macOS, `sudo` access is required for installation.<br>
> This is needed to install Homebrew itself with `--brew` and to install packages using `--apt`, `--snap`.<br>
>

Install all components using your preferred package manager:
`dots install [--apt|--brew|--snap|--pkg]`
<!--
Replace `[--apt|--brew|--snap|--pkg]` with your package manager of choice.
-->

**Examples:**

- To install on Ubuntu Desktop (New):

```bash
dots install --ubuntu-desktop
```

- To use brew on Linux or macOS:

```bash
dots install --brew
```

- To use pkg on Termux:

```bash
dots install --pkg
```

> [!NOTE]
> If `dots` command not found,<br>
> please run the following command to add the path to ~/.local/bin<br>
> or use `~/.local/bin/dots` command directly during the installation process
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
- Mac 🍎
  - macOS
- Android 📱
  - The latest version of Termux

> [!WARNING]
> The Google Play Store version of Termux may not work properly with some commands.<br>
> It is recommended to install it from [F-Droid].
>

<img
  src="https://irichu.github.io/dotfiles/assets/images/irichu-dotfiles-main-screenshot.png"
  width="800"
  alt="irichu dotfiles main screenshot">

<!--
> [!Note]
> Some behavior may vary slightly between platforms due to system differences.<br>
>
-->

## ✨ Features

- Desktop
  - Themes
    - Icons: [Flat-Remix-Blue-Dark]
    - Shell: [Marble-blue-dark]
    - GTK: [Flat-Remix-GTK-Blue-Dark-Solid]
  - Gnome Extensions
    - Blur my Shell
    - Just Perfection
    - Space Bar
    - Tactile
    - etc.
- Terminal
  - Shell: Zsh with the [starship] prompt
  - Editor: [Neovim] configured via [LazyVim]
  - Terminal Multiplexers: [tmux] for session management, [zellij] for workspace management
  - TUI File Managers: [broot] for efficient navigation, [yazi] for rapid file access
  - Terminal Emulator: [Alacritty] for performance, [Termux] for Android environments
  - Packages
    - 🐧 [Linux packages]
    - 🍺 [Brew Apps]

<!--
  - **Gnome Extensions**: [Blur my Shell], [Just Perfection], [Space Bar], [Tactile], etc.
  - **Editor**: [VSCode] (Shortcut: Ctrl+Super+Alt+V), preconfigured with ~50 awesome extensions
  - **Clipboard Manager**: [CopyQ] (Shortcut: Ctrl+Shift+V)
  - **Screenshot Tool**: [Flameshot] (Shortcut: Ctrl+Super+Alt+F)
  - **Remote Desktop**: [RustDesk] for simple and secure remote access
  - **Image Editor**: [GIMP] for advanced image manipulation
-->

## 🐳 Docker

You can build and enter a container with the following commands.

```bash
cd ~/.local/share/dotfiles-main
```

docker compose command:

```bash
docker compose up -d --build
docker compose exec dotfiles zsh
```

<details>
<summary>docker command</summary>

<pre>
<code class="language-bash">docker build -t dotfiles-img .
docker run -it -d --name dotfiles-con dotfiles-img
docker exec -it dotfiles-con /bin/zsh
</code>
</pre>

</details>
<br>

In container, install apt packages

```bash
dots install --apt
```

or install Homebrew with following command.

```bash
dots install --brew
```

## 📗 Basic commands

<details open="">
<summary>Get/Set the current tmux theme</summary>

<pre>
<code class="language-bash"># get theme
dots tmux-theme</code>
</pre>

<pre>
<code class="language-bash"># set theme
dots set-tmux-theme

# example
dots set-tmux-theme 4               # Set by number
dots set-tmux-theme developer-mono  # Set by name</code>
</pre>

  Available themes:

  <details open="">
  <summary>Developer (purple base)</summary>

  1. developer

  <img src="https://github.com/user-attachments/assets/b11d0239-654c-4bb8-8b00-053052bf6551" alt="tmux status image" style="padding-left:30px;">
  <br>

  2. developer-textcolored

  <img src="https://github.com/user-attachments/assets/eb263ac8-43a4-40b6-9416-d062500ce4db" alt="tmux status image" style="padding-left:30px;">
  <br>

  3. developer-colorful

  <img src="https://github.com/user-attachments/assets/bdf15c2c-fa79-482e-acc4-d5cff417ea26" alt="tmux status image" style="padding-left:30px;">
  <br>

  4. developer-mono

  <img src="https://github.com/user-attachments/assets/ff462435-3c49-4671-9ae7-dd5b58e8ddb6" alt="tmux status image" style="padding-left:30px;">
  <br>

  </details>

  <details>
  <summary>Turquoise</summary>

  5. dark-turquoise

  <img src="https://github.com/user-attachments/assets/04e742ca-9ce8-433b-9b07-19618274d36c" alt="tmux status image" style="padding-left:30px;">
  <br>

  6. dark-turquoise-textcolored

  <img src="https://github.com/user-attachments/assets/56cccb66-fb8f-4ca3-872b-16ec20abc619" alt="tmux status image" style="padding-left:30px;">
  <br>

  7. dark-turquoise-colorful

  <img src="https://github.com/user-attachments/assets/bb5f85de-c149-4ad1-a912-ce62c1b62580" alt="tmux status image" style="padding-left:30px;">
  <br>

  8. dark-turquoise-mono

  <img src="https://github.com/user-attachments/assets/66e21e1b-f1f5-487e-87b0-ad1655e5fd28" alt="tmux status image" style="padding-left:30px;">
  <br>

  </details>

  <details>
  <summary>Orange</summary>

  9. dark-orange

  <img src="https://github.com/user-attachments/assets/e7a84520-94e6-44c9-ab0e-8c1358123e58" alt="tmux status image" style="padding-left:30px;">
  <br>

  10. dark-orange-textcolored

  <img src="https://github.com/user-attachments/assets/f9d520d0-8740-4538-ae4e-7e88d77aa10d" alt="tmux status image" style="padding-left:30px;">
  <br>

  11. dark-orange-colorful

  <img src="https://github.com/user-attachments/assets/5aebc5e0-bef7-451b-9cd0-0f22be945a76" alt="tmux status image" style="padding-left:30px;">
  <br>

  12. dark-orange-mono

  <img src="https://github.com/user-attachments/assets/4bb9b5b7-e5e1-4865-9a5e-f4e2e4fc2da1" alt="tmux status image" style="padding-left:30px;">
  <br>

  </details>

  <details>
  <summary>Skyblue</summary>

  13. dark-skyblue

  <img src="https://github.com/user-attachments/assets/2b97e6ef-9510-40b0-85e0-dd9629db7eac" alt="tmux status image" style="padding-left:30px;">
  <br>

  14. dark-skyblue-textcolored

  <img src="https://github.com/user-attachments/assets/406430fe-ba61-4790-9b8a-0ea752d0fe4b" alt="tmux status image" style="padding-left:30px;">
  <br>

  15. dark-skyblue-colorful

  <img src="https://github.com/user-attachments/assets/5a3dfb75-9f9d-4324-ac70-fcb988e7c313" alt="tmux status image" style="padding-left:30px;">
  <br>

  16. dark-skyblue-mono

  <img src="https://github.com/user-attachments/assets/02e7bf8a-9269-4bfa-bdab-212bea7c9c4a" alt="tmux status image" style="padding-left:30px;">

  </details>

</details>

<br>

<details>
<summary>Get/Set the starship theme</summary>

<pre>
<code class="language-bash"># get current starship theme
dots starship</code>
</pre>

<pre>
<code class="language-bash"># set starship theme
dots set-starship simple   # oneline
dots set-starship default  # multiline</code>
</pre>

</details>

<details>
<summary>Get/Set the terminal window opacity</summary>

<pre>
<code class="language-bash"># get current opacity
dots opacity</code>
</pre>

<pre>
<code class="language-bash"># set opacity
dots set-opacity</code>
</pre>

</details>

<details>
<summary>Show install target package list</summary>

<pre>
<code class="language-bash">dots list [--apt|--brew|--snap|--pkg]</code>
</pre>

</details>

<details>
<summary>Install individual package</summary>

<pre>
<code class="language-bash">dots install {package_name}</code>
</pre>

</details>

- 🐧 [App packages]
- 🍺 [Brew Apps]

<!--
If you want to check all applications per package manager, please refer:

- 🐧 [apt packages]
- 🍎 [brew packages]
- 📓 [snap packages]
- 📱 [pkg packages]
-->

<details>
<summary>Backup a dotfiles directory</summary>

<pre>
<code class="language-bash"># Copy $XDG_CONFIG_HOME to $XDG_DATA_HOME/dotfiles-main/backup dir
dots backup</code>
</pre>

</details>

<details>
<summary>Clean up directories</summary>

<pre>
<code class="language-bash"># remove dotfiles cache
dots clean

# remove cache + dotfiles backup directories
dots clean backup

# remove cache + config directories
dots clean config

# remove cache + backup + config
dots clean all</code>
</pre>

</details>

<details>
<summary>Print dotfiles version</summary>

<pre>
<code class="language-bash">dots --version</code>
</pre>

</details>

<details>
<summary>Show help and available commands</summary>

<pre>
<code class="language-bash">dots --help</code>
</pre>

</details>

|                                                     Help image                                                     |
| :----------------------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/2be34e8d-4dfa-4c3e-9a85-6d3c9cfd6053" width="800" alt="help"> |

## 🖼️ Gallery

<!--
### Linux

<img
  src="https://github.com/user-attachments/assets/29e13d2f-a04b-428e-9126-e02b5c5c5911"
  width="800"
  alt="ubuntu screenshot">
-->

### Android Termux

<img
  src="https://github.com/user-attachments/assets/4f64bb0f-6e57-4fd7-8318-8d92da2b109a"
  width="320"
  alt="Android smartphone screenshot">

<!--<img src="https://github.com/user-attachments/assets/6b8e9f05-5542-430f-9cac-1f38769ed66f" width="320">-->

<img
  src="https://github.com/user-attachments/assets/8b40390a-61b7-4317-a01e-9b6121743327"
  width="800"
  alt="Android tablet screenshot">

### WSL2

<img
  src="https://github.com/user-attachments/assets/3c3860f3-f184-4a50-8c5d-15aaa8079800"
  width="800"
  alt="wsl_zsh_nvim_startuptime">

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
| <img src="https://github.com/user-attachments/assets/7effb2bf-b3c8-47bb-91e9-e80e73090d3a" width="800" alt="Tmux synchronize-panes mode"> |

### eza, lazygit, yazi

|                                                  eza tree (eza -l -T)                                                  |
| :--------------------------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/34c2ae49-3a30-4401-b4c5-0ce308918b54" width="800" alt="eza tree"> |

|                                                        lazygit                                                        |
| :-------------------------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/bdc012f2-f7fb-4405-b18d-01f73a5a90a9" width="800" alt="lazygit"> |

|                                                        yazi                                                        |
| :----------------------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/217ec320-463c-44c2-a4da-464f291eddcf" width="800" alt="yazi"> |

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

#### Show tmux pane id

Show tmux  pane id

```bash
tid # tmux display -pt "${TMUX_PANE:?}" "#{pane_index}"
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
| <kbd>Alt</kbd>+<kbd>[1-9]</kbd>            | Switch to the 1-9 window              | <kbd>[1-9]</kbd>                                    |
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
[Japanese(日本語)]: docs/README-ja.md
[This GitHub repository]: https://github.com/irichu/dotfiles
[F-Droid]: https://f-droid.org/
[Flat-Remix-Blue-Dark]: https://www.opendesktop.org/p/1012430
[Marble-blue-dark]: https://www.gnome-look.org/p/1977647
[Flat-Remix-GTK-Blue-Dark-Solid]: https://www.opendesktop.org/p/1214931
[starship]: <https://starship.rs/>
[Neovim]: <https://github.com/neovim/neovim>
[LazyVim]: <https://www.lazyvim.org/>
[tmux]: <https://github.com/tmux/tmux>
[zellij]: <https://github.com/zellij-org/zellij>
[broot]: <https://github.com/Canop/broot>
[yazi]: <https://github.com/sxyazi/yazi>
[Alacritty]: <https://github.com/alacritty/alacritty>
[Termux]: <https://github.com/termux/termux-app>
[Linux packages]: docs/app-packages.md
[Brew Apps]: docs/brew-packages.md
[tpm]: <https://github.com/tmux-plugins/tpm>
[tmux-continuum]: <https://github.com/tmux-plugins/tmux-continuum>
[tmux-logging]: <https://github.com/tmux-plugins/tmux-logging>
[tmux-resurrect]: <https://github.com/tmux-plugins/tmux-resurrect>
[tmux-fingers]: <https://github.com/Morantron/tmux-fingers>
[LazyVim keymaps]: <https://www.lazyvim.org/keymaps>
[Emacs-like shortcuts]: docs/neovim.md#emacs-like
[MIT License]: LICENSE.md
