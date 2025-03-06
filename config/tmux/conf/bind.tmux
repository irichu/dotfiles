#--------------------------------------------------------------
# Key Bind
#--------------------------------------------------------------
# ref
# https://github.com/ThomasAdam/tmux/blob/master/key-bindings.c

set -g prefix 'C-\'
unbind C-b

# send into tmux terminal
bind 'C-\' send-prefix
bind d detach

# Rename
bind R command-prompt "rename-session %%"
bind A command-prompt "rename-window %%"

# Select
bind -n M-a choose-tree
bind -n M-e choose-session
# bind -n M-w choose-tree -w
bind C-w choose-window

# Session (on Linux)
bind -n M-S-left switch-client -p
bind -n M-S-right switch-client -n
bind -n M-S-up new-session
bind -n M-S-down confirm-before kill-session
# bind -n M-S new-session
# bind -n M-D confirm-before kill-session

# Session (on Windows)
bind -n C-M-left switch-client -p
bind -n C-M-right switch-client -n
bind -n C-M-up new-session
bind -n C-M-down confirm-before kill-session
# bind -n C-M-s new-session
# bind -n C-M-d confirm-before kill-session

# Reload configuration file
bind r source-file ${TMUX_CONFIG_DIR}/tmux.conf \; display "Reloaded!"
bind -n F5 source-file ${TMUX_CONFIG_DIR}/tmux.conf \; display "Reloaded!"

# Split the pane vertically
bind '\' split-window -hc "#{pane_current_path}"
bind -n 'M-\' split-window -hc "#{pane_current_path}"

# Split the pane horizontally
bind - split-window -vc "#{pane_current_path}"
bind -n M-- split-window -vc "#{pane_current_path}"

#bind-key C-g display-panes

# Move panes
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
bind -n M-h select-pane -L
bind -n M-j select-pane -D
bind -n M-k select-pane -U
bind -n M-l select-pane -R

# Move window
bind -n M-left previous-window
bind -n M-right next-window
bind -n M-up new-window -c "#{pane_current_path}"
bind -n M-down confirm-before kill-window

# Select window
bind -n M-1 select-window -t :=1
bind -n M-2 select-window -t :=2
bind -n M-3 select-window -t :=3
bind -n M-4 select-window -t :=4
bind -n M-5 select-window -t :=5
bind -n M-6 select-window -t :=6
bind -n M-7 select-window -t :=7
bind -n M-8 select-window -t :=8
bind -n M-9 select-window -t :=9
#bind -n M-0 select-window -t :=10
bind -n M-0 last-window

# Move pane to window
bind -n M-! join-pane -v -t :=1
bind -n M-@ join-pane -v -t :=2
bind -n M-# join-pane -v -t :=3
bind -n M-$ join-pane -v -t :=4
bind -n M-% join-pane -v -t :=5
bind -n M-^ join-pane -v -t :=6
bind -n M-& join-pane -v -t :=7
bind -n M-* join-pane -v -t :=8
bind -n M-( join-pane -v -t :=9
#bind -n M-) join-pane -v -t :=10

# Resize the pane
bind -r -n M-H resize-pane -L 5
bind -r -n M-J resize-pane -D 5
bind -r -n M-K resize-pane -U 5
bind -r -n M-L resize-pane -R 5

# Select layout
bind -n M-. next-layout
bind -n C-M-h select-layout even-horizontal
bind -n C-M-v select-layout even-vertical
bind -n C-M-n select-layout main-horizontal
bind -n C-M-m select-layout main-vertical
bind -n C-M-t select-layout tiled

# synchronize
bind e setw synchronize-panes \; display "synchronize-panes #{?pane_synchronized,on,off}"
bind S setw synchronize-panes \; display "synchronize-panes #{?pane_synchronized,on,off}"
bind -n M-s setw synchronize-panes \; display "synchronize-panes #{?pane_synchronized,on,off}"
bind -n C-M-s setw synchronize-panes \; display "synchronize-panes #{?pane_synchronized,on,off}"

# mouse
bind m set-option -g mouse on \; display "Mouse: ON"
bind M set-option -g mouse off \; display "Mouse: OFF"

bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'copy-mode -e'"
bind -n WheelDownPane select-pane -t= \; send-keys -M

# kill the pane
bind C-q confirm-before kill-pane

# log output
bind-key '{' pipe-pane "mkdir -p #{TMUX_LOG_DIR}; cat >> #{TMUX_LOG_DIR}/tmux-#W.log" \; display -d 5000 "Started logging to #{TMUX_LOG_DIR}/tmux-#W.log"
bind-key '}' pipe-pane \; display -d 5000 "Ended logging to #{TMUX_LOG_DIR}/tmux-#W.log"
