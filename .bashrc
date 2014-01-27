# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Save all strings of multiline commands in the same history entry
shopt -s cmdhist

# man -P 'less -rp HISTCONTROL' bash
HISTCONTROL="ignoreboth:erasedups"
# amount of commands that need to remember in the history list
HISTSIZE=10000
# maximum file size
HISTFILESIZE=20000
# for the protection and ability for future analyzing
HISTTIMEFORMAT="%h %d %H:%M:%S "
# save commands immediately after use
PROMPT_COMMAND='history -a'

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "`dircolors -b`"
    # Design prompt
    PS1="\[\033[1;35m\]%\[\033[00m\] \[\033[1;34m\]\w\[\033[00m\] "
else
    # Default promt
    PS1='% \w '
fi

# include aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# ruby path
if [ -d "$HOME/.gem/ruby/2.0.0/bin" ]; then
    PATH="$HOME/.gem/ruby/2.0.0/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

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

# font config
export GDK_USE_XFT=1
export QT_XFT=true

export XDG_CONFIG_HOME="$HOME/.config"

# Git completion
if [ -f ~/git-completion.sh ]; then
    . ~/git-completion.sh
fi
