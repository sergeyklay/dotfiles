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
  export PATH="${HOME}/bin:${PATH}"
fi

# Add rbenv to PATH for scripting
if [ -d "$HOME/.rbenv/bin" ]; then
  export PATH=$HOME/.rbenv/bin:$PATH
  # Load rbenv
  eval "$(rbenv init -)"

  # Vim setup
  export RUBY_BIN=$(rbenv which ruby | sed 's/ruby$//')
fi

# Phalcon
if [ -d "$HOME/workspace/php/phalcon/devtools" ]; then
  export PTOOLSPATH="$HOME/workspace/php/phalcon/devtools"
  export PATH="${PTOOLSPATH}:${PATH}"
fi

# Zephir
if [ -d "$HOME/workspace/c/zephir" ]; then
  export ZEPHIRDIR="$HOME/workspace/c/zephir"
  export PATH="$ZEPHIRDIR/bin:$PATH"
fi

# Composer
if [ -d "$HOME/.composer" ]; then
  export COMPOSER_HOME="$HOME/.composer"
  export PATH="${COMPOSER_HOME}:${PATH}"

  # See: https://github.com/stecman/composer-bash-completion-plugin
  ac="vendor/stecman/composer-bash-completion-plugin/hooks/bash-completion"
  if [ -f "${COMPOSER_HOME}/${ac}" ]; then
    source "${COMPOSER_HOME}/${ac}"
  fi
fi

if [ -d "$HOME/.composer/vendor/bin" ]; then
  export PATH="${HOME}/.composer/vendor/bin:${PATH}"
fi

# Go & local workspace
if [ -d "/usr/local/go/bin" ]; then
  export GOROOT="/usr/local/go"
  export PATH="${GOROOT}/bin:${PATH}"
fi

if [ -d "$HOME/go" ]; then
  export GOPATH="$HOME/go"

  if [ -d "$GOPATH/bin" ]; then
    export GOBIN="$GOPATH/bin"
    export PATH="${GOBIN}:${PATH}"
  fi
fi

if [ -d "/opt/phpstorm/bin" ]; then
  export PATH="/opt/phpstorm/bin:${PATH}"
fi

# Enable phpenv
if [ -d "${HOME}/.phpenv" ]; then
  export PHPENV_ROOT="${HOME}/.phpenv"
  export PATH="${PHPENV_ROOT}/bin:${PATH}"

  eval "$(phpenv init -)"

  if [ -d "${PHPENV_ROOT}/plugins/php-build/bin" ]; then
    export PATH="${PHPENV_ROOT}/plugins/php-build/bin:${PATH}"
  fi

  if [ -f "$HOME/.php_build_configure_opts" ]; then
    export PHP_BUILD_CONFIGURE_OPTS=`cat $HOME/.php_build_configure_opts`
  fi
fi

# vim:ft=sh:ts=8:sw=2:sts=2:tw=80:et
