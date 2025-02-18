<img src="https://github.com/user-attachments/assets/4d968f66-bec7-4adb-b7a2-e0b95f9c32a3" alt="Dotfiles" height="32">

# Dotfiles for Linux and Termux

<!-- style=for-the-badge height="22" -->
<p>
  <img src="https://img.shields.io/github/languages/code-size/irichu/dotfiles?style=for-the-badge&logo=github&color=%2377aaff" alt="GitHub code size in bytes" height="22">
  <img src="https://img.shields.io/github/repo-size/irichu/dotfiles?style=for-the-badge&logo=github&color=%2377aaff" alt="GitHub repo size" height="22">
  <a href="https://github.com/irichu/dotfiles">
    <img src="https://tokei.rs/b1/github/irichu/dotfiles?category=lines&style=for-the-badge&logo=https://simpleicons.org/icons/github.svg&color=%2377aaff"
        alt="Tokei total line"
        height="22">
  </a>
</p>

<p>
  <img src="https://img.shields.io/github/license/irichu/dotfiles?style=for-the-badge&logo=github&color=%2355ff99" alt="GitHub License" height="22">
  <img src="https://img.shields.io/github/last-commit/irichu/dotfiles?style=for-the-badge&logo=github&color=%2355ff99" alt="GitHub last commit" height="22">
  <img src="https://img.shields.io/github/stars/irichu/dotfiles?style=for-the-badge&logo=github&color=%23ffdd33" alt="GitHub Repo stars" height="22">
</p>
<!-- style=flat-square height="20" -->

[[English](../)] [日本語]

## 😸 ようこそ

わたしの Dotfiles へようこそ．数多くのプロジェクトの中から見つけてくれてありがとうございます！このリポジトリを利用することで，直感的なターミナル環境を簡単に構築できます．高速に起動・動作する Golang と Rust 製のコマンドラインツールを中心に構成しています．


### Linux

<img src="https://github.com/user-attachments/assets/29e13d2f-a04b-428e-9126-e02b5c5c5911" width="800">

### Android Termux

<img src="https://github.com/user-attachments/assets/4f64bb0f-6e57-4fd7-8318-8d92da2b109a" width="320">

### WSL2

<img src="https://github.com/user-attachments/assets/3c3860f3-f184-4a50-8c5d-15aaa8079800" width="800" alt="wsl_zsh_nvim_startuptime">

## 🚀 インストール方法

1. ダウンロードとインストール

git, curl, wget のいずれかでインストールできます

- git (v2.35.0以上推奨)

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

2. パッケージの一括インストール

> [!IMPORTANT] 
> 利用するパッケージマネージャーに応じて以下のコマンドで一括インストールを実施します<br>
> dots all [apt|brew|snap|pkg]<br>
> 具体的には [apt|brew|snap|pkg] の部分を置き換えて実行します
>
>・Linux(Ubuntu/Fedora/Arch Linux)では `dots all brew` コマンドによる自動構築が可能です<br>
>・Ubuntuでは `dots all apt` または `dots all snap` コマンドで高速なインストールが可能です<br>
>・Termuxでは `dots all pkg` によるセットアップが可能です
>

Linux環境にて，brewでセットアップする場合は以下を実行します

```bash
dots all brew
```

Termux にて pkg でセットアップする場合は以下の通りです

```bash
dots all pkg
```

> [!NOTE] 
> `dots`コマンドが見つからない場合は<br>
> 以下のコマンドを実行して ~/.local/bin へのパスを通すようにしてみてください

```
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

3. スタート

以下のコマンドで設定を読み込みます

```bash
exec -l $(which zsh)
```

> [!NOTE] 
> SSH接続のように，ログインシェルの場合はTmuxが自動起動します．<br>
> Tmuxサーバーがすでに起動している場合は，セッション一覧から接続するセッションを選択できます.

## ✅ サポートOS

- Linux 🐧
  - Ubuntu 22.04以降 (推奨)
  - Arch Linux
  - Fedora
- Android 📱
  - 最新版の Termux

> [!WARNING] 
> Google Playストア版のTermuxは一部のコマンドなどが正常に動作しないことがあるようです．<br>
> [F-Droid](https://f-droid.org/)からインストールすることが推奨されています

## ✨ 特徴

- **シェル**: Zsh + starship.rs
- **エディター**: Neovim + LazyVim
- **ターミナルマルチプレクサー**: tmux または zellij
- **TUIファイラー**: broot または yazi
- **ターミナルエミュレーター**: Alacritty, Termux

## 📗 基本コマンド

コマンドのヘルプと使用できるコマンドを表示します

```bash
dots --help
```

$XDG_CONFIG_HOME ディレクトリのバックアップコピーを $XDG_DATA_HOME/dotfiles/backup に作成します

```bash
dots backup
```

パッケージマネージャーごとにインストールする対象のパッケージ一覧を表示します

```bash
dots list [apt|brew|snap|pkg]
```

個別パッケージのインストールを実行します

```bash
dots <package_name>
```

| ヘルプ表示のイメージ |
| :---: |
| <img src="https://github.com/user-attachments/assets/2be34e8d-4dfa-4c3e-9a85-6d3c9cfd6053" width="800" alt="help"> |

### 🖥️ 個別インストール可能なパッケージの例

The following apps can be installed individually from the `dots <package_name>` command

#### >_ CLI/TUI アプリ

| パッケージ名 | 説明                                                                                 |
| ------------ | ------------------------------------------------------------------------------------ |
| `hackgen`    | HackGenフォント(Hack+源柔ゴシックの合成フォント) NerdFont対応版 をインストールします |
| `docker`     | 追加のaptリポジトリからDockerをインストールします                                    |
| `fnm`        | 最新版のFNM(Fast Node Manager)と最新版LTSのNode.jsをインストールします               |
| `fzf`        | fzf(fuzzy finder)をgithubからインストールします                                      |
| `lazydocker` | LazyDockerをインストールします                                                       |
| `lazygit`    | LazyGitをインストールします                                                          |
| `lazyvim`    | LazyVimをインストールします                                                          |
| `neovim`     | NeovimとLazyVimをインストールします                                                  |
| `starship`   | starship.rsをインストールします                                                      |

#### 🖥️ GUI アプリ

| パッケージ名 | 説明                                                                                 |
| ------------ | ------------------------------------------------------------------------------------ |
| `rustdesk`   | Ubuntu Desktop向けにRustDeskをインストールします                                     |
| `zed`        | Zedエディターをインストールします                                                    |

#### 🪴 その他

| パッケージ名 | 説明                                                                                 |
| ------------ | ------------------------------------------------------------------------------------ |
| `hackgen`    | HackGenフォント(Hack+源柔ゴシックの合成フォント) NerdFont対応版 をインストールします |

### 🍺 Brewパッケージ

`dots all brew`コマンドでインストールする主なパッケージは次のとおりです

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


### 😸 インストール対象アプリ

パッケージマネージャごとにインストールするアプリは次のファイルを参照ください

- [apt packages](assets/txt/apt-packages.txt)
- [brew packages](Brewfile)
- [snap packages](assets/txt/snap-packages.txt)
- [pkg packages](assets/txt/pkg-packages.txt)

## 🐳 Docker環境でのお試し

以下のコマンドでコンテナを構築，お試しできます．

```bash
cd ~/.local/share/dotfiles-main

docker build -t dotfiles-img .
docker run -it -d --name dotfiles-con dotfiles-img
docker exec -it dotfiles-con /bin/zsh
```

コンテナでaptでインストールする場合は以下を実行します．

```bash
dots all apt
```

Homebrew をインストールして進める場合は以下のコマンドを実行します.

```bash
dots all brew
```

## ギャラリー

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

## ⚡  エイリアスコマンド

### Zsh

#### .zshrcのリロード

Zshの設定を読み込みます

```bash
.z # source ~/.config/zsh/.zshrc
```

### Tmux

#### セッションの作成

```bash
t # tmux new
```

#### セッションへの再接続

```bash
ta # tmux attach
```

#### セッション一覧の表示

```bash
tls # tmux ls
```

#### Tmuxサーバーの終了

```bash
tks # tmux kill-server
```

#### Tmux設定の再読み込み

.tmux.confを読み込みます

```bash
.t # source ~/.config/tmux/.tmux.conf
```

### Neovim

#### 検索して開く

fd + fzf で検索したファイルを開きます

```bash
v # fd --type f --hidden --exclude .git | fzf-tmux -p | xargs -o nvim
```

## ⌨️ よく使うキーマップ

### Zsh

Emacsモード  `bindkey -e` に加えていくつかのバインドを追加しています．

| キー                                        | 実行される操作                |
| ------------------------------------------- | ----------------------------- |
| <kbd>Ctrl</kbd>+(<kbd>↑</kbd>/<kbd>↓</kbd>) | undo / redo                   |
| <kbd>Ctrl</kbd>+(<kbd>←</kbd>/<kbd>→</kbd>) | backward-word / forward-word  |

### Tmux

#### プレフィックスキー

プレフィックスキーは `Ctrl + \` に設定しています．

| キー                            | 説明                                    |
| ------------------------------- | --------------------------------------- |
| <kbd>I</kbd>                    | tpmでプラグインをインストールします     |
| <kbd>U</kbd>                    | tmuxプラグインのアップデートをします    |
| <kbd>Ctrl</kbd>+<kbd>s</kbd>    | tmux環境を保存します                    |
| <kbd>Ctrl</kbd>+<kbd>r</kbd>    | tmux環境を復元します                    |
| <kbd>d</kbd>                    | tmuxセッションからデタッチします        |
| <kbd>e</kbd>                    | ペインの同期モードON/OFFを切り替えます  |

##### tmux プラグイン

デフォルトでインストールされる tmux プラグインは以下のとおりです．

- tpm
- tmux-continuum
- tmux-logging
- tmux-resurrect
- tmux-fingers

#### Alt キーとの組み合わせによるショートカット

window と pane の操作を可能としています．

| キー                                       | 説明                                          | プレフィックスキーでの操作                          |
| ------------------------------------------ | --------------------------------------------- | --------------------------------------------------- |
| <kbd>Alt</kbd>+(<kbd>↑</kbd>/<kbd>↓</kbd>) | ウィンドウを作成/削除します                   | <kbd>c</kbd>/<kbd>&</kbd>                           |
| <kbd>Alt</kbd>+(<kbd>←</kbd>/<kbd>→</kbd>) | 前・後のウィンドウに切り替えます              | <kbd>p</kbd>/<kbd>n</kbd>                           |
| <kbd>Alt</kbd>+<kbd>[1-9]</kbd>            | 番号1-10のウィンドウに切り替えます            | <kbd>[0-9]</kbd>                                    |
| <kbd>Alt</kbd>+<kbd>-</kbd>                | ウィンドウを水平に分割します                  | <kbd>-</kbd>                                        |
| <kbd>Alt</kbd>+<kbd>\\</kbd>               | ウィンドウを垂直に分割します                  | <kbd>\\</kbd>                                       |
| <kbd>Alt</kbd>+<kbd>[hjkl]</kbd>           | 左/下/上/右のペインにフォーカスを切り替えます | <kbd>←</kbd>/<kbd>↓</kbd>/<kbd>↑</kbd>/<kbd>→</kbd> |

#### Alt + Shift キーとの組み合わせによるショートカット

主に session の操作を可能としています．

| キー                                                        | 説明                             | プレフィックスキーでの操作  |
| ----------------------------------------------------------- | -------------------------------- | --------------------------- |
| <kbd>Alt</kbd>+<kbd>Shift</kbd>+(<kbd>↑</kbd>/<kbd>↓</kbd>) | セッションを作成/削除します      |                             |
| <kbd>Alt</kbd>+<kbd>Shift</kbd>+(<kbd>←</kbd>/<kbd>→</kbd>) | 前・後のセッションに切り替えます | <kbd>(</kbd>/<kbd>)</kbd>   |

### Neovim

[LazyVimのキーマップ](https://www.lazyvim.org/keymaps) をベースに，いくつかのキーバインドを追加しています.

| モード | キー                                        | 説明                                                                    |
| ------ | ------------------------------------------- | ----------------------------------------------------------------------- |
| n,v    | <kbd>Ctrl</kbd>+(<kbd>↑</kbd>/<kbd>↓</kbd>) | 前のパラグラフの終端，後のパラグラフの先頭にカーソルを移動します        |
| n,v,i  | <kbd>Ctrl</kbd>+(<kbd>←</kbd>/<kbd>→</kbd>) | 前の単語/次の単語にカーソルを移動します                                 |
| i      | <kbd>Ctrl</kbd>+<kbd>/</kbd>                | Undo (操作を１回戻します)                                               |
| i      | <kbd>Ctrl</kbd>+<kbd>r</kbd>                | Redo (操作を１回やり直します)                                           |

インサートモードで以下の Emacs ライクなショートカットを設定しています．詳細は[こちら](./neovim.md#emacs-like)を参照ください．

- <kbd>Ctrl</kbd>+<kbd>[abdefnpuwy]</kbd>
- <kbd>Alt</kbd>+<kbd>[bdf]</kbd>

## 📜 ライセンス

このプロジェクトは [MIT License](../LICENSE.md) に基づいてライセンスされています．
