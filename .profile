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


# Include local bin
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# Add rbenv to PATH for scripting
if [ -d "$HOME/.rbenv/bin" ]; then
  PATH="$HOME/.rbenv/bin:$PATH"
  # Load rbenv
  eval "$(rbenv init -)"

  # Vim setup
  export RUBY_BIN=$(rbenv which ruby | sed 's/ruby$//')
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

# vim:ft=sh:ts=8:sw=2:sts=2:tw=80:et
