#!/bin/bash

#--------------------------------------------------
# color palette
#--------------------------------------------------
#1c1c1c colour234 Grey11
#3a3a3a colour237 Grey23
#4e4e4e colour239 Grey30
#767676 colour243 Grey46
#af87ff colour141 MediumPurple1
#8787ff colour105 LightSlateBlue
#87d7ff colour117 SkyBlue1
#87afff colour111 SkyBlue2
#afafff colour147 LightSteelBlue
#00d7d7 colour44  DarkTurquoise
#ffaf00 colour214 Orange1
#ff8700 colour208 Orange2
#ff5f87 colour204 IndianRed1
#afafff colour147 LightSteelBlue
#d7ffaf colour193 DarkSeaGreen1
#afd7d7 colour152 LightCyan3
#5fff87 colour84  SeaGreen1
#ffdd00 colour220 Gold1

#--------------------------------------------------
# themes
#--------------------------------------------------
# available themes
themes=(
  "developer"
  "developer-textcolored"
  "developer-colorful"
  "developer-mono"
  "dark-turquoise"
  "dark-turquoise-textcolored"
  "dark-turquoise-colorful"
  "dark-turquoise-mono"
  "dark-orange"
  "dark-orange-textcolored"
  "dark-orange-colorful"
  "dark-orange-mono"
  "dark-skyblue"
  "dark-skyblue-textcolored"
  "dark-skyblue-colorful"
  "dark-skyblue-mono"
)

#--------------------------------------------------
# load config file
#--------------------------------------------------
source "${TMUX_SCRIPT_DIR:-$HOME/.config/tmux/script}"/config.sh

# set a random theme
if [[ ${theme:-} == "random" ]]; then
  # shuf -i 0-15 -n 1
  n=$(((RANDOM + RANDOM + RANDOM) % 16))
  theme="${themes[$n]}"
fi

# current window (default)
#--------------------------------------------------
# theme: developer
#--------------------------------------------------

# current window status
base_color="colour105"
black_color="colour234"
black_gray_color="colour237"
gray_color="colour239"
light_gray_color="colour243"

# text color
seagreen_color="colour193"
palegreen_color="colour77"
orange_color="colour214"
skyblue_color="colour117"
skyblue2_color="colour111"
light_white_color="colour254"

# DarkTurquoise
darkturquoise_color="colour44"
lightcyan3_color="colour152"
lightsteelblue_color="colour147"

# current window (default)
current_window_bg=$base_color
current_window_fg=$black_color
current_window_app_bg=$gray_color
current_window_app_fg=$base_color

# window status (not selected)
not_selected_window_bg=$light_gray_color
not_selected_window_fg=$black_color
not_selected_window_str_bg=$gray_color
not_selected_window_str_fg=$black_color

# status-right
status_right_bg=$base_color
status_right_bg2=$status_right_bg
status_right_bg3=$status_right_bg
status_right_bg4=$status_right_bg
status_right_bg5=$status_right_bg

# nerdy icons
status_right_fg=$black_color
status_right_fg2=$status_right_fg
status_right_fg3=$status_right_fg
status_right_fg4=$status_right_fg
status_right_fg5=$status_right_fg

# text background-color
status_right_str_bg=$black_gray_color
status_right_str_bg2=$status_right_str_bg
status_right_str_bg3=$status_right_str_bg
status_right_str_bg4=$status_right_str_bg
status_right_str_bg5=$status_right_str_bg

# text color
status_right_str_fg=$seagreen_color
status_right_str_fg2=$palegreen_color
status_right_str_fg3=$orange_color
status_right_str_fg4=$skyblue_color
status_right_str_fg5=$light_white_color

# pane synchronized base color
pane_synchronized_bg=$seagreen_color

# weekday
weekday=$(date +%w)
weekday_color="colour231"
if [[ $weekday == 6 ]]; then
  weekday_color=$skyblue2_color
elif [[ $weekday == 0 ]]; then
  weekday_color="colour204"
fi

#--------------------------------------------------
# theme: dark-turquoise
#--------------------------------------------------
if [[ ${theme:-} =~ ^dark-turquoise ]]; then
  # current window (DarkTurquoise)
  base_color=$darkturquoise_color

  current_window_bg=$base_color
  current_window_fg=$black_color
  current_window_app_bg=$gray_color
  current_window_app_fg=$base_color

  status_right_bg=$base_color
  status_right_bg2=$status_right_bg
  status_right_bg3=$status_right_bg
  status_right_bg4=$status_right_bg
  status_right_bg5=$status_right_bg

#--------------------------------------------------
# theme: dark-orange
#--------------------------------------------------
elif [[ ${theme:-} =~ ^dark-orange ]]; then
  # current window (Orange1)
  base_color=$orange_color

  current_window_bg=$base_color
  current_window_fg=$black_color
  current_window_app_bg=$gray_color
  current_window_app_fg=$base_color

  status_right_bg=$base_color
  status_right_bg2=$status_right_bg
  status_right_bg3=$status_right_bg
  status_right_bg4=$status_right_bg
  status_right_bg5=$status_right_bg

#--------------------------------------------------
# theme: skyblue
#--------------------------------------------------
elif [[ ${theme:-} =~ ^dark-skyblue ]]; then
  # current window (Orange1)
  base_color=$skyblue2_color

  current_window_bg=$base_color
  current_window_fg=$black_color
  current_window_app_bg=$gray_color
  current_window_app_fg=$base_color

  status_right_bg=$base_color
  status_right_bg2=$status_right_bg
  status_right_bg3=$status_right_bg
  status_right_bg4=$status_right_bg
  status_right_bg5=$status_right_bg
fi

# text color
if [[ ${theme:-} =~ textcolored$ ]]; then
  status_right_str_fg=$seagreen_color
  status_right_str_fg2=$palegreen_color
  status_right_str_fg3=$orange_color
  status_right_str_fg4=$skyblue2_color
  status_right_str_fg5=$light_white_color
elif [[ ${theme:-} =~ -mono$ ]]; then
  status_right_str_fg=$current_window_bg
  status_right_str_fg2=$current_window_bg
  status_right_str_fg3=$current_window_bg
  status_right_str_fg4=$current_window_bg
  status_right_str_fg5=$current_window_bg
else
  status_right_str_fg=$light_white_color
  status_right_str_fg2=$status_right_str_fg
  status_right_str_fg3=$status_right_str_fg
  status_right_str_fg4=$status_right_str_fg
  status_right_str_fg5=$status_right_str_fg
fi

# weekday
weekday_str=""
if [[ ${show_weekday:-} == "true" ]]; then
  if [[ ${theme:-} =~ -mono$ ]]; then
    weekday_str="(%a)"
  else
    weekday_str="(#[fg=$weekday_color]%a#[bg=$status_right_str_bg5 fg=$status_right_str_fg5])"
  fi
fi

# Check the window width and set the status format based on conditions
WINDOW_WIDTH=$(tmux display-message -p "#{window_width}")

#--------------------------------------------------
# Narrow width
#--------------------------------------------------
if [ "$WINDOW_WIDTH" -lt 80 ]; then
  # --- Narrow width ---
  # current window
  tmux setw -g window-status-current-format "#[bg=$current_window_bg fg=$current_window_fg] #I "

  # not selected window
  tmux setw -g window-status-format "#[bg=$not_selected_window_bg fg=$not_selected_window_fg] #I "

  # status-right
  if [[ ${theme:-} =~ -colorful$ ]]; then
    tmux set -g status-right "#[bg=$seagreen_color fg=$black_color]  #S \
#[bg=$skyblue_color fg=$black_color]  #(id -un)@#h \
#[bg=$skyblue2_color fg=$black_color] 󰃰 %H:%M:%S "
  else    
    tmux set -g status-right "#[bg=$current_window_bg fg=$current_window_fg]  \
#[bg=$status_right_str_bg fg=$status_right_str_fg] #S \
#[bg=$current_window_bg fg=$current_window_fg]  \
#[bg=$status_right_str_bg fg=$status_right_str_fg2] #(id -un)@#h \
#[bg=$current_window_bg fg=$current_window_fg] 󰃰 \
#[bg=$status_right_str_bg fg=$status_right_str_fg4] %H:%M:%S "
  fi

#--------------------------------------------------
# Wide width
#--------------------------------------------------
else
  # --- Wide width ---
  tmux setw -g window-status-current-format "\
#[bg=$current_window_bg fg=$current_window_fg] 󰓩 #I \
#[bg=$current_window_app_bg fg=$current_window_app_fg none] #W "

  #if [[ ${theme:-} =~ \#[0-9a-zA-Z]{6} || ${theme:-} =~ \#[0-9a-zA-Z]{3} ]]; then
  #  tmux setw -g window-status-current-format "#[bg=${theme} fg=colour234] 󰓩 #I #[bg=colour240 fg=${theme} none] #{s/#{HOME}/~/:#{pane_current_path}} "
  #fi

  # not selected window
  tmux setw -g window-status-format "\
#[bg=$not_selected_window_bg fg=$not_selected_window_fg] #I \
#[bg=$not_selected_window_str_bg fg=$not_selected_window_str_fg] #W "
# directory path
# #{=/8/…:#{?#{m:#{pane_current_path},#{HOME}},~,#{b:pane_current_path}}} 

  # status-right
  if [[ ${theme:-} =~ -colorful$ ]]; then
    current_window_bg=$darkturquoise_color
    current_window_fg=$black_color
    not_selected_window_bg=$skyblue2_color
    not_selected_window_fg=$black_color

    status_right_bg=$seagreen_color
    status_right_bg2=$skyblue_color
    status_right_bg3=$lightcyan3_color
    status_right_bg4=$lightsteelblue_color
    status_right_bg5=$skyblue2_color
    status_right_fg=$black_color

    tmux set -g status-right "\
#[bg=$status_right_bg fg=$status_right_fg]  #S \
#[bg=$status_right_bg2 fg=$status_right_fg2]  #(id -un) \
#[bg=$status_right_bg3 fg=$status_right_fg3] 󰒋 #h \
#[bg=$status_right_bg4 fg=$status_right_fg4] 󰲋 #W \
#[bg=$status_right_bg5 fg=$status_right_fg5] 󰃰 %H:%M:%S %m/%d(%a) "

  else
    tmux set -g status-right "\
#[bg=$status_right_bg fg=$status_right_fg]  \
#[bg=$status_right_str_bg fg=$status_right_str_fg] #S \
#[bg=$status_right_bg2 fg=$status_right_fg2]  \
#[bg=$status_right_str_bg2 fg=$status_right_str_fg2] #(id -un) \
#[bg=$status_right_bg3 fg=$status_right_fg3] 󰒋 \
#[bg=$status_right_str_bg3 fg=$status_right_str_fg3] #h \
#[bg=$status_right_bg4 fg=$status_right_fg4]  \
#[bg=$status_right_str_bg4 fg=$status_right_str_fg4] #{s/#{HOME}/~/:#{pane_current_path}} \
#[bg=$status_right_bg5 fg=$status_right_fg5] 󰃰 \
#[bg=$status_right_str_bg5 fg=$status_right_str_fg5] $datetime_format$weekday_str "
  fi

fi

# message text
tmux set -g message-style "bg=$black_color,fg=$base_color"

# clock (<prefix> t)
tmux setw -g clock-mode-colour "$base_color"

# pane-border style
tmux set -g display-panes-active-colour "$base_color"

# pane-border style
tmux set -g pane-border-format "#[fg=default bg=$light_gray_color]#{?pane_active,#[fg=$black_color bg=$base_color],}#{?pane_synchronized,#[fg=$black_color bg=$pane_synchronized_bg],}#{?#{>=:#{window_panes},2},  #P ,}#(tmux-pane-border '#{pane_current_path}')"
tmux set -g pane-border-style fg=$gray_color,bg=default
tmux set -g pane-active-border-style "#{?pane_synchronized,fg=$pane_synchronized_bg,fg=$base_color}"
