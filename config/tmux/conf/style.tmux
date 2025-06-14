#--------------------------------------------------
# Style
#--------------------------------------------------

# Grey11 colour234 #1c1c1c
# MediumPurple1	colour141 #af87ff
# SkyBlue1 colour117 #87d7ff
# SkyBlue2 colour111 #87afff
# DarkTurquoise colour44 #00d7d7
# Orange1 colour214 #ffaf00
# Orange2 colour208 #ff8700
# LightSteelBlue color147 #afafff
# DarkSeaGreen1 colour193 #d7ffaf

set -g message-style "fg=default,bg=default"
set -g pane-border-style "fg=default"
set -g pane-active-border-style "fg=default"

# Status bar background colour
# setw -g status-style "fg=default,bg=colour234"
setw -g status-style "fg=default,bg=default" #222222

# Status left
setw -g status-left ""

# status bar
# Status bar window currently active
#setw -g window-status-current-style "bg=colour214 fg=colour234"

# window status
# ../scripts/tmux-window-status.sh

# right status bar
setw -g status-right-length 200

# change window status when attached
set-hook -g client-session-changed 'run-shell "${TMUX_SCRIPT_DIR}/tmux-hook.sh"'
run-shell "${TMUX_SCRIPT_DIR}/tmux-hook.sh"

# pane border
# pane-border("single", "double", "heavy", "simple", "number", NULL)
set -g pane-border-lines single
set -g pane-border-status bottom

# pane number display (<prefix> q)
set -g display-panes-colour colour239 #grey

# clock (<prefix> t)
#setw -g clock-mode-colour colour111

# bell
# setw -g window-status-bell-style "fg=colour235,bg=colour160"
# set-window-option -g window-status-bell-bg colour160
# set-window-option -g window-status-bell-fg colour235
