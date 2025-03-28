#--------------------------------------------------
# Plugins
#--------------------------------------------------

set -g @plugin "tmux-plugins/tpm"
set -g @plugin "tmux-plugins/tmux-continuum"
set -g @plugin "tmux-plugins/tmux-logging"
set -g @plugin "tmux-plugins/tmux-resurrect"

if "[ $(uname -m) = x86_64 ]" \
  "set -g @plugin 'Morantron/tmux-fingers'"

# set -g @plugin 'fcsonline/tmux-thumbs'
# set -g @plugin "tmux-plugins/tmux-sensible"
# set -g @plugin "catppuccin/tmux#v0.3.0"

#--------------------------------------------------
# Install/Execute tpm
#--------------------------------------------------

if "[ ! -d ${TMUX_PLUGIN_DIR}/tpm ]" \
    "run 'git clone --depth 1 https://github.com/tmux-plugins/tpm ${TMUX_PLUGIN_DIR}/tpm'"

if "[ -f ${TMUX_PLUGIN_DIR}/tpm/tpm ]" \
    "run-shell '${TMUX_PLUGIN_DIR}/tpm/tpm'"

#--------------------------------------------------
# Plugins Config
#--------------------------------------------------
# tmux-continuum
# <prefix> + Ctrl-s : save
# <prefix> + Ctrl-r : restore
#--------------------------------------------------

set -g @continuum-save-interval "60"
# set -g @continuum-boot 'on'  # OnBoot
set -g @continuum-restore "on"
set -g @resurrect-dir "${TMUX_PLUGIN_DIR}/../resurrect"
set -g @fingers-key F

# set -g @catppuccin_flavor "mocha"
#
# set -g @catppuccin_status_modules_right "application session user host date_time"
# set -g @catppuccin_status_left_separator "█"
# set -g @catppuccin_status_right_separator "█"
#
# set -g @catppuccin_date_time_text "%H:%M:%S %Y-%m-%d"

# if "[ -d ${TMUX_PLUGIN_DIR}/tmux-thumbs ]" \
#     "run-shell ~/.config/tmux/plugins/tmux-thumbs/tmux-thumbs.tmux"
# set -g @thumbs-key F

