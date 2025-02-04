# enter tmux session in login shell
if [[ -z $TMUX && $- == *l* ]]; then
  # termux local terminal
  [[ -n $TERMUX_VERSION && -z $SSH_CONNECTION ]] && return 0 

  msg="exit from $(uname -n) ($(hostname -i))?"

  # get the IDs
  ID="$(tmux list-sessions)"
  if [[ -z "$ID" ]]; then
    tmux new-session
    confirm $msg && exit
    return 0
  fi

  create_new_session="Create New Session"
  ID="$ID\n${create_new_session}:"

  ID="$(echo $ID | fzf | cut -d: -f1)"
  if [[ "$ID" = "${create_new_session}" ]]; then
    tmux new-session
    confirm $msg && exit
  elif [[ -n "$ID" ]]; then
    tmux attach-session -t "$ID"
    confirm $msg && exit
  else
    : # Start terminal normally
  fi
fi
