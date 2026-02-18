# Devbox shell environment setup
if command -v devbox &> /dev/null; then
  eval "$(devbox global shellenv --init-hook)"
fi
