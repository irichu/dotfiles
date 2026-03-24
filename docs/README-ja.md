<!-- Languages -->
[English] / Japanese(日本語)

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
    <!-- REPO SIZE -->
    <img
      src="https://img.shields.io/github/repo-size/irichu/dotfiles?style=for-the-badge&logo=github&color=%2377aaff"
      alt="GitHub repo size"
      height="22"
    >
    <!-- Tokei LOC -->
    <a href="https://github.com/irichu/dotfiles">
      <img
        src="https://www.aschey.tech/tokei/github/irichu/dotfiles?style=for-the-badge&logo=https://simpleicons.org/icons/github.svg&color=%2377aaff"
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
    <!-- COMMIT ACTIVITY -->
    <img
      src="https://img.shields.io/github/commit-activity/m/irichu/dotfiles?style=for-the-badge&logo=github&color=%239988FF"
      alt="GitHub commit activity"
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

# Dotfiles for Linux, macOS, and Termux

## 🎉 ようこそ

わたしの Dotfiles へようこそ．数多くのプロジェクトの中から見つけてくれてありがとうございます！<br>
この[リポジトリ](https://github.com/irichu/dotfiles)を利用することで，直感的なデスクトップとターミナル環境を簡単に構築できます．高速に起動・動作する Go言語 と Rust 製のコマンドラインツールを中心に構成しています．何か一つでも新しい知識や考え方との出会いになれば幸甚です．

<img
  src="https://irichu.github.io/dotfiles/assets/images/irichu-dotfiles-ubuntu2404-desktop-terminal.png"
  width="800"
  alt="irichu dotfiles ubuntu desktop terminal">

<img
  src="https://irichu.github.io/dotfiles/assets/images/irichu-dotfiles-ubuntu-desktop-guiapps.png"
  width="800"
  alt="irichu dotfiles ubuntu desktop vscode nautilus">

このDotfilesリポジトリの内容は、GitHub Pagesでもご覧いただけます。

- <a href="https://github.com/irichu/dotfiles" rel="me">GitHubリポジトリ版</a>

- <a href="https://irichu.github.io/dotfiles/">GitHub Pages版</a>

### Linux

<img
  src="https://irichu.github.io/dotfiles/assets/images/irichu-dotfiles-ubuntu-desktop-terminal.png"
  width="800"
  alt="irichu dotfiles ubuntu desktop terminal">

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

## 🚀 インストール方法

**1. ダウンロードとインストール**

curl, wget, git のいずれかでインストールできます

- curl

```bash
curl -fsSL https://raw.githubusercontent.com/irichu/dotfiles/main/install.sh | bash
```

- wget

```bash
wget -qO- https://raw.githubusercontent.com/irichu/dotfiles/main/install.sh | bash
```

- git (v2.35.0以上推奨)

```bash
git clone --depth=1 https://github.com/irichu/dotfiles.git && cd dotfiles && ./install.sh
```

**2. パッケージの一括インストール**

> [!IMPORTANT]
>・Linux(Ubuntu/Fedora/Arch Linux)またはmacOSでは `--brew` による自動構築が可能です<br>
>・Ubuntuデスクトップでは `--ubuntu-desktop` で自動セットアップが可能です<br>
>・Ubuntuターミナルでは `--apt` または `--snap` で高速なインストールが可能です<br>
>・Termuxでは `--pkg` によるセットアップが可能です
>

> [!NOTE]
> LinuxまたはmacOSでは `sudo` コマンドが使える必要があります<br>
> `--brew`ではHomebrew本体をインストールするために利用します<br>
> `--apt`, `--snap`の場合もパッケージ管理のため使用します
>

利用するパッケージマネージャーに応じて以下のコマンドで一括インストールを実施します<br>
`dots install [--apt|--brew|--snap|--pkg]`<br>
具体的には `[--apt|--brew|--snap|--pkg]` の部分を置き換えて実行します

Ubuntu デスクトップで自動セットアップする場合は以下を実行します:

```bash
dots install --ubuntu-desktop
```

LinuxまたはmacOS環境にて，brewでセットアップする場合は以下を実行します

```bash
dots install --brew
```

Termux にて pkg でセットアップする場合は以下の通りです

```bash
dots install --pkg
```

> [!NOTE]
> `dots`コマンドが見つからない場合は<br>
> 以下のコマンドを実行して ~/.local/bin へのパスを通すようにしてみてください
> もしくは一括インストールが完了するまでは直接 `~/.local/bin/dots` で実行してください
>

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**3. スタート**

以下のコマンドで設定を読み込みます

```bash
exec -l $(which zsh)
```

> [!NOTE]
> SSH接続のように，ログインシェルの場合はTmuxが自動起動します．<br>
> Tmuxサーバーがすでに起動している場合は，セッション一覧から接続するセッションを選択できます.
>

## ✅ サポートOS

- Linux 🐧
  - Ubuntu 22.04以降 (推奨)
    - Ubuntu 22.04 LTS 一部サポート対象
    - Ubuntu 24.04 LTS メイン動作確認対象
    - Ubuntu 26.04 LTS 今後対応予定
  - Arch Linux
  - Fedora
- Mac 🍎
  - macOS
- Android 📱
  - 最新版の Termux

> [!WARNING]
> Google Playストア版のTermuxは一部のコマンドなどが正常に動作しないことがあるようです．<br>
> [F-Droid]からインストールすることが推奨されています
>

<img
  src="https://irichu.github.io/dotfiles/assets/images/irichu-dotfiles-main-screenshot.png"
  width="800"
  alt="irichu dotfiles main screenshot">

<!--
> [!Note]
> OSごとに多少動作が異なることがあります<br>
>
-->

## ✨ 特徴

- **シェル**: Zsh + [starship]
- **エディター**: [Neovim] + [LazyVim]
- **ターミナルマルチプレクサー**: [tmux] または [zellij]
- **TUIファイラー**: [broot] または [yazi]
- **ターミナルエミュレーター**: [Alacritty], [Termux]

## 📗 基本コマンド

コマンドのヘルプと使用できるコマンドを表示します

```bash
dots --help
```

ターミナルウィンドウの背景透過度を取得/設定します

```bash
# get current opacity
dots opacity
```

```bash
# set current opacity
dots set-opacity
```

現在のTmuxカラーテーマを取得します:

```bash
dots tmux-theme
```

指定のカラーテーマに設定します:

```bash
dots set-tmux-theme <NUMBER|NAME>

# Example
dots set-tmux-theme 4                 # Set by number
dots set-tmux-theme "developer-mono"  # Set by name
```

利用可能なテーマ:

**1. developer**

![Image](https://github.com/user-attachments/assets/b11d0239-654c-4bb8-8b00-053052bf6551)

**2. developer-textcolored**

![Image](https://github.com/user-attachments/assets/eb263ac8-43a4-40b6-9416-d062500ce4db)

**3. developer-colorful**

![Image](https://github.com/user-attachments/assets/bdf15c2c-fa79-482e-acc4-d5cff417ea26)

**4. developer-mono**

![Image](https://github.com/user-attachments/assets/ff462435-3c49-4671-9ae7-dd5b58e8ddb6)

**5. dark-turquoise**

![Image](https://github.com/user-attachments/assets/04e742ca-9ce8-433b-9b07-19618274d36c)

**6. dark-turquoise-textcolored**

![Image](https://github.com/user-attachments/assets/56cccb66-fb8f-4ca3-872b-16ec20abc619)

**7. dark-turquoise-colorful**

![Image](https://github.com/user-attachments/assets/bb5f85de-c149-4ad1-a912-ce62c1b62580)

**8. dark-turquoise-mono**

![Image](https://github.com/user-attachments/assets/66e21e1b-f1f5-487e-87b0-ad1655e5fd28)

**9. dark-orange**

![Image](https://github.com/user-attachments/assets/e7a84520-94e6-44c9-ab0e-8c1358123e58)

**10. dark-orange-textcolored**

![Image](https://github.com/user-attachments/assets/f9d520d0-8740-4538-ae4e-7e88d77aa10d)

**11. dark-orange-colorful**

![Image](https://github.com/user-attachments/assets/5aebc5e0-bef7-451b-9cd0-0f22be945a76)

**12. dark-orange-mono**

![Image](https://github.com/user-attachments/assets/4bb9b5b7-e5e1-4865-9a5e-f4e2e4fc2da1)

**13. dark-skyblue**

![Image](https://github.com/user-attachments/assets/2b97e6ef-9510-40b0-85e0-dd9629db7eac)

**14. dark-skyblue-textcolored**

![Image](https://github.com/user-attachments/assets/406430fe-ba61-4790-9b8a-0ea752d0fe4b)

**15. dark-skyblue-colorful**

![Image](https://github.com/user-attachments/assets/5a3dfb75-9f9d-4324-ac70-fcb988e7c313)

**16. dark-skyblue-mono**

![Image](https://github.com/user-attachments/assets/02e7bf8a-9269-4bfa-bdab-212bea7c9c4a)

現在の starship テーマを表示します:

```bash
dots starship
```

指定した starship テーマを設定します:

```bash
dots set-starship simple   # oneline
dots set-starship default  # multiline
```

バックアップを作成します:

```bash
# $XDG_CONFIG_HOME ディレクトリのバックアップコピーを $XDG_DATA_HOME/dotfiles/backup に作成します
dots backup
```

データを整理(削除)します:

```bash
# remove dotfiles cache
dots clean

# remove cache + dotfiles backup directories
dots clean backup

# remove cache + config directories
dots clean config

# remove cache + backup + config
dots clean all
```

パッケージマネージャーごとにインストールする対象のパッケージ一覧を表示します

```bash
dots list [--apt|--brew|--snap|--pkg]
```

個別パッケージのインストールを実行します

```bash
dots install <package_name>
```

|                                                ヘルプ表示のイメージ                                                |
| :----------------------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/user-attachments/assets/2be34e8d-4dfa-4c3e-9a85-6d3c9cfd6053" width="800" alt="help"> |

### 🖥️ 個別インストール可能なパッケージの例

The following apps can be installed individually from the `dots install <package_name>` command

#### >_ CLI/TUI アプリ

| パッケージ名 | 説明                                                                   |
| ------------ | ---------------------------------------------------------------------- |
| `docker`     | 追加のaptリポジトリからDockerをインストールします                      |
| `fnm`        | 最新版のFNM(Fast Node Manager)と最新版LTSのNode.jsをインストールします |
| `fzf`        | fzf(fuzzy finder)をgithubからインストールします                        |
| `lazydocker` | LazyDockerをインストールします                                         |
| `lazygit`    | LazyGitをインストールします                                            |
| `lazyvim`    | LazyVimをインストールします                                            |
| `neovim`     | NeovimとLazyVimをインストールします                                    |
| `starship`   | starship.rsをインストールします                                        |

#### 🖥️ GUI アプリ

| パッケージ名 | 説明                                               |
| ------------ | -------------------------------------------------- |
| `chrome`     | [Google Chrome]をインストールします                |
| `code`       | [Visual Studio Code]と拡張機能をインストールします |
| `copyq`      | [CopyQ]をインストールします                        |
| `localsend`  | [LocalSend]をインストールします                    |
| `obsidian`   | [Obsidian]をインストールします                     |
| `rustdesk`   | [RustDesk]をインストールします                     |
| `signal`     | [Signal Desktop]をインストールします               |
| `waydroid`   | [Waydroid]をインストールします                     |
| `zed`        | [Zed]エディターをインストールします                |

#### 🪴 その他

| パッケージ名 | 説明                                                                                       |
| ------------ | ------------------------------------------------------------------------------------------ |
| `hackgen`    | [HackGen]フォント(Hack+源柔ゴシックの合成フォント) [Nerd Fonts]対応版 をインストールします |
| `mplus2`     | [M PLUS 2]フォント([Google Fonts])をインストールします                                     |
| `mozc`       | [Mozc] - 日本語入力(IME)をインストールします                                               |

### 🍺 Brewパッケージ

`dots install --brew`コマンドでインストールする主なパッケージは次のとおりです

#### macOS cask

| パッケージ名         | 説明                                                         |
| -------------------- | ------------------------------------------------------------ |
| `alacritty`          | 高速でGPU対応のターミナルエミュレータ。                      |
| `clipy`              | 履歴機能付きのmacOS用クリップボードマネージャ。              |
| `docker`             | コンテナの開発・配布・実行を行うためのプラットフォーム。     |
| `flameshot`          | 高機能で使いやすいスクリーンショットツール。                 |
| `ghostty`            | macOS向けのミニマルでGPUベースのターミナルエミュレータ。     |
| `rectangle`          | キーボード操作でウィンドウを整理できるウィンドウ管理アプリ。 |
| `visual-studio-code` | 軽量で高機能なソースコードエディタ。                         |

#### 共通(Linux/macOS)

| パッケージ名              | 説明                                                           |
| ------------------------- | -------------------------------------------------------------- |
| `bat`                     | `cat` の代替ツール                                             |
| `bottom`                  | TUI のシステムリソースモニター                                 |
| `broot`                   | 対話型のディレクトリナビゲーションツール                       |
| `cloc`                    | プロジェクト内のコード行数をカウント                           |
| `duf`                     | `df` の代替ツール（視覚的に見やすい）                          |
| `dust`                    | `du` の代替ツール（直感的な出力）                              |
| `eza`                     | `ls` の代替ツール（モダンな機能付き）                          |
| `fastfetch`               | 高速なシステム情報取得ツール                                   |
| `fd`                      | `find` の代替ツール（シンプルな構文）                          |
| `fnm`                     | Node.js のバージョン管理ができる高速 Node マネージャー         |
| `fzf`                     | コマンドライン用のファジーファインダー                         |
| `gh`                      | GitHub の操作ができる CLI ツール                               |
| `git-delta`               | Git や diff の出力をシンタックスハイライト付きで表示           |
| `gping`                   | グラフィカルな ping ツール（リアルタイム可視化）               |
| `gum`                     | インタラクティブな UI を可能とするシェルスクリプト拡張         |
| `jj`                      | Git 互換のモダンなバージョン管理システム                       |
| `jq`                      | コマンドライン用の JSON プロセッサ                             |
| `just`                    | `Make` に似た便利なコマンドランナー                            |
| `lazygit`                 | シンプルな TUI の Git クライアント                             |
| `ripgrep`                 | `grep` の代替ツール（超高速検索）                              |
| `ruff`                    | 高速な Python 用リンター＆フォーマッター                       |
| `sd`                      | シンプルで高速なsedの代替ツール                                |
| `starship`                | 最小限でカスタマイズ可能なシェルプロンプト                     |
| `tldr`                    | コマンドラインツールのシンプルなヘルプ表示                     |
| `tmux`                    | 複数のペインを管理できるターミナルマルチプレクサ               |
| `tokei`                   | コード統計ツール（ファイルや行数をカウント）                   |
| `typst`                   | モダンなマークアップベースの組版システム                       |
| `uv`                      | 仮想環境をシームレスに管理できる Python バージョンマネージャー |
| `yazi`                    | `ranger` にインスパイアされた TUI ファイルマネージャー         |
| `zellij`                  | ワークスペース機能を備えた Rust 製ターミナルマルチプレクサ     |
| `zoxide`                  | `cd` の代替ツール（スマートなディレクトリ移動）                |
| `zsh`                     | 高機能でカスタマイズ性の高いシェル                             |
| `zsh-autosuggestions`     | `fish` のようなコマンド補完機能（`zsh` 用）                    |
| `zsh-completions`         | `zsh` コマンドの補完機能を追加                                 |
| `zsh-syntax-highlighting` | `zsh` のコマンドライン用シンタックスハイライト                 |

### 📓 インストール対象アプリ

パッケージマネージャごとにインストールするアプリは次のファイルを参照ください

- [apt packages]
- [brew packages]
- [snap packages]
- [pkg packages]

## 🐳 Docker環境でのお試し

以下のコマンドでコンテナを構築，お試しできます．

```bash
cd ~/.local/share/dotfiles-main
```

`docker compose` で実行します．

```bash
docker compose up -d --build
docker compose exec dotfiles zsh
```

もしくは `docker` コマンドで作成・実行します．

```bash
docker build -t dotfiles-img .
docker run -it -d --name dotfiles-con dotfiles-img
docker exec -it dotfiles-con /bin/zsh
```

コンテナでaptでインストールする場合は以下を実行します．

```bash
dots install --apt
```

Homebrew をインストールして進める場合は以下のコマンドを実行します.

```bash
dots install --brew
```

## 🖼️ ギャラリー

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

## ⚡  エイリアスコマンド

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

#### Show tmux pane id

Show tmux  pane id

```bash
tid # tmux display -pt "${TMUX_PANE:?}" "#{pane_index}"
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

| キー                                        | 実行される操作               |
| ------------------------------------------- | ---------------------------- |
| <kbd>Ctrl</kbd>+(<kbd>↑</kbd>/<kbd>↓</kbd>) | undo / redo                  |
| <kbd>Ctrl</kbd>+(<kbd>←</kbd>/<kbd>→</kbd>) | backward-word / forward-word |

### Tmux

#### プレフィックスキー

> [!NOTE]
> プレフィックスキーは `Ctrl + \` に設定しています．
>

| キー                         | 説明                                   |
| ---------------------------- | -------------------------------------- |
| <kbd>I</kbd>                 | tpmでプラグインをインストールします    |
| <kbd>U</kbd>                 | tmuxプラグインのアップデートをします   |
| <kbd>Ctrl</kbd>+<kbd>s</kbd> | tmux環境を保存します                   |
| <kbd>Ctrl</kbd>+<kbd>r</kbd> | tmux環境を復元します                   |
| <kbd>d</kbd>                 | tmuxセッションからデタッチします       |
| <kbd>e</kbd>                 | ペインの同期モードON/OFFを切り替えます |

> [!TIP]
> Tmux のセッションをネストしている場合（Tmux の中でさらに Tmux を開いている場合），<br>
> プレフィックスキー（例: Ctrl-b）をネストの数だけ押すと，
> 最も内側のセッションにプレフィックスキーが送信されます．
>
> 例えば，Tmux を 2段階 ネストしている場合：
> 最初の `Ctrl-\` は最も外側のセッションに処理されます．
> 2回目の `Ctrl-\` で 1つ内側のセッションへ送信されます．
> 3回目の `Ctrl-\` で最も内側のセッションへ送信されます．
> さらに，`Ctrl-\` を押すと，そのキー入力がセッション内のシェルに送信されます．
>

##### tmux プラグイン

デフォルトでインストールされる tmux プラグインは以下のとおりです．

- [tpm]
- [tmux-continuum]
- [tmux-logging]
- [tmux-resurrect]
- [tmux-fingers]

#### Alt キーとの組み合わせによるショートカット

window と pane の操作を可能としています．

| キー                                       | 説明                                          | プレフィックスキーでの操作                          |
| ------------------------------------------ | --------------------------------------------- | --------------------------------------------------- |
| <kbd>Alt</kbd>+(<kbd>↑</kbd>/<kbd>↓</kbd>) | ウィンドウを作成/削除します                   | <kbd>c</kbd>/<kbd>&</kbd>                           |
| <kbd>Alt</kbd>+(<kbd>←</kbd>/<kbd>→</kbd>) | 前・後のウィンドウに切り替えます              | <kbd>p</kbd>/<kbd>n</kbd>                           |
| <kbd>Alt</kbd>+<kbd>[1-9]</kbd>            | 番号1-9のウィンドウに切り替えます             | <kbd>[1-9]</kbd>                                    |
| <kbd>Alt</kbd>+<kbd>-</kbd>                | ウィンドウを水平に分割します                  | <kbd>-</kbd>                                        |
| <kbd>Alt</kbd>+<kbd>\\</kbd>               | ウィンドウを垂直に分割します                  | <kbd>\\</kbd>                                       |
| <kbd>Alt</kbd>+<kbd>[hjkl]</kbd>           | 左/下/上/右のペインにフォーカスを切り替えます | <kbd>←</kbd>/<kbd>↓</kbd>/<kbd>↑</kbd>/<kbd>→</kbd> |

#### Alt + Shift キーとの組み合わせによるショートカット

主に session の操作を可能としています．

| キー                                                        | 説明                             | プレフィックスキーでの操作 |
| ----------------------------------------------------------- | -------------------------------- | -------------------------- |
| <kbd>Alt</kbd>+<kbd>Shift</kbd>+(<kbd>↑</kbd>/<kbd>↓</kbd>) | セッションを作成/削除します      |                            |
| <kbd>Alt</kbd>+<kbd>Shift</kbd>+(<kbd>←</kbd>/<kbd>→</kbd>) | 前・後のセッションに切り替えます | <kbd>(</kbd>/<kbd>)</kbd>  |

### Neovim

[LazyVimのキーマップ] をベースに，いくつかのキーバインドを追加しています.

| モード | キー                                        | 説明                                                             |
| :----: | ------------------------------------------- | ---------------------------------------------------------------- |
|  n,v   | <kbd>Ctrl</kbd>+(<kbd>↑</kbd>/<kbd>↓</kbd>) | 前のパラグラフの終端，後のパラグラフの先頭にカーソルを移動します |
| n,v,i  | <kbd>Ctrl</kbd>+(<kbd>←</kbd>/<kbd>→</kbd>) | 前の単語/次の単語にカーソルを移動します                          |
|   i    | <kbd>Ctrl</kbd>+<kbd>/</kbd>                | Undo (操作を１回戻します)                                        |
|   i    | <kbd>Ctrl</kbd>+<kbd>r</kbd>                | Redo (操作を１回やり直します)                                    |
|   i    | <kbd>jj</kbd>                               | Esc (ノーマルモードに切り替えます)                               |

インサートモードで以下の Emacs ライクなショートカットを設定しています．詳細は[こちら]を参照ください．

- <kbd>Ctrl</kbd>+<kbd>[abdefnpuwy]</kbd>
- <kbd>Alt</kbd>+<kbd>[bdf]</kbd>

## 📜 ライセンス

このプロジェクトは [MIT License](../LICENSE.md) に基づいてライセンスされています．

<!-- Reference-style links -->
<!-- URL -->
[starship]: https://starship.rs/
[Neovim]: https://github.com/neovim/neovim
[LazyVim]: https://www.lazyvim.org/
[LazyVimのキーマップ]: https://www.lazyvim.org/keymaps
[tmux]: https://github.com/tmux/tmux
[zellij]: https://github.com/zellij-org/zellij
[broot]: https://github.com/Canop/broot
[yazi]: https://github.com/sxyazi/yazi
[Alacritty]: https://github.com/alacritty/alacritty
[Termux]: https://github.com/termux/termux-app
[F-Droid]: https://f-droid.org/
[tpm]: https://github.com/tmux-plugins/tpm
[tmux-continuum]: https://github.com/tmux-plugins/tmux-continuum
[tmux-logging]: https://github.com/tmux-plugins/tmux-logging
[tmux-resurrect]: https://github.com/tmux-plugins/tmux-resurrect
[tmux-fingers]: https://github.com/Morantron/tmux-fingers
[Google Chrome]: https://www.google.com/intl/en_us/chrome/
[CopyQ]: https://hluk.github.io/CopyQ/
[Visual Studio Code]: https://code.visualstudio.com/
[LocalSend]: https://localsend.org/
[Obsidian]: https://obsidian.md/
[RustDesk]: https://rustdesk.com/
[Signal Desktop]: https://signal.org/
[Waydroid]: https://waydro.id/
[Zed]: <https://zed.dev/>
[HackGen]: <https://github.com/yuru7/HackGen>
[Nerd Fonts]: https://www.nerdfonts.com/
[M PLUS 2]: <https://mplusfonts.github.io>
[Google Fonts]: https://fonts.google.com/specimen/M+PLUS+2
[Mozc]: https://github.com/google/mozc

<!-- relative link -->
[English]: ../
[apt packages]: ../assets/txt/apt-packages.txt
[brew packages]: ../Brewfile
[snap packages]: ../assets/txt/snap-packages.txt
[pkg packages]: ../assets/txt/pkg-packages.txt
[こちら]: ./neovim.md#emacs-like
