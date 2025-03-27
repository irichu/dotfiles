# complete in case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=1
eval `dircolors`
export ZLS_COLORS=$LS_COLORS
#zstyle ':completion:*' list-colors ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' verbose yes
