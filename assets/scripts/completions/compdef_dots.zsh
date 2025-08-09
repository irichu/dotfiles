#compdef dots

_dots_install() {
  _arguments -C \
    "--apt[Install using apt]" \
    "--brew[Install Homebrew and packages]" \
    "--pkg[Install using pkg on Termux]" \
    "--snap[Install using snap on Ubuntu]" \
    "--ubuntu-desktop[Install Ubuntu Desktop apps and setup GNOME Desktop]"

  _values "package" \
    "apt-packages[Apt packages]" \
    "chrome[Google Chrome]" \
    "code[Visual Studio Code]" \
    "copyq[CopyQ]" \
    "docker[Docker on Ubuntu Desktop]" \
    "fnm[fnm(Fast Node Maneger)]" \
    "fzf[fzf]" \
    "gum[gum]" \
    "hackgen[HackGen font]" \
    "lazygit[Lazygit]" \
    "lazydocker[LazyDocker]" \
    "lazyvim[Lazyvim]" \
    "localsend[LocalSend]" \
    "mise[mise]" \
    "mozc[Mozc - a Japanese input method editor(IME)]" \
    "mplus2[M PLUS 2 font]" \
    "neovim[Neovim]" \
    "obsidian[Obsidian]" \
    "rustdesk[RustDesk on Ubuntu Desktop]" \
    "rustup[rustup on Linux]" \
    "snap-packages[Snap packages]" \
    "starship[Starship]" \
    "signal[Signal Desktop]" \
    "waydroid[Waydroid - Android in a Linux container]" \
    "zed[Zed editor]"
}

_dots_setup() {
  _values "setup subcommand" \
    "chrome-fonts[Setup Google Chrome fonts]" \
    "desktop[Setup gnome-desktop]" \
    "git[Setup git]" \
    "tmux[Setup tmux]" \
    "zellij[Setup zellij]" \
    "zsh[Setup zsh]"
}

_dots_list() {
  _values "list subcommand" \
    "--apt[Apt packages]" \
    "--brew[Homebrew packages]" \
    "--pkg[Termux packages]" \
    "--snap[Snap packages]"

  #"npm[NPM packages]" \
  #"cargo[Cargo packages]" \
  #"pip[Pip packages]" \
  #"go[Go packages]" \
  #"vscode[VSCode extensions]" \
  #"zsh[Zsh plugins]"
}

_dots_clean() {
  _values "clean subcommand" \
    "backup[Remove ~/.local/share/dotfiles*.bak*]" \
    "config[Remove ~/.config/*.bak* directories]" \
    "all[Remove all backup and config files]"
}

_dots_docker_test() {
  _values "docker test distributions" \
    "ubuntu" \
    "ubuntu-22.04" \
    "arch" \
    "fedora"
}

_dots_docker() {
  local line state
  _arguments -C \
    "1: :->command" \
    "*::arg:->args"
  case "$state" in
  command)
    _values "dots docker subcommand" \
      "test[Build & run docker container for testing]"
    ;;
  args)
    case "$line[1]" in
    test)
      _dots_docker_test
      ;;
    esac
    ;;
  esac
}

_dots_set-tmux-theme() {
  local themes=(
    "developer"
    "developer-textcolored"
    "developer-colorful"
    "developer-mono"
    "dark-turquoise"
    "dark-turquoise-textcolored"
    "dark-turquoise-colorful"
    "dark-turquoise-mono"
    "dark-orange"
    "dark-orange-textcolored"
    "dark-orange-colorful"
    "dark-orange-mono"
    "dark-skyblue"
    "dark-skyblue-textcolored"
    "dark-skyblue-colorful"
    "dark-skyblue-mono"
    "random"
  )
  _values "theme name" $themes
}

_dots_set-lang() {
  local langs=(
    'en_US.UTF-8'
    'ja_JP.UTF-8'
  )
  _values "LANG env value" $langs
}

_dots_set-starship() {
  local themes=(
    'simple'
    'default'
  )
  _values "starship theme value" $themes
}

_dots() {

  local line state
  _arguments -C \
    '(-h --help)'{-h,--help}"[Show help.]" \
    '(-v --version)'{-v,--version}"[Print dots version info]" \
    "1: :->command" \
    "*::arg:->args"
  case "$state" in
  command)
    _values "dots command" \
      "install[Install all dependencies or individual package]" \
      "setup[Setup environment]" \
      "upgrade[Upgrade packages]" \
      "list[List packages]" \
      "apply[Apply configuration]" \
      "backup[Backup configuration]" \
      "clean[Clean up]" \
      "docker[Run docker container]" \
      "tmux-theme[Show current tmux theme name]" \
      "set-tmux-theme[Set tmux theme]" \
      "set-lang[Set LANG environment value]" \
      "starship[Show current starship config]" \
      "set-starship[Set starship theme]" \
      "opacity[Show current terminal opacity]" \
      "set-opacity[Set terminal opacity (0.00 - 1.00)]" \
      "help[Print help information]" \
      "version[Print dots version information]"
    ;;
  args)
    case "$line[1]" in # $words[2]
    install)
      _dots_install
      ;;
    setup)
      _dots_setup
      ;;
    list)
      _dots_list
      ;;
    docker)
      _dots_docker
      ;;
    clean)
      _dots_clean
      ;;
    set-tmux-theme)
      _dots_set-tmux-theme
      ;;
    set-lang)
      _dots_set-lang
      ;;
    set-starship)
      _dots_set-starship
      ;;
    esac
    ;;
  esac

}

#compdef _dots dots
