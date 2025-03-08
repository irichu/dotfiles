if command -v eza &>/dev/null; then
  alias ls='eza --icons --git --time-style=iso --group --smart-group'
  alias l='ls -l'
  alias ll='ls -l'
  alias lla='ls -la'
else
  alias ls='ls --color'
  alias l='ls -l --color'
  alias ll='ls -l --color'
  alias lla='ls -la --color'
fi

alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# sudo alias
alias sudo='sudo '

alias h='history 0'
alias h1='history 1'
alias hg='history 0 | grep'
alias hrg='history 0 | ripgrep'
alias hr='echo "--------------------------------------------"'

# apt
alias agi='sudo apt install'
alias agiy='sudo apt install -y'
alias agl='apt list'
alias agli='apt list --installed'
alias aglu='apt list --upgradable'
alias agu='sudo apt update'
alias agg='sudo apt upgrade'
alias aggy='sudo apt upgrade -y'
alias ags='sudo apt show'
alias agr='sudo apt remove'
alias aga='sudo apt autoremove'
alias agc='sudo apt clean'

# dnf
alias dni='sudo dnf install'
alias dnu='sudo dnf update'
alias dnus='sudo dnf update --security'
alias dnr='sudo dnf remove'
alias dnca='sudo dnf clean all'
alias dnh='sudo dnf history'
alias dnhi='sudo dnf history info'
alias dnhu='sudo dnf history undo'
alias dnhr='sudo dnf history redo'

# pkg
alias pin='pkg install'
alias pup='pkg upgrade'
alias pun='pkg uninstall'
alias pac='pkg autoclean'
alias pcl='pkg clean'
alias pfi='pkg files'
alias pla='pkg list-all'
alias pli='pkg list-installed'
alias pre='pkg reinstall'
alias pse='pkg search'
alias psh='pkg show'

alias ba='nvim ~/.bash_aliases'
alias bb='bottom -b || btm -b'
alias cl='clear'
if [ -z $TERMUX_VERSION ]; then
  alias {c,clip}='xsel --clipboard --input'
else
  alias {c,clip}='termux-clipboard-set'
fi
if [ -z $TERMUX_VERSION ]; then
  alias pp='xsel --clipboard --output'
else
  alias pp='termux-clipboard-get'
fi
alias d='docker'
alias dc='docker compose'
alias de='n=$(docker ps --format "IMAGE:{{.Image}}, NAME: {{.Names}}" | fzf-tmux -p --reverse | awk '\''{print $NF}'\'') && docker exec -it $n /bin/zsh'
alias dil='docker image ls'
alias dcl='docker container ls'
alias dbt='docker build . -t'
alias dri='docker run -it'

alias duh='du -h -d 1 | sort -hr'
alias dfth='df -Th'
#alias dush='du -sh | sort -hr'
alias dt='date "+%F %T"'
alias es='echo $SHELL'
alias ff='fastfetch'
alias hn='uname -n'
alias ipa='ip -o a'
alias j='jobs'
alias k9='kill -9'
alias lp='echo $PATH | tr ":" "\n"'
alias lps='echo $PATH | tr ":" "\n" | sort'
alias lfp='echo $FPATH | tr ":" "\n"'
alias lfps='echo $FPATH | tr ":" "\n" | sort'
alias mt='multitail'
alias os='bat /etc/os-release'
alias ua='uname -a'
alias un='uname -n'
# alias o='openssl rand 32 | base64'
alias o='openssl rand --base64 32'
alias p='pwd'
alias pe='printenv'
#q
alias rmf='rm -rf'
alias uuid='cat /proc/sys/kernel/random/uuid'
alias wi='w -i'
alias wh='which'
alias x='xargs'
alias {xc,:q}='exit'
alias yf='ssh-keygen -yf'
#z

# system
alias po='sudo /usr/sbin/poweroff'
#alias sc='sudo systemctl'
alias sdaemon='sudo systemctl daemon-reload'
alias senable='sudo systemctl enable'
alias sdisable='sudo systemctl disable'
alias sstart='sudo systemctl start'
alias srestart='sudo systemctl restart'
alias sstop='sudo systemctl stop'
alias sreload='sudo systemctl reload'
alias sstatus='sudo systemctl status'

# apt
alias u='sudo apt update && sudo apt upgrade'
alias uy='sudo apt update && sudo apt upgrade -y'

# tmux
alias tmux='tmux -u'
alias t='tmux'
alias tn='tmux new'
alias tns='tmux new -s'
alias tns='tmux new -s default'
alias ta='tmux a'
alias tat='tmux a -t'
alias tas='[ -z $TMUX ] && t a -t $(t ls | fzf | cut -d: -f1) || t switchc -t $(t ls | fzf-tmux -p | cut -d: -f1)'
alias tat0='tmux a -t 0'
alias tatd='tmux a -t default'
alias tls='tmux ls'
alias tks='tmux kill-server'
alias tkst='tmux kill-session -t'
alias {tid,tidx}='tmux display -pt "${TMUX_PANE:?}" "#{pane_index}"'

# snap
alias si='sudo snap install'
alias sic='sudo snap install --classic'
alias sr='sudo snap refresh'
alias srl='sudo snap refresh --list'
alias sls='sudo snap list'
alias srm='sudo snap remove'

# starship
alias us='curl -sS https://starship.rs/install.sh | sh'
alias sv='starship --version'
alias snn='starship preset no-nerd-font -o ~/.config/starship.toml'

# git
alias g='git'
alias gi='git init'
alias gl='git log'
alias glg='git log --graph --oneline --all'
alias gsw='git switch'
alias gswm='git switch main'
alias gswd='git switch develop'
alias gswf='git switch feature'
alias gswh='git switch hotfix'
alias gswr='git switch release'
alias gst='git status'
alias gb='git branch'
alias gbv='git branch -vv'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gba='git branch -a'
alias gbm='git branch --merged'
alias gbnm='git branch --no-merged'
alias gd='git diff'
alias gdh='git diff HEAD'
alias gdc='git diff --cached'
alias gds='git diff --staged'
alias gcl='git clone'
alias gcp='git cherry-pick'
alias ga='git add'
alias gmv='git mv'
alias gci='git commit'
alias gcim='git commit -m'
alias gcif='git commit --fixup'
alias gcis='git commit --squash'
alias gcia='git commit --amend'
alias gco='git checkout'
alias gcom='git checkout main'
alias gcod='git checkout develop'
alias gcof='git checkout feature'
alias gcoh='git checkout hotfix'
alias gcor='git checkout release'
alias gco.='git checkout .'
alias gcos='git checkout -'
alias gcob='git checkout -b'
alias gf='git fetch'
alias gfom='git fetch origin main'
alias gfod='git fetch origin develop'
alias gm='git merge'
alias gmff='git merge --ff'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gmt='git merge --no-ff'
alias gmn='git merge --no-ff'
alias gpl='git pull'
alias gps='git push'
alias gpsf='git push --force'
alias gpsu='git push --set-upstream origin'
alias gpsom='git push origin main'
alias gpsod='git push origin develop'
alias grm='git rm'
alias grao='git remote add origin'
alias gurl='git remote get-url origin'
alias grv='git remote -v'
alias gcnf='git config --global -e'
alias gcnl='git config --list'
alias gcn='git config --name'

# cd
alias c='cd'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'
alias _='cd -'

# mkdir
alias md='mkdir'
alias mdp='md -p'
alias mdc='mkdircd' # mkdir && cd $_ function

# hidden file
alias .b='source ~/.bashrc'
alias .v='[ -f .venv/bin/activate ] && source .venv/bin/activate'
alias .t='tmux source ~/.config/tmux/tmux.conf'
alias .z='source ~/.config/zsh/.zshrc'
alias .zz='exec -l $(which zsh)'

# zellij
alias zj='zellij'
alias zjc='zj --layout=compact'
alias zid='echo $ZELLIJ_PANE_ID'
alias {zjs,zjstart}='zj attach default || zj -s default'
alias {zjcs,zjcstart}='zjc attach default || zj -s default'
alias zjda='zj delete-all-sessions'
alias zjka='zj kill-all-sessions'
alias zjls='zj list-sessions'

# zsh
alias vz='vim ~/.config/zsh/.zshrc'
alias nz='nvim ~/.config/zsh/.zshrc'
alias nza='nvim ~/.config/zsh/.zsh_aliases'
alias ztime='time zsh -i -c exit'

# python
alias py='python3'
alias pv='py -m venv .venv'
alias va='source .venv/bin/activate'
alias pu='pip install --upgrade pip'

# uv
alias upy='uv python'
alias upip='uv pip'

alias lzd='lazydocker'
alias lzg='lazygit'

# neovim
alias n='nvim'
alias ns='nvim --startuptime ~/.local/state/nvim/startuptime.log +q; tail -n2 ~/.local/state/nvim/startuptime.log | cut -d " " -f1 | head -n1 | read s; echo "neovim startuptime: $s ms"'
alias view='nvim -R'

# vim
alias vs='vim --startuptime ~/.vim/startuptime.log +q ; tail -n1 ~/.vim/startuptime.log | cut -d " " -f1 | read s; echo "vim startuptime: $s ms"'
alias vn='vim -u NONE -N' # -N: -c "set nocompatible"

# posh
# alias ou='sudo oh-my-posh upgrade'

# find
alias f='find ./ -name'
! command -v fd > /dev/null && alias fd='fdfind'
alias r='rg'
alias rgu='rg -u'
alias rguu='rg -uu'

# bat
! command -v bat > /dev/null && alias bat='batcat'
alias b='bat'
alias bathelp='bat --plain --language=help'

# combination
alias v='fd --type f --hidden --exclude .git | fzf-tmux -p | xargs -o nvim'
alias vv='nvim $(fd -t f -H -E .git | fzf-tmux -p)'
alias cdf='cd $(fd -t d | fzf --height 50% --layout=reverse --border --inline-info --preview "eza -F -1 {}")'

# duf
alias dufl='duf -only=local'

# eza
#alias e='eza --icons --git --time-style +"%Y-%m-%d %H:%M" --group --smart-group'
alias e='eza --icons --git --time-style=iso --group --smart-group'
alias el='e -la'
alias et='e -T'
alias elt='e -lT'
#alias el='eza --icons --git --time-style relative -al'
alias s='stty sane'
alias ssize='stty size'

# brew
alias bupd='brew update'
alias bupg='brew upgrade'
alias bd='brew doctor'
alias bl='brew list'
alias bcl='brew cleanup'

if [ -n $TERMUX_VERSION ]; then
  alias pki='pkg i'
  alias pku='pkg up'
  alias pkr='pkg uninstall'
  alias pka='pkg autoclean'
  alias pkc='pkg clean'
  alias pklsa='pkg list-all'
  alias pklsi='pkg list-installed'
  alias pkse='pkg search'
  alias pksh='pkg show'
  alias pkf='pkg files'
  alias pkre='pkg reinstall'
fi

