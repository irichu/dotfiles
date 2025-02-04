# atuin
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh)"
  bindkey "^[[A" history-beginning-search-backward
fi
