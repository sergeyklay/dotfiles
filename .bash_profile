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

# Custom Bash functions
for file in ~/profile.d/*.sh; do
  # shellcheck source=/dev/null
  . "${file}" || true;
done

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
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8

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
    [ -r "${XDG_CONFIG_HOME:-~/.config}"/xdg-dirs ] && {
      # shellcheck source=/dev/null
      . "${XDG_CONFIG_HOME:-~/.config}"/xdg-dirs
    }
    ;;
esac

# Add .NET Core SDK tools
[ -d ~/.dotnet/tools ] && {
  export DOTNET_CLI_TELEMETRY_OPTOUT=1
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
    export PHP_BUILD_TMPDIR=~/src/php
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
  export GOPATH=~/go

  [ -d "$GOPATH/bin" ] && {
    # Put binary files created using "go install" command
    # in "$GOPATH/bin"
    export GOBIN="$GOPATH/bin"
    pathmunge "$GOBIN"
  }

  export GO111MODULE=on
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
if [ -d "${XDG_CONFIG_HOME:-~/.config}/composer" ]; then
  export COMPOSER_HOME="${XDG_CONFIG_HOME:-~/.config}/composer"
  export COMPOSER_CACHE_DIR="${XDG_CACHE_HOME:-~/.cache}/composer"

  [ -d "$COMPOSER_HOME/vendor/bin" ] &&
    pathmunge "$COMPOSER_HOME/vendor/bin"
fi

# The next line updates PATH for the Google Cloud SDK.
[ -d ~/gcp/bin ] && pathmunge ~/gcp/bin
# shellcheck source=/dev/null
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
export ALTERNATE_EDITOR=''

# See:
# https://github.com/sergeyklay/.emacs.d/blob/master/bin/emacsclient.wrapper
if command -v emacsclient.wrapper >/dev/null 2>&1 ; then
  export EDITOR=emacsclient.wrapper
else
  export EDITOR='emacs -nw'
fi

export VISUAL="$EDITOR"

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
  # shellcheck source=/dev/null
  . "${SSH_ENV}" > /dev/null
  ps -p "${SSH_AGENT_PID}" > /dev/null || {
    ssh/start-agent
  }
else
  ssh/start-agent
fi

[[ -n "$INSIDE_EMACS" && -n "$SSH_AUTH_SOCK" && -n "$SSH_AGENT_PID" ]] && \
  type -t esetenv > /dev/null 2>&1 && \
  esetenv SSH_AUTH_SOCK SSH_AGENT_PID

# Update GPG_TTY
GPG_TTY=$(/usr/bin/tty)
export GPG_TTY

# Include '.bashrc' if it exists
# shellcheck source=/dev/null
[ -r ~/.bashrc ] && . ~/.bashrc

# Local Variables:
# mode: sh
# End: