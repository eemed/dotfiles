#
# ~/.bashrc
#

[[ $- != *i* ]] && return

# set -o vi

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*|st*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
    alias la='ls --color=auto -lah'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

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
      *.rar)       unrar x $1     ;;
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


# better yaourt colors
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"

export CM_LAUNCHER="rofi"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_USER_CONFIG_DIR="$HOME/.config"
export GTAGSLABEL=pygments

# Wayland java programs
#export _JAVA_AWT_WM_NONREPARENTING=1
## firefox wayland
#export GDK_BACKEND="wayland"

if test -d ~/.fzf ; then
    PATH=$PATH:~/.fzf/bin
    source ~/.fzf/shell/completion.bash
    source ~/.fzf/shell/key-bindings.bash
fi

if test -f ~/.local/bin/z.sh ; then
  . ~/.local/bin/z.sh
fi

if test -f ~/.bashrc_personal ; then
    source ~/.bashrc_personal
fi


export FFF_CD_FILE=~/.fff_d

VISUAL=nvim; export VISUAL EDITOR=nvim; export EDITOR
PAGER=less; export PAGER

function cdl(){ cd $1; ls -l;}

xset r rate 200 30
# export PS1="\[\e[31m\]\u\[\e[m\]\[\e[32m\] \[\e[m\]@ \[\e[33m\]\w\[\e[m\] \$ "
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/.local/lib

stty susp undef
bind '"\C-z":"fg\015"'
export PS1="\[\033[38;5;2m\]\u\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;12m\]\w\[$(tput sgr0)\]\[\033[38;5;7m\] \\$ \[$(tput sgr0)\]"

# Pal to new terminals
if test -f ~/.cache/pal/colors ; then
  { read -r < ~/.cache/pal/colors; printf %b "$REPLY"; } & disown
fi

neovim_bg_control() {
  if test -f ~/.scripts/pal_theme.sh ; then
    local theme=$(~/.scripts/pal_theme.sh)

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
export LESS_TERMCAP_mb=$'\E[6m'          # begin blinking
export LESS_TERMCAP_md=$'\E[37m'         # begin bold
export LESS_TERMCAP_us=$'\E[4;37m'       # begin underline
export LESS_TERMCAP_so=$'\E[1;1;47m\E[1;1;30m'    # begin standout-mode - info box
export LESS_TERMCAP_me=$'\E[0m'          # end mode
export LESS_TERMCAP_ue=$'\E[0m'          # end underline
export LESS_TERMCAP_se=$'\E[0m'          # end standout-mode


# My aliases
alias ll="ls -l"
alias la="ls -l"
alias tmux="env TERM=xterm-256color tmux"
alias stack-ghcid="ghcid --command 'stack ghci'"
alias vim="neovim_bg_control"
alias g="git"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
