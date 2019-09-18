#!/usr/bin/env zsh

#
# Zsh startup file.
#
# Used for setting user's environment variables.
#

source "$HOME/profile.d/functions.sh"
source "$HOME/profile.d/docker-tools.sh"

# User-specific configuration files
[ -d "$HOME/.config" ] && export XDG_CONFIG_HOME="$HOME/.config"

# User-specific data files
[ -d "$HOME/.local/share" ] && export XDG_DATA_HOME="$HOME/.local/share"

# Base directories relative to which data files should be searched
[ -d /usr/share ] && export XDG_DATA_DIRS=/usr/share

# Configuration files should be searched relative to this directory
[ -d /etc/xdg ] && export XDG_CONFIG_DIRS=/etc/xdg

# User-specific cached data should be written relative to this directory
[ -d "$HOME/.cache" ] && export XDG_CACHE_HOME="$HOME/.cache"

# User-specific runtime files should be placed relative to this directory
[ -d /run/user ] && export XDG_RUNTIME_DIR=/run/user/$(id -u)

# See: https://stackoverflow.com/a/27965014/1661465
[ -d "$HOME/.local/state" ] && export XDG_STATE_HOME="$HOME/.local/state"

# See: https://github.com/sergeyklay/vimfiles
export EDITOR="vim"
export VIEWER="vim -R"

# More for less
export PAGER=less

if [ -f /usr/local/bin/lesspipe.sh ]
then
  LESSPIPE="$(which lesspipe.sh)"
  LESSOPEN="| ${LESSPIPE} %s"; export LESSOPEN
elif [ -x /usr/bin/lesspipe ]
then
  eval "$(lesspipe)"
fi

# -X will leave the text in your Terminal, so it doesn't disappear
#    when you exit less
# -F will exit less if the output fits on one screen (so you don't
#    have to press "q").
#
# See: https://unix.stackexchange.com/q/38634/50400
export LESS="-X -F"
export LESSCHARSET=UTF-8

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
[ -e "$HOME/bin" ] && {
  [ -L "$HOME/bin" ] || [ -f "$HOME/bin" ] && {
    pathmunge "$HOME/bin"
  }
}

# Add rbenv to PATH for scripting
if [ -d "$HOME/.rbenv/bin" ]
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
[ -d "$HOME/.hlint" ] && pathmunge "$HOME/.hlint"

# Cabal
[ -d "$HOME/.cabal/bin" ] && pathmunge "$HOME/.cabal/bin"

# Cask
[ -d "$HOME/.cask/bin" ] && pathmunge "$HOME/.cask/bin"

# php-build
PHP_BUILD_EXTRA_MAKE_ARGUMENTS=-j"$(getconf _NPROCESSORS_ONLN)"

[ -d "$HOME/src" ] && {
  [ -d "$HOME/src/php" ] || mkdir -p "$HOME/src/php"
  export PHP_BUILD_TMPDIR="$HOME/src/php"
}

# Composer
if [ -d "$XDG_CONFIG_HOME/composer" ]
then
  export COMPOSER_HOME="$XDG_CONFIG_HOME/composer"
  export COMPOSER_CACHE_DIR="$XDG_CACHE_HOME/composer"

  [ -d $COMPOSER_HOME/vendor/bin ] && pathmunge "$COMPOSER_HOME/vendor/bin"
fi

# phpenv
if [ -d "$HOME/.phpenv" ]
then
  export PHPENV_ROOT="$HOME/.phpenv"
  pathmunge "$PHPENV_ROOT/bin"

  eval "$(phpenv init -)"

  [ -d "$PHPENV_ROOT/plugins/php-build/bin" ] && {
    pathmunge "$PHPENV_ROOT/plugins/php-build/bin"
  }
fi

# vim:ft=sh:ts=2:sw=2:sts=2:tw=78:fenc=utf-8:et
