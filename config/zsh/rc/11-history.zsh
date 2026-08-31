# Keep mutable history outside the repository-backed ZDOTDIR.
typeset -g ZSH_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
mkdir -p "$ZSH_STATE_HOME"
export HISTFILE="$ZSH_STATE_HOME/history"
export HISTSIZE=100000
export SAVEHIST=100000
