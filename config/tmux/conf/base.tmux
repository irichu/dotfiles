#--------------------------------------------------------------
# Base
#--------------------------------------------------------------


# Status bar
set -g status on
set -g status-interval 1
set -g status-position top

# Upgrade $TERM
set -g default-terminal "screen-256color"

set -g default-shell $SHELL
set -g default-command $SHELL

# Index
set-hook -g session-created "run-shell ${TMUX_SCRIPT_DIR}/tmux-renumber-sessions.sh"
set-hook -g session-closed "run-shell ${TMUX_SCRIPT_DIR}/tmux-renumber-sessions.sh"

set -g base-index 1
set -g renumber-windows on

setw -g pane-base-index 1

# Maximum number of lines in window history
set -g history-limit 100000

# display seconds
set -g display-time 2000
set -g display-panes-time 5000

# Use vi key bindings
setw -g mode-keys vi
set -g default-command ""

set -g set-clipboard on

# Enable visual notifications
setw -g monitor-activity on
set -g visual-activity off

# Bell
set -g bell-action other
set -g visual-bell off

set -g escape-time 50

# Switch to simultaneous pane input
set -g synchronize-panes off

# Switch to mouse operation
set -g mouse on

# Use arrow keys to move panes
setw -g xterm-keys on

# emacs key bindings in tmux command prompt (prefix + :) are better than
# vi keys, even for vim users
set -g status-keys emacs

# focus events enabled for terminals that support them
set -g focus-events on

# super useful when using "grouped sessions" and multi-monitor setup
setw -g aggressive-resize on

# change window title
set -g set-titles on
set -g set-titles-string '#T'
setw -g automatic-rename on

# change word delimiter
set -g word-separators " -_()@,[]{}:=/"

