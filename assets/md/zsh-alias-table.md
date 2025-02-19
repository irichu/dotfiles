| ls              | `eza --icons --git --time-style=iso --group --smart-group`                                                                                                                       |
| l               | `ls -l`                                                                                                                                                                          |
| ll              | `ls -l`                                                                                                                                                                          |
| lla             | `ls -la`                                                                                                                                                                         |
| ls              | `ls --color`                                                                                                                                                                     |
| l               | `ls -l --color`                                                                                                                                                                  |
| ll              | `ls -l --color`                                                                                                                                                                  |
| lla             | `ls -la --color`                                                                                                                                                                 |
| dir             | `dir --color=auto`                                                                                                                                                               |
| vdir            | `vdir --color=auto`                                                                                                                                                              |
| grep            | `grep --color=auto`                                                                                                                                                              |
| fgrep           | `fgrep --color=auto`                                                                                                                                                             |
| egrep           | `egrep --color=auto`                                                                                                                                                             |
| sudo            | `sudo `                                                                                                                                                                          |
| h               | `history 0`                                                                                                                                                                      |
| hg              | `history 0 | grep`                                                                                                                                                               |
| agi             | `sudo apt install`                                                                                                                                                               |
| agu             | `sudo apt update`                                                                                                                                                                |
| agg             | `sudo apt upgrade`                                                                                                                                                               |
| ags             | `sudo apt show`                                                                                                                                                                  |
| agr             | `sudo apt remove`                                                                                                                                                                |
| aga             | `sudo apt autoremove`                                                                                                                                                            |
| dni             | `sudo dnf install`                                                                                                                                                               |
| dnu             | `sudo dnf update`                                                                                                                                                                |
| dnus            | `sudo dnf update --security`                                                                                                                                                     |
| dnr             | `sudo dnf remove`                                                                                                                                                                |
| dnca            | `sudo dnf clean all`                                                                                                                                                             |
| dnh             | `sudo dnf history`                                                                                                                                                               |
| dnhi            | `sudo dnf history info`                                                                                                                                                          |
| dnhu            | `sudo dnf history undo`                                                                                                                                                          |
| dnhr            | `sudo dnf history redo`                                                                                                                                                          |
| pin             | `pkg install`                                                                                                                                                                    |
| pup             | `pkg upgrade`                                                                                                                                                                    |
| pun             | `pkg uninstall`                                                                                                                                                                  |
| pac             | `pkg autoclean`                                                                                                                                                                  |
| pcl             | `pkg clean`                                                                                                                                                                      |
| pfi             | `pkg files`                                                                                                                                                                      |
| pla             | `pkg list-all`                                                                                                                                                                   |
| pli             | `pkg list-installed`                                                                                                                                                             |
| pre             | `pkg reinstall`                                                                                                                                                                  |
| pse             | `pkg search`                                                                                                                                                                     |
| psh             | `pkg show`                                                                                                                                                                       |
| ba              | `nvim ~/.bash_aliases`                                                                                                                                                           |
| bb              | `bottom -b || btm -b`                                                                                                                                                            |
| cl              | `clear`                                                                                                                                                                          |
| {c,clip}        | `xsel --clipboard --input`                                                                                                                                                       |
| {c,clip}        | `termux-clipboard-set`                                                                                                                                                           |
| pp              | `xsel --clipboard --output`                                                                                                                                                      |
| pp              | `termux-clipboard-get`                                                                                                                                                           |
| d               | `docker`                                                                                                                                                                         |
| dc              | `docker compose`                                                                                                                                                                 |
| de              | `n=$(docker ps --format "IMAGE:{{.Image}}, NAME: {{.Names}}" | fzf-tmux -p --reverse | awk `\``{print $NF}`\``) && docker exec -it $n /bin/zsh`                                  |
| dil             | `docker image ls`                                                                                                                                                                |
| dcl             | `docker container ls`                                                                                                                                                            |
| dbt             | `docker build . -t`                                                                                                                                                              |
| dri             | `docker run -it`                                                                                                                                                                 |
| duh             | `du -h -d 1 | sort -hr`                                                                                                                                                          |
| dfth            | `df -Th`                                                                                                                                                                         |
| dt              | `date "+%F %T"`                                                                                                                                                                  |
| es              | `echo $SHELL`                                                                                                                                                                    |
| ff              | `fastfetch`                                                                                                                                                                      |
| hn              | `uname -n`                                                                                                                                                                       |
| ipa             | `ip -o a`                                                                                                                                                                        |
| j               | `jobs`                                                                                                                                                                           |
| k9              | `kill -9`                                                                                                                                                                        |
| lp              | `echo $PATH | tr ":" "\n"`                                                                                                                                                       |
| lps             | `echo $PATH | tr ":" "\n" | sort`                                                                                                                                                |
| lfp             | `echo $FPATH | tr ":" "\n"`                                                                                                                                                      |
| lfps            | `echo $FPATH | tr ":" "\n" | sort`                                                                                                                                               |
| mt              | `multitail`                                                                                                                                                                      |
| os              | `bat /etc/os-release`                                                                                                                                                            |
| ua              | `uname -a`                                                                                                                                                                       |
| un              | `uname -n`                                                                                                                                                                       |
| o               | `openssl rand --base64 32`                                                                                                                                                       |
| p               | `pwd`                                                                                                                                                                            |
| pe              | `printenv`                                                                                                                                                                       |
| rmf             | `rm -rf`                                                                                                                                                                         |
| uuid            | `cat /proc/sys/kernel/random/uuid`                                                                                                                                               |
| wi              | `w -i`                                                                                                                                                                           |
| wh              | `which`                                                                                                                                                                          |
| x               | `xargs`                                                                                                                                                                          |
| {xc,:q}         | `exit`                                                                                                                                                                           |
| yf              | `ssh-keygen -yf`                                                                                                                                                                 |
| po              | `sudo /usr/sbin/poweroff`                                                                                                                                                        |
| sdaemon         | `sudo systemctl daemon-reload`                                                                                                                                                   |
| senable         | `sudo systemctl enable`                                                                                                                                                          |
| sdisable        | `sudo systemctl disable`                                                                                                                                                         |
| sstart          | `sudo systemctl start`                                                                                                                                                           |
| srestart        | `sudo systemctl restart`                                                                                                                                                         |
| sstop           | `sudo systemctl stop`                                                                                                                                                            |
| sreload         | `sudo systemctl reload`                                                                                                                                                          |
| sstatus         | `sudo systemctl status`                                                                                                                                                          |
| u               | `sudo apt update && sudo apt upgrade`                                                                                                                                            |
| uy              | `sudo apt update && sudo apt upgrade -y`                                                                                                                                         |
| tmux            | `tmux -u`                                                                                                                                                                        |
| t               | `tmux`                                                                                                                                                                           |
| tn              | `tmux new`                                                                                                                                                                       |
| tns             | `tmux new -s`                                                                                                                                                                    |
| tns             | `tmux new -s default`                                                                                                                                                            |
| ta              | `tmux a`                                                                                                                                                                         |
| tat             | `tmux a -t`                                                                                                                                                                      |
| tas             | `[ -z $TMUX ] && t a -t $(t ls | fzf | cut -d: -f1) || t switchc -t $(t ls | fzf-tmux -p | cut -d: -f1)`                                                                         |
| tat0            | `tmux a -t 0`                                                                                                                                                                    |
| tatd            | `tmux a -t default`                                                                                                                                                              |
| tls             | `tmux ls`                                                                                                                                                                        |
| tks             | `tmux kill-server`                                                                                                                                                               |
| tkst            | `tmux kill-session -t`                                                                                                                                                           |
| {tid,tidx}      | `tmux display -pt "${TMUX_PANE:?}" "#{pane_index}"`                                                                                                                              |
| si              | `sudo snap install`                                                                                                                                                              |
| sic             | `sudo snap install --classic`                                                                                                                                                    |
| sr              | `sudo snap refresh`                                                                                                                                                              |
| srl             | `sudo snap refresh --list`                                                                                                                                                       |
| sls             | `sudo snap list`                                                                                                                                                                 |
| srm             | `sudo snap remove`                                                                                                                                                               |
| us              | `curl -sS https://starship.rs/install.sh | sh`                                                                                                                                   |
| sv              | `starship --version`                                                                                                                                                             |
| snn             | `starship preset no-nerd-font -o ~/.config/starship.toml`                                                                                                                        |
| g               | `git`                                                                                                                                                                            |
| gi              | `git init`                                                                                                                                                                       |
| gsw             | `git switch`                                                                                                                                                                     |
| gst             | `git status`                                                                                                                                                                     |
| gb              | `git branch`                                                                                                                                                                     |
| gd              | `git diff`                                                                                                                                                                       |
| ga              | `git add`                                                                                                                                                                        |
| gmv             | `git mv`                                                                                                                                                                         |
| gci             | `git commit`                                                                                                                                                                     |
| gcim            | `git commit -m`                                                                                                                                                                  |
| gco             | `git checkout`                                                                                                                                                                   |
| gf              | `git fetch`                                                                                                                                                                      |
| gm              | `git merge`                                                                                                                                                                      |
| gmn             | `git merge --no-ff`                                                                                                                                                              |
| gpl             | `git pull`                                                                                                                                                                       |
| gps             | `git push`                                                                                                                                                                       |
| gpsom           | `git push origin main`                                                                                                                                                           |
| gpsod           | `git push origin develop`                                                                                                                                                        |
| grm             | `git rm`                                                                                                                                                                         |
| grao            | `git remote add origin`                                                                                                                                                          |
| gurl            | `git remote get-url origin`                                                                                                                                                      |
| c               | `cd`                                                                                                                                                                             |
| ..              | `cd ..`                                                                                                                                                                          |
| ...             | `cd ../..`                                                                                                                                                                       |
| ....            | `cd ../../..`                                                                                                                                                                    |
| ..2             | `cd ../..`                                                                                                                                                                       |
| ..3             | `cd ../../..`                                                                                                                                                                    |
| ..4             | `cd ../../../..`                                                                                                                                                                 |
| ..5             | `cd ../../../../..`                                                                                                                                                              |
| _               | `cd -`                                                                                                                                                                           |
| md              | `mkdir`                                                                                                                                                                          |
| mdp             | `md -p`                                                                                                                                                                          |
| mdc             | `mkdircd` # mkdir && cd $_ function                                                                                                                                              |
| .b              | `source ~/.bashrc`                                                                                                                                                               |
| .v              | `[ -f .venv/bin/activate ] && source .venv/bin/activate`                                                                                                                         |
| .t              | `tmux source ~/.config/tmux/tmux.conf`                                                                                                                                           |
| .z              | `source ~/.config/zsh/.zshrc`                                                                                                                                                    |
| .zz             | `exec -l $(which zsh)`                                                                                                                                                           |
| zj              | `zellij`                                                                                                                                                                         |
| zjc             | `zj --layout=compact`                                                                                                                                                            |
| zid             | `echo $ZELLIJ_PANE_ID`                                                                                                                                                           |
| {zjs,zjstart}   | `zj attach default || zj -s default`                                                                                                                                             |
| {zjcs,zjcstart} | `zjc attach default || zj -s default`                                                                                                                                            |
| zjda            | `zj delete-all-sessions`                                                                                                                                                         |
| zjka            | `zj kill-all-sessions`                                                                                                                                                           |
| zjls            | `zj list-sessions`                                                                                                                                                               |
| vz              | `vim ~/.config/zsh/.zshrc`                                                                                                                                                       |
| nz              | `nvim ~/.config/zsh/.zshrc`                                                                                                                                                      |
| nza             | `nvim ~/.config/zsh/.zsh_aliases`                                                                                                                                                |
| ztime           | `time zsh -i -c exit`                                                                                                                                                            |
| py              | `python3`                                                                                                                                                                        |
| pv              | `py -m venv .venv`                                                                                                                                                               |
| va              | `source .venv/bin/activate`                                                                                                                                                      |
| pu              | `pip install --upgrade pip`                                                                                                                                                      |
| upy             | `uv python`                                                                                                                                                                      |
| upip            | `uv pip`                                                                                                                                                                         |
| lzd             | `lazydocker`                                                                                                                                                                     |
| lzg             | `lazygit`                                                                                                                                                                        |
| n               | `nvim`                                                                                                                                                                           |
| ns              | `nvim --startuptime ~/.local/state/nvim/startuptime.log +q; tail -n2 ~/.local/state/nvim/startuptime.log | cut -d " " -f1 | head -n1 | read s; echo "neovim startuptime: $s ms"` |
| view            | `nvim -R`                                                                                                                                                                        |
| vs              | `vim --startuptime ~/.vim/startuptime.log +q ; tail -n1 ~/.vim/startuptime.log | cut -d " " -f1 | read s; echo "vim startuptime: $s ms"`                                         |
| vn              | `vim -u NONE -N` # -N: -c "set nocompatible"                                                                                                                                     |
| f               | `find ./ -name`                                                                                                                                                                  |
| fd              | `fdfind`                                                                                                                                                                         |
| r               | `rg`                                                                                                                                                                             |
| rgu             | `rg -u`                                                                                                                                                                          |
| rguu            | `rg -uu`                                                                                                                                                                         |
| bat             | `batcat`                                                                                                                                                                         |
| b               | `bat`                                                                                                                                                                            |
| bathelp         | `bat --plain --language=help`                                                                                                                                                    |
| v               | `fd --type f --hidden --exclude .git | fzf-tmux -p | xargs -o nvim`                                                                                                              |
| vv              | `nvim $(fd -t f -H -E .git | fzf-tmux -p)`                                                                                                                                       |
| cdf             | `cd $(fd -t d | fzf --height 50% --layout=reverse --border --inline-info --preview "eza -F -1 {}")`                                                                              |
| dufl            | `duf -only=local`                                                                                                                                                                |
| e               | `eza --icons --git --time-style=iso --group --smart-group`                                                                                                                       |
| el              | `e -la`                                                                                                                                                                          |
| et              | `e -T`                                                                                                                                                                           |
| elt             | `e -lT`                                                                                                                                                                          |
| s               | `stty sane`                                                                                                                                                                      |
| ssize           | `stty size`                                                                                                                                                                      |
| bupd            | `brew update`                                                                                                                                                                    |
| bupg            | `brew upgrade`                                                                                                                                                                   |
| bd              | `brew doctor`                                                                                                                                                                    |
| bl              | `brew list`                                                                                                                                                                      |
| bcl             | `brew cleanup`                                                                                                                                                                   |
| pki             | `pkg i`                                                                                                                                                                          |
| pku             | `pkg up`                                                                                                                                                                         |
| pkr             | `pkg uninstall`                                                                                                                                                                  |
| pka             | `pkg autoclean`                                                                                                                                                                  |
| pkc             | `pkg clean`                                                                                                                                                                      |
| pklsa           | `pkg list-all`                                                                                                                                                                   |
| pklsi           | `pkg list-installed`                                                                                                                                                             |
| pkse            | `pkg search`                                                                                                                                                                     |
| pksh            | `pkg show`                                                                                                                                                                       |
