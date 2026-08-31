typeset -U fpath FPATH
typeset -g ZSH_COMPLETIONS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/completions"
typeset -g ZSH_COMPDUMP_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
typeset -g ZSH_COMPDUMP_FILE="$ZSH_COMPDUMP_DIR/.zcompdump"
mkdir -p "$ZSH_COMPLETIONS_DIR" "$ZSH_COMPDUMP_DIR"

# zsh-completions
# "$BREW_PREFIX/share/zsh/site-functions"
# /usr/share/zsh/site-functions
fpaths=(
  "$BREW_PREFIX/share/zsh-completions"
  /usr/share/zsh/vendor-completions
  /usr/local/share/zsh-completions
  "${XDG_DATA_HOME:-$HOME/.local/share}/zsh-completions/src"
  "$ZSH_COMPLETIONS_DIR"
  "$ZDOTDIR/completions"
)
for fp in $fpaths; do fpath=($fp(N-/) $fpath); done

autoload -Uz compinit
if [[ ! -e $ZSH_COMPDUMP_FILE || $(find "$ZSH_COMPDUMP_FILE" -mtime 1 2>/dev/null) ]]; then
  compinit -d "$ZSH_COMPDUMP_FILE"
fi
compinit -C -d "$ZSH_COMPDUMP_FILE"

autoload -Uz _dots _gum
compdef _dots dots
compdef _gum gum
