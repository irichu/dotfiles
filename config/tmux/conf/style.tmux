#--------------------------------------------------
# Style 
#--------------------------------------------------

# SkyBlue2 colour111
# Orange1 colour214
# Grey11 colour234 #1C1C1C

# Status bar background colour
setw -g status-style "bg=colour234"

# Status left
setw -g status-left ""

# status bar
# Status bar window currently active
setw -g window-status-current-style "bg=colour214 fg=colour234 none"

# right status bar 
setw -g status-right-length 200

# change window status when attached
set-hook -g client-session-changed 'run-shell "${TMUX_SCRIPT_DIR}/tmux-hook.sh"'
run-shell "${TMUX_SCRIPT_DIR}/tmux-hook.sh"

# pane border
# pane-border("single", "double", "heavy", "simple", "number", NULL)
set -g pane-border-lines single
set -g pane-border-status bottom
set -g pane-border-format "#[fg=default bg=colour243]#{?pane_active,#[fg=black bg=colour147],}#{?pane_synchronized,#[fg=black bg=colour193],}#{?#{>=:#{window_panes},2},  #P ,}#(tmux-pane-border '#{pane_current_path}')"
set -g pane-border-style fg=colour239,bg=default
set -g pane-active-border-style "#{?pane_synchronized,fg=colour193,fg=colour147}"

# message text
set -g message-style bg=colour234,fg=colour111

# pane number display (<prefix> q)
set -g display-panes-active-colour colour214
set -g display-panes-colour colour111

# clock (<prefix> t)
setw -g clock-mode-colour colour111

# bell
# setw -g window-status-bell-style "fg=colour235,bg=colour160"
# set-window-option -g window-status-bell-bg colour160
# set-window-option -g window-status-bell-fg colour235
