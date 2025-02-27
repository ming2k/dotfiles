source ~/.bash/git-prompt.sh

# Git prompt configuration
export GIT_PS1_SHOWDIRTYSTATE=1      # Shows '*' for unstaged changes and '+' for staged ones
export GIT_PS1_SHOWSTASHSTATE=1      # Shows '$' if there are stashed changes
export GIT_PS1_SHOWUNTRACKEDFILES=1  # Shows '%' if there are untracked files

# Plain Prompt String
# PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# Git Prompt Setting
# PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(__git_ps1)\[\033[00m\]\n\$ '
PS1='\
\[\033[01;32m\]\u@\h\
\[\033[00m\]:\
\[\033[01;34m\]\w\
\[\033[33m\]$(__git_ps1)\
\[\033[00m\]\n\$ '

function prompt_command {
    # Append current session's command history to the history file 
    history -a;
    # -c: Clears the current session's command history from memory
    # -r: Reads the history file back into the current session
    # history -a; history -c; history -r;
    echo -ne "\033]0;$USER@$(uname -n):$(basename "$PWD")\007\033[ q";
}

PROMPT_COMMAND=prompt_command

