#!/usr/bin/env zsh

#
# Zsh startup file
#

source "$HOME/profile.d/functions.sh"
source "$HOME/profile.d/docker-tools.sh"

# Sane defaults
pathmunge /usr/local/sbin

[ -z "$LC_ALL" ] && export LC_ALL='en_US.UTF-8'

# kubectl
[ "$(command -v brew 2>/dev/null || true)" != "" ] && {
  [ -d "$(brew --prefix kubernetes-cli)/bin" ] && {
    pathmunge "$(brew --prefix kubernetes-cli)/bin"
  }
}

# Local binaries
[ -d "$HOME/.local/bin" ] && pathmunge "$HOME/.local/bin"

# Google Cloud SDK
[ -d "$HOME/gcp/bin" ] && pathmunge "$HOME/gcp/bin"

# Go lang local workspace
[ -d /usr/local/go/bin ] && pathmunge /usr/local/go/bin

if [ -d "$HOME/go" ]; then
  export GOPATH="$HOME/go"

  [ ! -d "$GOPATH/bin" ] && mkdir -p "$GOPATH/bin"

  # Put binary files created using "go install" command in "$GOPATH/bin"
  export GOBIN="$GOPATH/bin"
  pathmunge "$GOBIN"

  # Enable the go modules feature
  export GO111MODULE=on
fi

# php-build
PHP_BUILD_EXTRA_MAKE_ARGUMENTS=-j"$(getconf _NPROCESSORS_ONLN)"

if [ -d $HOME/src ]
then
  test -d $HOME/src/php || mkdir -p $HOME/src/php
  export PHP_BUILD_TMPDIR=$HOME/src/php
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
