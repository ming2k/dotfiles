# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# set -x # Trace command

source ~/.bash/_mixins/ps.bash

# Correct minor spelling mistakes in the `cd` command
shopt -s cdspell
# Enable case sensitivity
shopt -s nocaseglob

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias code='code --ozone-platform=$XDG_SESSION_TYPE'
alias fars='curl -F "c=@-" "http://fars.ee/"'
alias irssi='irssi --home=~/.config/irssi'
alias pquote='sed "s/.*/\"\0\"/"'

# alias less='less -S +G'
# Open the command manual in browser by default
# alias man="man -Hgoogle-chrome-stable"
# alias man="man -Hfirefox"
# unset BROWSER

# Bash completion
[ -f /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

# GPG Config
export GPG_TTY=$(tty)
export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:/home/ming/.local/share/flatpak/exports/share"

# Dev
export NODE_OPTIONS="--no-warnings"

source ~/.bash/_mixins/hist.bash
source ~/.bash/_mixins/fzf.bash
source ~/.bash/_mixins/nnn.bash

gitpkg() {
    if [ -z "$1" ]; then
        echo "Usage: gitpkg package_name"
        return 1
    fi
    
    git clone "https://gitlab.archlinux.org/archlinux/packaging/packages/$1.git" && cd "$1"
}
