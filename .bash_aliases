#!/bin/bash
#
# Bash aliases
#

# enable color support of ls and also add handy aliases
if [ "$colors_support" = true ]
then
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias phpunit='phpunit --colors'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# alias for Karma
alias google-chrome='google-chrome-stable'

# be more cultured at work in the console`
alias please=sudo

# clear screen
alias cls=clear

alias xup="xrdb ~/.Xresources"


# Function to deal with the annoying sublime errors
# Send annoying .output logs to /dev/null
function _sblm
{
  nohup subl $1 >/dev/null 2>&1 &
}

alias subl="_sblm"

# Add an "alert" alias for long running commands.
# Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Useful usage:
# psgrep <appname> | awk '{print $2}' | xargs kill
function _psgrep
{
  if [ -z $1 ]; then
    echo -e "Usage: psgrep <appname> | awk '{print \$2}' | xargs kill"
    exit 2
  fi

  ps aux | grep $1 | grep -v grep
}

alias psgrep="_psgrep"

# vim:ft=sh:ts=8:sw=2:sts=2:tw=80:et
