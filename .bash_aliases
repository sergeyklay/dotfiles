#!/bin/bash
#
# Bash aliases
#

# enable color support of ls and also add handy aliases
if [ "$colors_support" = true ]; then
  alias ls='LC_COLLATE=C ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias phpunit='phpunit --colors'
fi

# some more ls aliases
alias ll='LC_COLLATE=C ls -alF'
alias la='LC_COLLATE=C ls -A'
alias l='LC_COLLATE=C ls -CF'

# alias for Karma
alias google-chrome='google-chrome-stable'

# clear screen
alias cls=clear

alias xup="xrdb ~/.Xresources"

if command -v docker-compose >/dev/null 2>&1
then
  alias dc="docker-compose"
fi

if command -v docker >/dev/null 2>&1
then
  alias dps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'"
fi

if command -v clojure >/dev/null 2>&1
then
  alias rebel="clojure -A:rebel"
fi

if command -v kubectl >/dev/null 2>&1
then
  alias k='kubectl'
fi

if command -v minikube >/dev/null 2>&1
then
  alias mk='/usr/local/bin/minikube'
fi

# vim:ft=sh:ts=8:sw=2:sts=2:tw=80:et
