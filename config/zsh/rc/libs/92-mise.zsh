# Mise
if [[ -f ~/.local/bin/mise ]]; then
  eval "$(~/.local/bin/mise activate zsh)"
elif command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi
