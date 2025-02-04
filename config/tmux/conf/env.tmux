#--------------------------------------------------------------
# Env
#--------------------------------------------------------------

_TMUX_CONFIG_DIR="${HOME}/.config/tmux"
setenv -g TMUX_CONFIG_DIR "${_TMUX_CONFIG_DIR}"
setenv -g TMUX_PLUGIN_DIR "${_TMUX_CONFIG_DIR}/plugins"
setenv -g TMUX_SCRIPT_DIR "${_TMUX_CONFIG_DIR}/script"

_TMUX_DATA_DIR="${HOME}/.local/share/tmux"
setenv -g TMUX_DATA_DIR "${_TMUX_DATA_DIR}"
setenv -g TMUX_LOG_DIR "${_TMUX_DATA_DIR}/log"

