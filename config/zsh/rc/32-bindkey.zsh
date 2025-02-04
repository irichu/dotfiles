# bind
[[ $- = *i* ]] && stty -ixon

# emacs-like
bindkey -e

# undo, redo
bindkey '^[z' push-line
bindkey '^[,' undo
bindkey '^[.' redo

# ctrl arrow
bindkey '^[[1;5A' undo
bindkey '^[[1;5B' redo
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# line editor
export EDITOR='nvim'
export SUDO_EDITOR='nvim'
autoload -Uz edit-command-line
zle -N edit-command-line # Zsh Line Editor
bindkey "^[x" edit-command-line

