# brew
[ -f /home/linuxbrew/.linuxbrew/bin/brew ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

if command -v brew &>/dev/null; then
  export BREW_PREFIX=$(brew --prefix)

  # XDG Base
  if [[ ":$XDG_DATA_DIRS:" != *":$BREW_PREFIX/share:"* ]]; then
    export XDG_DATA_DIRS="$BREW_PREFIX/share:$XDG_DATA_DIRS"
  fi
fi
