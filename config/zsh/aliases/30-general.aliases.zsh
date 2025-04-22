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

# Code
alias cle='code --list-extensions > code-extensions.txt'
alias cie='cat code-extensions.txt | while read extension; do code --install-extension "$extension"; done'

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
alias eS='echo $SHELL'
alias ff='fastfetch'
alias fdH='fd -H -E .git -E .venv -E node_modules'
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
alias peHP='printenv HTTP_PROXY'
alias peHPS='printenv HTTPS_PROXY'
alias pehp='printenv http_proxy'
alias pehps='printenv https_proxy'
alias {peS,peSH}='printenv SHELL'
alias peXST='printenv XDG_SESSION_TYPE'
alias print_xdg_env_home='print_xdg_env | rg HOME'
alias {px,pxe}='print_xdg_env'
#q
alias rmf='rm -rf'
alias uuid='cat /proc/sys/kernel/random/uuid'
alias wi='w -i'
# wakeonlan
alias fwol='ip neigh show | fzf-tmux -p | rg -o "\w{2}(:\w{2}){5}" --engine=auto | read mac_addr; wakeonlan "$mac_addr"'
alias {gwol,swol}='ip neigh show | gum choose | rg -o "\w{2}(:\w{2}){5}" --engine=auto | read mac_addr; wakeonlan "$mac_addr"'
alias wh='which'
alias x='xargs'
alias {xc,:q}='exit'
alias yf='ssh-keygen -yf'
alias yz='yazi'
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
alias tds='tmux detach'
alias tatd='tmux a -t default'
alias tls='tmux ls'
alias tks='tmux kill-server'
alias tkst='tmux kill-session -t'
alias {tid,tidx}='tmux display -pt "${TMUX_PANE:?}" "#{pane_index}"'

# reconnect to session
alias ta0='tmux a -t 0'
alias ta1='tmux a -t 1'
alias ta2='tmux a -t 2'
alias ta3='tmux a -t 3'
alias ta4='tmux a -t 4'
alias ta5='tmux a -t 5'
alias ta6='tmux a -t 6'
alias ta7='tmux a -t 7'
alias ta8='tmux a -t 8'
alias ta9='tmux a -t 9'
alias tad='tmux a -t default'

# select session
alias s0='tmux switch-client -t 0'
alias s1='tmux switch-client -t 1'
alias s2='tmux switch-client -t 2'
alias s3='tmux switch-client -t 3'
alias s4='tmux switch-client -t 4'
alias s5='tmux switch-client -t 5'
alias s6='tmux switch-client -t 6'
alias s7='tmux switch-client -t 7'
alias s8='tmux switch-client -t 8'
alias s9='tmux switch-client -t 9'

# select window
alias w1='tmux select-window -t 1'
alias w2='tmux select-window -t 2'
alias w3='tmux select-window -t 3'
alias w4='tmux select-window -t 4'
alias w5='tmux select-window -t 5'
alias w6='tmux select-window -t 6'
alias w7='tmux select-window -t 7'
alias w8='tmux select-window -t 8'
alias w9='tmux select-window -t 9'

# select pane
alias p1='tmux select-pane -t 1'
alias p2='tmux select-pane -t 2'
alias p3='tmux select-pane -t 3'
alias p4='tmux select-pane -t 4'
alias p5='tmux select-pane -t 5'
alias p6='tmux select-pane -t 6'
alias p7='tmux select-pane -t 7'
alias p8='tmux select-pane -t 8'
alias p9='tmux select-pane -t 9'

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

# git log
alias gl='git log'
alias glg='git log --graph --oneline --all'
alias {gl10,gln10}='git log --oneline -n 10'
alias glo='git log --pretty=format:"%C(auto)%h %C(cyan)%<(8,trunc)%an%C(reset) %C(yellow)%ad%C(reset) %s" --date=format:"%Y-%m-%d %H:%M"'
alias glo5='glo -n 5'
alias glo10='glo -n 10'
alias glo15='glo -n 15'
alias glo20='glo -n 20'

# git switch
alias gsw='git switch'
alias gswm='git switch main'
alias gswd='git switch develop'
alias gswf='git switch feature'
alias gswh='git switch hotfix'
alias gswr='git switch release'

# git status
alias gst='git status'

# git branch
alias gb='git branch'
alias gbv='git branch -vv'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gba='git branch -a'
alias gbm='git branch --merged'
alias gbnm='git branch --no-merged'

# git diff
alias gd='git diff'
alias gdh='git diff HEAD'
alias gdc='git diff --cached'
alias gds='git diff --staged'

# git clone
alias gcl='git clone'
alias gcl1='git clone --max-depth=1'
alias gcp='git cherry-pick'

# git add
alias ga='git add'
alias ga.='git add .'
alias gaA='git add -A'
alias gaA.='git add -A .'
alias gaa='git add --all'
alias gaa.='git add --all .'
alias gau='git add --update'
alias gau.='git add --update .'
alias gai='git add --interactive'
alias gai.='git add --interactive .'
alias gam='git add --modified'
alias gam.='git add --modified .'
alias gac='git add --change'
alias gac.='git add --change .'

# git commit
alias gci='git commit'
alias gcim='git commit -m'
alias gcif='git commit --fixup'
alias gcis='git commit --squash'
alias gcia='git commit --amend'

# git checkout
alias gco='git checkout'
alias gcom='git checkout main'
alias gcod='git checkout develop'
alias gcof='git checkout feature'
alias gcoh='git checkout hotfix'
alias gcor='git checkout release'
alias gco.='git checkout .'
alias gcos='git checkout -'
alias gcob='git checkout -b'

# git mv
alias gmv='git mv'

# git fetch
alias gf='git fetch'
alias gfom='git fetch origin main'
alias gfod='git fetch origin develop'

# git merge
alias gm='git merge'
alias gmff='git merge --ff'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gmt='git merge --no-ff'
alias gmn='git merge --no-ff'

# git pull
alias gpl='git pull'

# git push
alias gps='git push'
alias gpsf='git push --force'
alias gpsu='git push --set-upstream origin'
alias gpsom='git push origin main'
alias gpsod='git push origin develop'

# git rm
alias grm='git rm'

# git remote
alias grao='git remote add origin'
alias gurl='git remote get-url origin'
alias grv='git remote -v'

# git config
alias gcnf='git config --global -e'
alias gcnl='git config --list'
alias gcn='git config --name'
alias gname='git config user.name'
alias gemail='git config user.email'
alias gcue='git config get user.email'
alias gcun='git config get user.name'
alias ng='n ~/.config/git/config'

# git reset
alias grs='git reset'
alias grsh='git reset --hard'
alias grshH='git reset --hard HEAD'
alias grshH~='git reset --hard HEAD~'
alias grshH~1='git reset --hard HEAD~1'
alias grshH~2='git reset --hard HEAD~2'
alias grshH~3='git reset --hard HEAD~3'
alias grshH~4='git reset --hard HEAD~4'
alias grshH~5='git reset --hard HEAD~5'
alias grshH~6='git reset --hard HEAD~6'
alias grshH~7='git reset --hard HEAD~7'
alias grshH~8='git reset --hard HEAD~8'
alias grshH~9='git reset --hard HEAD~9'
alias grss='git reset --soft'
alias grssH='git reset --soft HEAD'
alias grssH~='git reset --soft HEAD~'
alias grssH~1='git reset --soft HEAD~1'
alias grssH~2='git reset --soft HEAD~2'
alias grssH~3='git reset --soft HEAD~3'
alias grssH~4='git reset --soft HEAD~4'
alias grssH~5='git reset --soft HEAD~5'
alias grssH~6='git reset --soft HEAD~6'
alias grssH~7='git reset --soft HEAD~7'
alias grssH~8='git reset --soft HEAD~8'
alias grssH~9='git reset --soft HEAD~9'

# git show
alias gsh='git show'
alias gsh1='git show -1'
alias gsh2='git show -2'
alias gsh3='git show -3'

# git restore
alias grst='git restore'

# git rebase
alias grb='git rebase'
alias grbi='git rebase -i'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'
alias grbs='git rebase --skip'

# git tag
alias gt='git tag'
alias gta='git tag -a' # annotated tag
alias gtd='git tag -d' # delete tag
alias gtl='git tag -l' # list tags
alias gtp='git tag -p' # show tag
alias gts='git tag -s' # signed tag
alias gtv='git tag -v' # verify tag

# git help
alias gh='git help'
alias gha='git help -a'
alias ghd='git help -g'

# git stash
alias gsta='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstd0='git stash drop stash@{0}'
alias gstd1='git stash drop stash@{1}'
alias gstd2='git stash drop stash@{2}'
alias gstd3='git stash drop stash@{3}'
alias gstd4='git stash drop stash@{4}'
alias gstd5='git stash drop stash@{5}'
alias gstd6='git stash drop stash@{6}'
alias gstd7='git stash drop stash@{7}'
alias gstd8='git stash drop stash@{8}'
alias gstd9='git stash drop stash@{9}'
alias gtg='git tag -l | fzf | xargs git show'

# cd
alias c='cd'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias {2..,..2}='cd ../..'
alias {3..,..3}='cd ../../..'
alias {4..,..4}='cd ../../../..'
alias {5..,..5}='cd ../../../../..'
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

# fnm
alias fnls='fnm ls'
alias fnlsr='fnm ls-remote'
alias fnu='fnm use'
alias fnuL='fnm use --lts'
alias fnd='fnm default'
alias fndL='fnm default --lts'
alias fni='fnm install'
alias fniL='fnm install --lts'
alias fnun='fnm uninstall'

# npm
alias ni='npm install'
alias nu='npm update'
alias nr='npm run'
alias nrd='npm run dev'
alias nrt='npm run test'
alias nrb='npm run build'

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
! command -v fd >/dev/null && alias fd='fdfind'
alias r='rg'
alias rgu='rg -u'
alias rguu='rg -uu'

# bat
! command -v bat >/dev/null && alias bat='batcat'
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
alias {et,etree}='e -T'
alias tree='e -T'
alias elt='e -lT'
alias edirs='eza --only-dirs'
alias efiles='eza --only-files'
#alias el='eza --icons --git --time-style relative -al'
alias {s,sane,ssane}='echo "stty sane" && stty sane'
alias ssize='stty size'

# brew
alias bupd='brew update'
alias bupg='brew upgrade'
alias bd='brew doctor'
alias bl='brew list'
alias bcl='brew cleanup'

# dots
alias dt='dots'
alias dth='dots --help'
alias dtv='dots --version'
alias dti='dots install'
alias dtia='dots install --apt'
alias dtis='dots install --snap'
alias dtib='dots install --brew'
alias dtip='dots install --pkg'
alias dtl='dots list'
alias dtla='dots list --apt'
alias dtls='dots list --snap'
alias dtlb='dots list --brew'
alias dtlp='dots list --pkg'
alias dts='dots setup'
alias {dtu,dtup}='dots update'
alias dtb='dots backup'
alias dtc='dots clean'
alias dtcb='dots clean backup'
alias dtcc='dots clean config'
alias dtca='dots clean all'
alias dtdt='dots docker test'
alias dtt='dots theme'
alias dtst='dots set-theme'

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
