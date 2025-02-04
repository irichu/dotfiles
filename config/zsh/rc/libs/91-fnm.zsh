# fnm
FNM_PATH="$XDG_DATA_HOME/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$XDG_DATA_HOME/fnm:$PATH"
  # eval "`fnm env`"
  eval "$(fnm env --use-on-cd --shell zsh)"
fi
