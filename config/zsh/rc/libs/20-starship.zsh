# starship.rs
if command -v starship &>/dev/null; then
  export STARSHIP_CONFIG=~/.config/starship/config.toml
  # if [[ $TERM_WIDTH -lt 80 ]]; then
  #   export STARSHIP_CONFIG=~/.config/starship/nonerd.toml
  # fi
  eval "$(starship init zsh)"
fi
