# Copyright (C) 2014-2020 Serghei Iakovlev <egrep@protonmail.ch>
#
# This file is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# This file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this file.  If not, see <https://www.gnu.org/licenses/>.

# User wide environment and startup programs, for login setup.
#
# This file is sourced by the first for login shells.

# shellcheck shell=bash

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
# shellcheck source=./bash.d/pathmunge.sh
. ~/bash.d/pathmunge.sh

# Include alternate sbin
if [ -d /usr/local/sbin ]; then
  pathmunge /usr/local/sbin
fi

# Include local bin
if [ -e ~/bin ]; then
  if [ -L ~/bin ] || [ -d ~/bin ]; then
    pathmunge ~/bin
  fi
fi

if [ -d ~/.local/bin ]; then
  pathmunge ~/.local/bin
fi

case "$OS" in
  Darwin)
    for dir in "$HOME/Library/Python/"* ; do
      if [ -d "$dir/bin" ]; then
        pathmunge "$dir/bin"
      fi
    done

    # Disable homebrew auto update in macOs
    # whenever I run a brew command.
    if command -v brew >/dev/null 2>&1 ; then
      HOMEBREW_NO_AUTO_UPDATE=1
      ecport HOMEBREW_NO_AUTO_UPDATE
    fi

    # See: https://stackoverflow.com/q/7165108/1661465
    LC_ALL=en_US.UTF-8
    LANG=en_US.UTF-8
    export LC_ALL LANG

    # LLVM
    if [ -d /usr/local/opt/llvm/bin ]; then
      pathmunge /usr/local/opt/llvm/bin
    fi

    # QT
    if [ -d /usr/local/opt/qt/bin ]; then
      pathmunge /usr/local/opt/qt/bin
    fi

    # kubectl
    if [ -d /usr/local/opt/kubernetes-cli/bin ]; then
      pathmunge /usr/local/opt/kubernetes-cli/bin
    fi
    ;;
  *Linux)
    # Note: ~ is only expanded by the shell if it's unquoted.
    # When it's quoted it's a literal tilde symbol.
    if [ -r "${XDG_CONFIG_HOME:-$HOME/.config}"/xdg-dirs ]; then
      # shellcheck source=./.config/xdg-dirs
      . "${XDG_CONFIG_HOME:-$HOME/.config}"/xdg-dirs
    fi
    ;;
esac

# Add .NET Core SDK tools
if [ -d ~/.dotnet/tools ]; then
  DOTNET_CLI_TELEMETRY_OPTOUT=1
  export DOTNET_CLI_TELEMETRY_OPTOUT
  pathmunge ~/.dotnet/tools
fi

# rbenv
# Only set PATH here to prevent performance degradation.
for dir in ~/.rbenv "/usr/local/opt/rbenv"; do
  if [[ -d "$dir/bin" ]]; then
    pathmunge "$dir/bin"
    break
  fi
done

# skdman
# Only set PATH here to prevent performance degradation.
if [ -z ${SDKMAN_DIR+x} ]; then
  if [ -d "$HOME/.sdkman" ]; then
    SDKMAN_DIR="$HOME/.sdkman"
    export SDKMAN_DIR
  fi
else
  if [ ! -d "$SDKMAN_DIR" ]; then
    unset SDKMAN_DIR
  fi
fi

# virtualenvwrapper

# The variable WORKON_HOME tells virtualenvwrapper where to place
# your virtual environments. If the directory does not exist when
# virtualenvwrapper is loaded, it will be created automatically.
if [ -z ${WORKON_HOME+x} ]; then
  if [ -d "$HOME/.virtualenvs" ]; then
    WORKON_HOME=~/.virtualenvs
    export WORKON_HOME
  fi
fi

# The variable PROJECT_HOME tells virtualenvwrapper where to place
# your project working directories. The variable PROJECT_HOME tells
# virtualenvwrapper where to place your project working directories.
if [ -z ${PROJECT_HOME+x} ]; then
  if [ -d "$HOME/work" ]; then
    PROJECT_HOME=~/work
    export PROJECT_HOME
  fi
fi

# The variable VIRTUALENVWRAPPER_PYTHON tells virtualenvwrapper the
# full path of the interpreter to use.
if command -v python3 >/dev/null 2>&1 && [ -n "${WORKON_HOME+x}" ]
then
  VIRTUALENVWRAPPER_PYTHON="$(command -v python3 2>/dev/null)"
  export VIRTUALENVWRAPPER_PYTHON
elif command -v python >/dev/null 2>&1; then
  VIRTUALENVWRAPPER_PYTHON="$(command -v python 2>/dev/null)"
  export VIRTUALENVWRAPPER_PYTHON
fi

if [ -n "${WORKON_HOME+x}" ] && \
     command -v virtualenvwrapper_lazy.sh >/dev/null 2>&1 ; then
  # shellcheck disable=SC1090
  . "$(command -v virtualenvwrapper_lazy.sh 2>/dev/null)"
fi

# phpenv
# Only set PATH here to prevent performance degradation.
if [ -d ~/.phpenv/bin ]; then
  pathmunge ~/.phpenv/bin
fi

# php-build
if [ -d ~/.phpenv/plugins/php-build/bin ]; then
  PHP_BUILD_EXTRA_MAKE_ARGUMENTS=-j"$(getconf _NPROCESSORS_ONLN)"
  export PHP_BUILD_EXTRA_MAKE_ARGUMENTS
  if [ -d ~/src/php ]; then
    PHP_BUILD_TMPDIR=~/src/php
    export PHP_BUILD_TMPDIR
  fi

  pathmunge ~/.phpenv/plugins/php-build/bin
fi

# Local binaries
if [ -d ~/.local/bin ]; then
  pathmunge ~/.local/bin
fi

# Go lang local workspace
if [ -d /usr/local/go/bin ]; then
  pathmunge /usr/local/go/bin
fi

# Cargo binaries
if [ -d ~/.cargo/bin ]; then
  pathmunge ~/.cargo/bin
fi

if [ -d /usr/lib/cargo/bin ]; then
  pathmunge /usr/lib/cargo/bin
fi

# Go lang local workspace
if [ -d ~/go ]; then
  GOPATH=~/go
  export GOPATH

  if [ -d "$GOPATH/bin" ]; then
    # Put binary files created using "go install" command
    # in "$GOPATH/bin"
    GOBIN="$GOPATH/bin"
    export GOBIN
    pathmunge "$GOBIN"
  fi

  GO111MODULE=auto
  export GO111MODULE
fi

# TinyGo
# See: https://github.com/tinygo-org/tinygo
if [ -d /usr/local/tinygo/bin ]; then
  pathmunge /usr/local/tinygo/bin
fi

# hlint
# See: https://github.com/ndmitchell/hlint
if [ -d ~/.hlint ]; then
  pathmunge ~/.hlint
fi

# Cabal
if [ -d ~/.cabal/bin ]; then
  pathmunge ~/.cabal/bin
fi

# Cask
if [ -d ~/.cask/bin ]; then
  pathmunge ~/.cask/bin
fi

# Composer
# Note: ~ is only expanded by the shell if it's unquoted.
# When it's quoted it's a literal tilde symbol.
if [ -d "${XDG_CONFIG_HOME:-$HOME/.config}/composer" ]; then
  COMPOSER_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/composer"
  COMPOSER_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/composer"
  export COMPOSER_HOME COMPOSER_CACHE_DIR

  if [ -d "$COMPOSER_HOME/vendor/bin" ]; then
    pathmunge "$COMPOSER_HOME/vendor/bin"
  fi
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -d ~/gcp/bin ]; then
  pathmunge ~/gcp/bin
fi

if [ -r ~/gcp/path.bash.inc ]; then
  # shellcheck disable=SC1090
  . ~/gcp/path.bash.inc
fi

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
if [ -r ~/bash.d/gpg.sh ]; then
  # shellcheck source=./bash.d/gpg.sh
  . ~/bash.d/gpg.sh
fi

# Include '.bashrc' if it exists
if [ -r ~/.bashrc ]; then
  # shellcheck source=./.bashrc
  . ~/.bashrc
fi

if command -v systemctl >/dev/null 2>&1 ; then
  systemctl --user import-environment PATH >/dev/null
fi

# Local Variables:
# mode: sh
# End:
