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

# Add RVM to PATH for scripting
if [ -d "$HOME/.rvm/bin" ]; then
  PATH="$PATH:$HOME/.rvm/bin"
fi

# Include local bin
if [ -d "$HOME/bin" ] ; then
  PATH="$PATH:$HOME/bin"
fi

# Phpenv
if [ -d "$HOME/.phpenv/bin" ]; then
  PATH="$PATH:$HOME/.phpenv/bin"
  eval "$(phpenv init -)"
fi

# Phalcon
if [ -d "$HOME/projects/php/phalcon/devtools" ]; then
  export PTOOLSPATH="$HOME/projects/php/phalcon/devtools"
  PATH="$PATH:$PTOOLSPATH"
fi

# Composer
if [ -d "$HOME/.composer" ]; then
  export COMPOSER_HOME="$HOME/.composer"
  PATH="$PATH:$COMPOSER_HOME"
fi

if [ -d "$HOME/.composer/vendor/bin" ]; then
  PATH="$PATH:$HOME/.composer/vendor/bin"
fi

# Load RVM into a shell session *as a function*
if [ -s "$HOME/.rvm/scripts/rvm" ]; then
  . "$HOME/.rvm/scripts/rvm"
fi

# vim:ft=sh:ts=8:sw=2:sts=2:tw=80:et
