# zsh
if [ $SHELL = "/bin/zsh" ]; then
  plugins=(
    /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  )
  for p in $plugins; do [ -f $p ] && source $p; done
fi

if command -v brew &>/dev/null; then
  # zsh plugins
  source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
