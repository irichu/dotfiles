typeset -U path PATH

# Add PATH
paths=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  /snap/bin
)
for p in $paths; do path=($p(N-/) $path); done

