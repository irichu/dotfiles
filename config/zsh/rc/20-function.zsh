# functions
function cdls() { \cd $1 && ls -l }

function mkdircd() { mkdir -p $1 && cd $_ }

function tvim() {
  tmux split-window -v
  tmux split-window -h
  tmux resize-pane -D 15
  tmux select-pane -t 1

  fdfind --type f --hidden --exclude .git | fzf-tmux -p | xargs -o nvim
}

function confirm {
  echo -n "$1 [y/N]: "; read -q; return $?
}

help() {
    "$@" --help 2>&1 | bathelp
}
