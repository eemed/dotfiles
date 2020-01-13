#
# ~/.bashrc
#

[[ $- != *i* ]] && return

# Vim mode
set -o vi

# Completion
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize
shopt -s expand_aliases
# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# Change the window title of X terminals
case ${TERM} in
    xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*|st*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
        ;;
    screen*)
        PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
        ;;
esac

# Remove ctrl+s freeze
stty susp undef

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less
alias ls='ls --color=auto'
alias la='ls --color=auto -lah'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"
export CM_LAUNCHER="rofi"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_USER_CONFIG_DIR="$HOME/.config"

# c-z to fg
bind '"\C-z":"fg\015"'
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/.local/lib

# Prompt
# export PS1="\[\033[38;5;2m\]\u\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;12m\]\w\[$(tput sgr0)\]\[\033[38;5;7m\] \\$ \[$(tput sgr0)\]"
export PS1="${debian_chroot:+($debian_chroot)}[\[\033[01;32m\]\u@\h\[\033[0 0m\] \[\033[01;34m\]\w\[\033[00m\]]\$ "

# Default editor and pager
VISUAL=nvim; export VISUAL EDITOR=nvim; export EDITOR
PAGER=less; export PAGER

# Set colors on new terminals
if test -f ~/.cache/paleta/colors ; then
  { read -r < ~/.cache/paleta/colors; printf %b "$REPLY"; } & disown
fi

neovim_bg_control() {
  if test -f ~/.scripts/paleta-current-theme.sh ; then
    local theme=$(~/.scripts/paleta-current-theme.sh)

    if [ $theme = "light" ]; then
    env VIM_THEME="light" nvim "$@"
    else
      nvim "$@"
    fi
  else
    nvim "$@"
  fi
  return $?
}

# Less
export LESS_TERMCAP_mb=$'\E[6m'                # begin blinking
export LESS_TERMCAP_md=$'\E[37m'               # begin bold
export LESS_TERMCAP_us=$'\E[4;37m'             # begin underline
export LESS_TERMCAP_so=$'\E[1;1;47m\E[1;1;30m' # begin standout-mode - info box
export LESS_TERMCAP_me=$'\E[0m'                # end mode
export LESS_TERMCAP_ue=$'\E[0m'                # end underline
export LESS_TERMCAP_se=$'\E[0m'                # end standout-mode

# My aliases
alias ll="ls -l"
alias la="ls -l"
alias tmux="env TERM=xterm-256color tmux"
alias stack-ghcid="ghcid --command 'stack ghci'"
alias vim="neovim_bg_control"
alias g="git"
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias hgrep="history | grep --color=auto"
function cdl(){ cd $1; ls -l;}

# Keyboard
xset r rate 200 30

if test -f ~/.bashrc_personal ; then
    source ~/.bashrc_personal
fi

if test -d ~/.fzf ; then
    PATH=$PATH:~/.fzf/bin
    source ~/.fzf/shell/completion.bash
    source ~/.fzf/shell/key-bindings.bash
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Setup gpg-agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null
