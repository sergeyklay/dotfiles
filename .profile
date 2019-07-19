#!/bin/bash

#
# Bash profile
#

# check whether the string given is already in the PATH
pathmunge () {
  if ! echo "$PATH" | /bin/grep -Eq "(^|:)$1($|:)" ; then
    if [ "$2" = "after" ] ; then
      export PATH="$PATH:$1"
    else
      export PATH="$1:$PATH"
    fi
  fi
}

# Some default paths
pathmunge "/usr/sbin"
pathmunge "/usr/local/bin"

# See ~/.Xresources
if [ -x "$(command -v xscreensaver 2>/dev/null)" ]; then
  if [ ! -d $HOME/log ]; then
    mkdir -p "$HOME/log"
  fi

  if [ ! -f "$HOME/log/xscreensaver.log" ]; then
    touch "$HOME/log/xscreensaver.log"
  fi
fi

# include .bashrc if it exists
if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# Include local bin
if [ -e $HOME/bin ]; then
  if [ -L $HOME/bin ] || [ -f $HOME/bin ]; then
    pathmunge "$HOME/bin"
  fi
fi

if [ -d $HOME/.local/bin ]; then
  pathmunge "$HOME/.local/bin"
fi

# Add rbenv to PATH for scripting
if [ -d $HOME/.rbenv/bin ]; then
  pathmunge "$HOME/.rbenv/bin"
  # Load rbenv
  eval "$(rbenv init -)"

  # Vim setup
  export RUBY_BIN=$(rbenv which ruby | sed 's/ruby$//')
fi

# Phalcon
if [ -d "$HOME/work/phalcon/devtools" ]; then
  export PTOOLSPATH="$HOME/work/phalcon/devtools"
  pathmunge "$PTOOLSPATH"
fi

# Composer
if [ -d "$XDG_CONFIG_HOME/composer" ]; then
  export COMPOSER_HOME="$XDG_CONFIG_HOME/composer"
  export COMPOSER_CACHE_DIR="$XDG_CACHE_HOME/composer"

  if [ -d $COMPOSER_HOME/vendor/bin ]; then
    pathmunge "$COMPOSER_HOME/vendor/bin"
  fi
fi

# Go lang local workspace
#
# To append Go binaries to the $PATH see:
# https://github.com/udhos/update-golang
# See /etc/profile.d/golang_path.sh file
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

  # Set the GOPROXY environment variable
  export GOPROXY=https://goproxy.io
fi

# TinyGo
#
# See: https://github.com/tinygo-org/tinygo
if [ -d "/usr/local/tinygo/bin" ]; then
  pathmunge "/usr/local/tinygo/bin"
fi

# Symlink from /opt/ghc/$GHCVER/bin
# add-apt-repository -y ppa:hvr/ghc
if [ -d "/opt/ghc/bin" ]; then
  pathmunge "/opt/ghc/bin"
fi

# Symlink from /opt/cabal/$CABALVER/bin
# add-apt-repository -y ppa:hvr/ghc
if [ -d "/opt/cabal/bin" ]; then
  pathmunge "/opt/cabal/bin"
fi

# add-apt-repository -y ppa:hvr/ghc
if [ -d "/opt/ghc-ppa-tools/bin" ]; then
  pathmunge "/opt/ghc-ppa-tools/bin"
fi

# hlint
# https://github.com/ndmitchell/hlint
if [ -d $HOME/.hlint ]; then
  pathmunge "$HOME/.hlint"
fi

# Cabal
if [ -d $HOME/.cabal/bin ]; then
  pathmunge "$HOME/.cabal/bin"
fi

# Cask
if [ -d $HOME/.cask/bin ]; then
  pathmunge "$HOME/.cask/bin"
fi

# Enable phpenv
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

# Enable Emacs Version Manager
if [ -d ${HOME}/.evm/bin ]; then
  export EVM_ROOT="$HOME/.evm"
  pathmunge "$EVM_ROOT/bin"
fi

# vim:ft=sh:ts=2:sw=2:sts=2:tw=78:fenc=utf-8:et
