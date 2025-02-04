#!/bin/bash

# Check the window width and set the status format based on conditions
WINDOW_WIDTH=$(tmux display-message -p "#{window_width}")

if [ "$WINDOW_WIDTH" -lt 80 ]; then
  # --- Narrow width ---
  # current window
  tmux setw -g window-status-current-format "#[bg=colour214 fg=colour234] #I "
  # not selected window
  tmux setw -g window-status-format "#[bg=colour111 fg=colour234] #I "
  # status-right
  tmux set -g status-right "#[bg=colour193 fg=colour234] #S #[bg=colour117 fg=colour234] #(id -un)@#h #[bg=colour111 fg=colour234] %H:%M:%S "
else
  # --- Wide width ---
  # current window
  tmux setw -g window-status-current-format "#[bg=colour214 fg=colour234] #I #[bg=colour240 fg=colour214 none] #{s/#{HOME}/~/:#{pane_current_path}} "
  # not selected window
  tmux setw -g window-status-format "#[bg=colour111 fg=colour234] #I #[bg=colour240 fg=colour231 none] #{=/8/…:#{?#{m:#{pane_current_path},#{HOME}},~,#{b:pane_current_path}}} "
  # status-right
  tmux set -g status-right "#[bg=colour193 fg=colour234]  #S #[bg=colour117 fg=colour234]  #(id -un) #[bg=colour152 fg=colour234] 󰒋 #h #[bg=colour147 fg=colour234] 󰲋 #W #[bg=colour111 fg=colour234] 󰃰 %H:%M:%S %m/%d(%a) "
fi
