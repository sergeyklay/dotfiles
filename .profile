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
  PATH=$HOME/bin:$PATH
fi

# Add rbenv to PATH for scripting
if [ -d "$HOME/.rbenv/bin" ]; then
  PATH=$HOME/.rbenv/bin:$PATH
  # Load rbenv
  eval "$(rbenv init -)"

  # Vim setup
  export RUBY_BIN=$(rbenv which ruby | sed 's/ruby$//')
fi

# Phalcon
if [ -d "$HOME/projects/php/phalcon/devtools" ]; then
  export PTOOLSPATH="$HOME/projects/php/phalcon/devtools"
  PATH+=:$PTOOLSPATH
fi

# Zephir
if [ -d "/usr/share/zephir" ]; then
  export ZEPHIRDIR="/usr/share/zephir"
fi

# Add phpenv to PATH
if [ -d "$HOME/.phpenv/bin" ]; then
  PATH+=:$HOME/.phpenv/bin
  # Load phpenv
  eval "$(phpenv init -)"
fi

# Composer
if [ -d "$HOME/.composer" ]; then
  export COMPOSER_HOME="$HOME/.composer"
  PATH+=:$COMPOSER_HOME
fi

if [ -d "$HOME/.composer/vendor/bin" ]; then
  PATH+=:$HOME/.composer/vendor/bin
fi

# Go & local workspace
if [ -d "/usr/local/go/bin" ]; then
  export GOROOT="/usr/local/go"
  PATH+=:$GOROOT/bin
fi

if [ -d "$HOME/go" ]; then
  export GOPATH="$HOME/go"

  if [ -d "$GOPATH/bin" ]; then
    export GOBIN="$GOPATH/bin"
    PATH+=:$GOBIN
  fi
fi

# Enable phpbrew
if [ -e "$HOME/.phpbrew/bashrc" ]; then
  source "$HOME/.phpbrew/bashrc"
  export PHPBREW_SET_PROMPT=1
fi

# Keyboard input sometimes is blocked when IBus is active
# See https://goo.gl/i5dhrY
export IBUS_ENABLE_SYNC_MODE=1

# vim:ft=sh:ts=8:sw=2:sts=2:tw=80:et
