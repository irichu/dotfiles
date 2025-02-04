typeset -U fpath FPATH

# zsh-completions
# "$BREW_PREFIX/share/zsh/site-functions"
# /usr/share/zsh/site-functions
fpaths=(
  "$BREW_PREFIX/share/zsh-completions"
  /usr/share/zsh/vendor-completions
  /usr/local/share/zsh-completions
  "$HOME/.config/zsh/completions"
  "$XDG_DATA_HOME/zsh-completions/src"
)
for fp in $fpaths; do fpath=($fp(N-/) $fpath); done

autoload -Uz compinit
if [[ ! -e $ZDOTDIR/.zcompdump || $(find $ZDOTDIR/.zcompdump -mtime 1 2>/dev/null) ]]; then
  compinit
fi
compinit -C

