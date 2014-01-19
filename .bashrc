#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color)   color_prompt=yes;;
    lxterminal)    color_promt=yes;;
    rxvt-unicode)  color_promt=yes;;
esac

# Default promt
#PS1='\u \$ '

# Green and short promt for regular users
PS1='\[\e[1;32m\]\$\[\e[0m\] '

# A green and blue prompt for regular users
#PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\] '

# include aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

export PATH="/usr/local/bin:$PATH"

export EDITOR="vim"
export CHROME_BIN="/usr/bin/chromium"

# more for less
export PAGER=less
export LESS=-R # use -X to avoid sending terminal initialization
export LESSCHARSET=UTF-8
export LESS_TERMCAP_mb=$'\033[01;31m'
export LESS_TERMCAP_md=$'\033[01;38;5;74m'
export LESS_TERMCAP_me=$'\033[0m'
export LESS_TERMCAP_se=$'\033[0m'
export LESS_TERMCAP_so=$'\033[38;5;246m'
export LESS_TERMCAP_ue=$'\033[0m'
export LESS_TERMCAP_us=$'\033[04;38;5;146m'

# history
export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd *"
export HISTCONTROL="ignoreboth:erasedups"
export HISTSIZE=1000
export HISTFILESIZE=2000

#source /etc/profile

if [ -f ~/git-completion.sh ]; then
    . ~/git-completion.sh
fi
