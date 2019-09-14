#!/bin/bash

#
# Bash profile
#

source "$HOME/profile.d/functions.sh"
source "$HOME/profile.d/docker-tools.sh"

# Sane defaults
pathmunge "/usr/sbin"
pathmunge "/usr/local/bin"

# See ~/.Xresources
if [ -x "$(command -v xscreensaver 2>/dev/null)" ]
then
  [ ! -d $HOME/log ] && mkdir -p "$HOME/log"

  if [ ! -f "$HOME/log/xscreensaver.log" ]
  then
    touch "$HOME/log/xscreensaver.log"
  fi
fi

# include .bashrc if it exists
[ -n "$BASH_VERSION" ] && {
  [ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"
}

# Include local bin
[ -e $HOME/bin ] && {
    [ -L $HOME/bin ] || [ -f $HOME/bin ] && {
      pathmunge "$HOME/bin"
    }
}

[ -d $HOME/.local/bin ] && pathmunge "$HOME/.local/bin"

# Add rbenv to PATH for scripting
if [ -d $HOME/.rbenv/bin ]
then
  pathmunge "$HOME/.rbenv/bin"
  # Load rbenv
  eval "$(rbenv init -)"

  # Vim setup
  RUBY_BIN=$(rbenv which ruby 2> /dev/null || true | sed 's/ruby$//')
  [ x"$RUBY_BIN" != x ] && export RUBY_BIN
fi

# Composer
if [ -d "$XDG_CONFIG_HOME/composer" ]
then
  export COMPOSER_HOME="$XDG_CONFIG_HOME/composer"
  export COMPOSER_CACHE_DIR="$XDG_CACHE_HOME/composer"

  [ -d $COMPOSER_HOME/vendor/bin ] && pathmunge "$COMPOSER_HOME/vendor/bin"
fi

# Go lang local workspace
#
# To append Go binaries to the $PATH see:
# https://github.com/udhos/update-golang
# See /etc/profile.d/golang_path.sh file
if [ -d "$HOME/go" ]
then
  export GOPATH="$HOME/go"

  [ ! -d "$GOPATH/bin" ] && mkdir -p "$GOPATH/bin"

  # Put binary files created using "go install" command in "$GOPATH/bin"
  export GOBIN="$GOPATH/bin"
  pathmunge "$GOBIN"

  # Enable the go modules feature
  export GO111MODULE=on

  # Set the GOPROXY environment variable
  # export GOPROXY=https://goproxy.io
fi

# TinyGo
#
# See: https://github.com/tinygo-org/tinygo
[ -d "/usr/local/tinygo/bin" ] && pathmunge "/usr/local/tinygo/bin"

# Symlink from /opt/ghc/$GHCVER/bin
# add-apt-repository -y ppa:hvr/ghc
[ -d "/opt/ghc/bin" ] && pathmunge "/opt/ghc/bin"

# Symlink from /opt/cabal/$CABALVER/bin
# add-apt-repository -y ppa:hvr/ghc
[ -d "/opt/cabal/bin" ] && pathmunge "/opt/cabal/bin"

# add-apt-repository -y ppa:hvr/ghc
[ -d "/opt/ghc-ppa-tools/bin" ] &&pathmunge "/opt/ghc-ppa-tools/bin"

# hlint
# https://github.com/ndmitchell/hlint
[ -d $HOME/.hlint ] && pathmunge "$HOME/.hlint"

# Cabal
[ -d $HOME/.cabal/bin ] && pathmunge "$HOME/.cabal/bin"

# Cask
[ -d $HOME/.cask/bin ] && pathmunge "$HOME/.cask/bin"

# php-build
PHP_BUILD_EXTRA_MAKE_ARGUMENTS=-j"$(getconf _NPROCESSORS_ONLN)"

[ -d $HOME/src/php ] && export PHP_BUILD_TMPDIR=$HOME/src/php

# phpenv
if [ -d $HOME/.phpenv ]; then
  export PHPENV_ROOT="$HOME/.phpenv"
  pathmunge "$PHPENV_ROOT/bin"

  eval "$(phpenv init -)"

  [ -d "$PHPENV_ROOT/plugins/php-build/bin" ] && {
      pathmunge "$PHPENV_ROOT/plugins/php-build/bin"
  }
fi

# Enable Emacs Version Manager
[ -d ${HOME}/.evm/bin ] && {
  export EVM_ROOT="$HOME/.evm"
  pathmunge "$EVM_ROOT/bin"
}

# Google Cloud SDK
[ -d "$HOME/gcp/bin" ] && pathmunge "$HOME/gcp/bin"

# vim:ft=sh:ts=2:sw=2:sts=2:tw=78:fenc=utf-8:et
