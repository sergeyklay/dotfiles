#!/bin/bash
#
# Bash aliases
#

# enable color support of ls and also add handy aliases
if [ "$colors_support" = true ]; then
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

alias vi='emacs -nw'
alias vim='emacs -nw'

# alias for Karma
alias google-chrome='google-chrome-stable'

# clear screen
alias cls=clear

alias xup="xrdb ~/.Xresources"

alias dc="docker-compose"
alias dps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'"

# vim:ft=sh:ts=8:sw=2:sts=2:tw=80:et
