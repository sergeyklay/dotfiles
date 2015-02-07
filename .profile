#!/bin/bash

#
# Bash profile
#

# include .bashrc if it exists
if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# Local run (per user) of mpd
if [ ! -s "$HOME/.config/mpd/pid" ]; then
  mpd
fi

# Include local bin
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.phpenv/bin" ]; then
  PATH="$PATH:$HOME/.phpenv/bin"
  eval "$(phpenv init -)"
fi

# Add RVM to PATH for scripting
if [ -d "$HOME/.rvm/bin" ]; then
  PATH="$PATH:$HOME/.rvm/bin"
fi

# Phalcon
if [ -d "$HOME/projects/php/phalcon/devtools" ]; then
  export PTOOLSPATH="$HOME/projects/php/phalcon/devtools"
  PATH="$PATH:$PTOOLSPATH"
fi

# Load RVM into a shell session *as a function*
if [ -f "$HOME/.rvm/scripts/rvm" ]; then
  . "$HOME/.rvm/scripts/rvm"
fi

# vim:ft=sh:ts=8:sw=2:sts=2:tw=80:et
