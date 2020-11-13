# ~/.bash_profile
#
# User wide environment and startup programs, for login setup.
#
# This file is sourced by the first for login shells.

# A workaround to get OS name on Linux and macOS systems
OS="$(uname -o 2>/dev/null || uname -s)"
export OS

# HOSTNAME contains name of the machine, as known to applications
# that run locally
if [ -z ${HOSTNAME+x} ]; then
  if command -v hostname >/dev/null 2>&1; then
    HOSTNAME="$(hostname -s)"
  else
    HOSTNAME=localhost
  fi

  export HOSTNAME
fi

# HOST contains long host name (FQDN)
if [ -z ${HOST+x} ]; then
  if command -v hostname >/dev/null 2>&1; then
    HOST="$(hostname -f)"
  else
    HOST="${HOSTNAME}.localdomain"
  fi

  export HOST
fi

# pathmunge function
. ~/bash.d/pathmunge.sh

# Include local bin
[ -e ~/bin ] && {
  [ -L ~/bin ] || [ -d ~/bin ] && {
    pathmunge ~/bin
  }
}

[ -d ~/.local/bin ] && pathmunge ~/.local/bin

case "$OS" in
  Darwin)
    # See: https://stackoverflow.com/q/7165108/1661465
    LC_ALL=en_US.UTF-8
    LANG=en_US.UTF-8
    export LC_ALL LANG

    # LLVM
    [ -d /usr/local/opt/llvm/bin ] && {
      pathmunge /usr/local/opt/llvm/bin
    }

    # QT
    [ -d /usr/local/opt/qt/bin ] && {
      pathmunge /usr/local/opt/qt/bin
    }

    # kubectl
    [ -d /usr/local/opt/kubernetes-cli/bin ] &&
      pathmunge /usr/local/opt/kubernetes-cli/bin
    ;;
  *Linux)
    # Note: ~ is only expanded by the shell if it's unquoted.
    # When it's quoted it's a literal tilde symbol.
    [ -r "${XDG_CONFIG_HOME:-$HOME/.config}"/xdg-dirs ] && {
      . "${XDG_CONFIG_HOME:-$HOME/.config}"/xdg-dirs
    }
    ;;
esac

# Add .NET Core SDK tools
[ -d ~/.dotnet/tools ] && {
  DOTNET_CLI_TELEMETRY_OPTOUT=1
  export DOTNET_CLI_TELEMETRY_OPTOUT
  pathmunge ~/.dotnet/tools
}

# rbenv
# Only set PATH here to prevent performance degradation.
for dir in ~/.rbenv "/usr/local/opt/rbenv"; do
  if [[ -d "$dir/bin" ]]; then
    pathmunge "$dir/bin"
    break
  fi
done

# virtualenvwrapper

# The variable WORKON_HOME tells virtualenvwrapper where to place
# your virtual environments. If the directory does not exist when
# virtualenvwrapper is loaded, it will be created automatically.
WORKON_HOME=~/.virtualenvs
export WORKON_HOME

# The variable PROJECT_HOME tells virtualenvwrapper where to place
# your project working directories. The variable PROJECT_HOME tells
# virtualenvwrapper where to place your project working directories.
PROJECT_HOME=~/work
export PROJECT_HOME

# The variable VIRTUALENVWRAPPER_PYTHON tells virtualenvwrapper the
# full path of the interpreter to use.
if command -v python3 >/dev/null 2>&1; then
  VIRTUALENVWRAPPER_PYTHON="$(command -v python3 2>/dev/null)"
  export VIRTUALENVWRAPPER_PYTHON
elif command -v python >/dev/null 2>&1; then
  VIRTUALENVWRAPPER_PYTHON="$(command -v python 2>/dev/null)"
  export VIRTUALENVWRAPPER_PYTHON
fi

if command -v virtualenvwrapper_lazy.sh >/dev/null 2>&1; then
  source "$(command -v virtualenvwrapper_lazy.sh 2>/dev/null)"
fi

# phpenv
# Only set PATH here to prevent performance degradation.
[ -d ~/.phpenv/bin ] && {
  pathmunge ~/.phpenv/bin
}

# php-build
[ -d ~/.phpenv/plugins/php-build/bin ] && {
  PHP_BUILD_EXTRA_MAKE_ARGUMENTS=-j"$(getconf _NPROCESSORS_ONLN)"
  export PHP_BUILD_EXTRA_MAKE_ARGUMENTS
  [ -d ~/src/php ] && {
    PHP_BUILD_TMPDIR=~/src/php
    export PHP_BUILD_TMPDIR
  }

  pathmunge ~/.phpenv/plugins/php-build/bin
}

# Local binaries
[ -d ~/.local/bin ] && pathmunge ~/.local/bin

# Go lang local workspace
[ -d /usr/local/go/bin ] && pathmunge /usr/local/go/bin

# Cargo binaries
[ -d ~/.cargo/bin ] && pathmunge ~/.cargo/bin
[ -d /usr/lib/cargo/bin ] && pathmunge /usr/lib/cargo/bin

# Go lang local workspace
if [ -d ~/go ]; then
  GOPATH=~/go
  export GOPATH

  [ -d "$GOPATH/bin" ] && {
    # Put binary files created using "go install" command
    # in "$GOPATH/bin"
    GOBIN="$GOPATH/bin"
    export GOBIN
    pathmunge "$GOBIN"
  }

  GO111MODULE=auto
  export GO111MODULE
fi

# TinyGo
# See: https://github.com/tinygo-org/tinygo
[ -d /usr/local/tinygo/bin ] && pathmunge /usr/local/tinygo/bin

# hlint
# See: https://github.com/ndmitchell/hlint
[ -d ~/.hlint ] && pathmunge ~/.hlint

# Cabal
[ -d ~/.cabal/bin ] && pathmunge ~/.cabal/bin

# Cask
[ -d ~/.cask/bin ] && pathmunge ~/.cask/bin

# Composer
# Note: ~ is only expanded by the shell if it's unquoted.
# When it's quoted it's a literal tilde symbol.
if [ -d "${XDG_CONFIG_HOME:-$HOME/.config}/composer" ]; then
  COMPOSER_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/composer"
  COMPOSER_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/composer"
  export COMPOSER_HOME COMPOSER_CACHE_DIR

  [ -d "$COMPOSER_HOME/vendor/bin" ] &&
    pathmunge "$COMPOSER_HOME/vendor/bin"
fi

# The next line updates PATH for the Google Cloud SDK.
[ -d ~/gcp/bin ] && pathmunge ~/gcp/bin
[ -r ~/gcp/path.bash.inc ] && . ~/gcp/path.bash.inc

export PATH

# MANPATH: path for the man command to search.
# Look at the manpath command's output and prepend my own manual
# paths manually.
if [ -z ${MANPATH+x} ] || [ "$MANPATH" = ":" ] ; then
  # Only do this if the MANPATH variable isn't already set.
  if command -v manpath >/dev/null 2>&1; then
    # Get the original manpath, then modify it.
    MANPATH="$(manpath 2>/dev/null)"
  else
    MANPATH=""
  fi

  IFS=':' read -r -a mans <<< "$MANPATH"

  mans+=(~/man)
  mans+=(/opt/man)
  mans+=(/usr/local/share/man)
  mans+=(/usr/local/man)
  mans+=(/usr/share/man)
  mans+=(/usr/man)

  MANPATH="$( IFS=$':'; echo -n "${mans[*]}" )"
  unset mans

  MANPATH="${MANPATH//\/:/:}"
  MANPATH="${MANPATH%/}"

  export MANPATH
fi

# Editor to fallback to if the server is not running.  If this
# variable is empty, then start GNU Emacs in daemon mode and try
# connecting again.
ALTERNATE_EDITOR=''
export ALTERNATE_EDITOR

# See:
# https://github.com/sergeyklay/.emacs.d/blob/master/bin/emacsclient.wrapper
if command -v emacsclient.wrapper >/dev/null 2>&1 ; then
  EDITOR=emacsclient.wrapper
else
  EDITOR='emacs -nw'
fi
export EDITOR

VISUAL="$EDITOR"
export VISUAL

# Configure gpg & ssh
[ -r ~/bash.d/gpg.sh ] && . ~/bash.d/gpg.sh

# Include '.bashrc' if it exists
[ -r ~/.bashrc ] && . ~/.bashrc

# Local Variables:
# mode: sh
# flycheck-shellcheck-excluded-warnings: ("SC1090")
# flycheck-disabled-checkers: (sh-posix-dash sh-shellcheck)
# End:
