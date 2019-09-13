#!/usr/bin/env zsh

#
# Zsh startup file
#

source "$HOME/profile.d/functions.sh"
source "$HOME/profile.d/docker-tools.sh"

# Sane defaults
pathmunge /usr/local/sbin

if [[ -z "$LC_ALL" ]]; then
  export LC_ALL='en_US.UTF-8'
fi

# kubectl
if [ -d /usr/local/Cellar/kubernetes-cli/1.15.3/bin ]
then
  pathmunge /usr/local/Cellar/kubernetes-cli/1.15.3/bin
fi

# Go lang local workspace
if [ -d /usr/local/go/bin ]
then
  pathmunge /usr/local/go/bin
fi

if [ -d "$HOME/go" ]; then
  export GOPATH="$HOME/go"

  if [ ! -d "$GOPATH/bin" ]; then
    mkdir -p "$GOPATH/bin"
  fi

  # Put binary files created using "go install" command in "$GOPATH/bin"
  export GOBIN="$GOPATH/bin"
  pathmunge "$GOBIN"

  # Enable the go modules feature
  export GO111MODULE=on
fi

# php-build
PHP_BUILD_EXTRA_MAKE_ARGUMENTS=-j"$(getconf _NPROCESSORS_ONLN)"

if [ -d $HOME/src ]; then
  test -d $HOME/src/php || mkdir -p $HOME/src/php
  export PHP_BUILD_TMPDIR=$HOME/src/php
fi

# phpenv
if [ -d $HOME/.phpenv ]; then
  export PHPENV_ROOT="$HOME/.phpenv"
  pathmunge "$PHPENV_ROOT/bin"

  eval "$(phpenv init -)"

  if [ -d $PHPENV_ROOT/plugins/php-build/bin ]; then
    pathmunge "$PHPENV_ROOT/plugins/php-build/bin"
  fi

  if [ -f $HOME/.php_build_configure_opts ]; then
    PHP_BUILD_CONFIGURE_OPTS=$(cat $HOME/.php_build_configure_opts)
    export PHP_BUILD_CONFIGURE_OPTS
  fi
fi

# Aliases

if command -v docker >/dev/null 2>&1
then
  alias dps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'"
fi

if command -v kubectl >/dev/null 2>&1
then
  alias k='kubectl'
  alias kcd='kubectl config set-context $(kubectl config current-context) --namespace'
fi
