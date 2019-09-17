#!/usr/bin/env zsh

#
# Zsh startup file
#

source "$HOME/profile.d/functions.sh"
source "$HOME/profile.d/docker-tools.sh"

# Sane defaults
pathmunge /usr/local/sbin

export BREW_PATH="$(command -v brew 2>/dev/null || true)"
export KUBECTL_PATH="$(command -v kubectl 2>/dev/null || true)"

[ -z "$LC_ALL" ] && export LC_ALL='en_US.UTF-8'

# kubectl
[ ! -z "$BREW_PATH" ] && {
  _k8s="$(brew --prefix kubernetes-cli 2>/dev/null || true)"
  [ -n $_k8s ] && [ -d "$_k8s/bin" ] && {
    pathmunge "$_k8s/bin"
  }
  unset _k8s
}

# Include local bin
[ -e $HOME/bin ] && {
  [ -L $HOME/bin ] || [ -f $HOME/bin ] && {
    pathmunge "$HOME/bin"
  }
}

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

# Local binaries
[ -d "$HOME/.local/bin" ] && pathmunge "$HOME/.local/bin"

# Google Cloud SDK
[ -d "$HOME/gcp/bin" ] && pathmunge "$HOME/gcp/bin"

# Go lang local workspace
[ -d /usr/local/go/bin ] && pathmunge /usr/local/go/bin

# Go lang local workspace
if [ -d "$HOME/go" ]; then
  export GOPATH="$HOME/go"

  [ ! -d "$GOPATH/bin" ] && mkdir -p "$GOPATH/bin"

  # Put binary files created using "go install" command in "$GOPATH/bin"
  export GOBIN="$GOPATH/bin"
  pathmunge "$GOBIN"

  # Enable the go modules feature
  export GO111MODULE=on
fi

# TinyGo
#
# See: https://github.com/tinygo-org/tinygo
[ -d "/usr/local/tinygo/bin" ] && pathmunge "/usr/local/tinygo/bin"

# hlint
# https://github.com/ndmitchell/hlint
[ -d $HOME/.hlint ] && pathmunge "$HOME/.hlint"

# Cabal
[ -d $HOME/.cabal/bin ] && pathmunge "$HOME/.cabal/bin"

# Cask
[ -d $HOME/.cask/bin ] && pathmunge "$HOME/.cask/bin"

# php-build
PHP_BUILD_EXTRA_MAKE_ARGUMENTS=-j"$(getconf _NPROCESSORS_ONLN)"

if [ -d $HOME/src ]
then
  test -d $HOME/src/php || mkdir -p $HOME/src/php
  export PHP_BUILD_TMPDIR=$HOME/src/php
fi

# Composer
if [ -d "$XDG_CONFIG_HOME/composer" ]
then
  export COMPOSER_HOME="$XDG_CONFIG_HOME/composer"
  export COMPOSER_CACHE_DIR="$XDG_CACHE_HOME/composer"

  [ -d $COMPOSER_HOME/vendor/bin ] && pathmunge "$COMPOSER_HOME/vendor/bin"
fi

# phpenv
if [ -d $HOME/.phpenv ]
then
  export PHPENV_ROOT="$HOME/.phpenv"
  pathmunge "$PHPENV_ROOT/bin"

  eval "$(phpenv init -)"

  [ -d $PHPENV_ROOT/plugins/php-build/bin ] && {
    pathmunge "$PHPENV_ROOT/plugins/php-build/bin"
  }
fi

# vim:ft=sh:ts=2:sw=2:sts=2:tw=78:fenc=utf-8:et
