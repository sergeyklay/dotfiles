#!/usr/bin/env zsh
#
# Zsh startup file.
#
# Used for setting user's environment variables.
#

# No duplicate entries are needed.
typeset -U path
path=(/usr/local/bin /usr/bin /bin /usr/local/sbin /usr/sbin /sbin)

export LC_ALL='en_US.UTF-8'
export LC_TYPE='en_US.UTF-8'
export LANG='en_US.UTF-8'

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

[ ! -d "$XDG_CACHE_HOME/zsh" ] && mkdir -p "$XDG_CACHE_HOME/zsh"

export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
export ZSH_COMPDUMP="$ZSH_CACHE_DIR/zcompdump"

export HOSTNAME=$(hostname)

# MANPATH: path for the man command to search.
# Look at the manpath command's output and prepend
# my own manual paths manually.
if [ -z "$MANPATH" ]
then
  # Only do this if the MANPATH variable isn't already set.
  if whence manpath >/dev/null 2>&1
  then
    # Get the original manpath, then modify it.
    MANPATH="`manpath`"
    manpath=(
      "$HOME/man"
      /opt/man
      /usr/local/share/man
      /usr/local/man
      /usr/share/man
      /usr/man
      "$manpath[@]"
    )
  else
    # This list is out of date, but it will suffice.
    manpath=(
      "$HOME/man"
      /opt/man
      /usr/local/share/man
      /usr/local/man
      /usr/share/man
      /usr/man
    )
  fi

  # No duplicate entries are needed.
  typeset -U manpath
  export MANPATH
fi

# See: https://github.com/sergeyklay/.emacs.d
#
# To run GNU Emacs in server mode see:
# https://www.gnu.org/software/emacs/manual/html_node/emacs/Emacs-Server.html
#
# $EDITOR should open in terminal
# $VISUAL opens in GUI with non-daemon as alternate
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"
export VISUAL="emacsclient -c -a emacs"

export VIEWER=less

# More for less
export PAGER=less

if [ -f /usr/local/bin/lesspipe.sh ]
then
  # brew install lesspipe
  export LESSOPEN="| lesspipe.sh %s";
elif [ -x /usr/bin/lesspipe ]
then
  # Linux way
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

export LESSHISTFILE="$XDG_CACHE_HOME/lesshst"

export BREW_BIN="$(command -v brew 2>/dev/null || true)"
export KUBECTL_BIN="$(command -v kubectl 2>/dev/null || true)"

# Include local bin
[ -e "$HOME/bin" ] && {
  [ -L "$HOME/bin" ] || [ -f "$HOME/bin" ] && {
    path+=("$HOME/bin")
  }
}

# Local binaries
[ -d "$HOME/.local/bin" ] && path+=("$HOME/.local/bin")

# Google Cloud SDK
[ -d "$HOME/gcp/bin" ] && path+=("$HOME/gcp/bin")

# Go lang local workspace
[ -d /usr/local/go/bin ] && path+=(/usr/local/go/bin)

# LLVM
#
# Previously I used here 'brew --prefix llvm'
# however, profiling showed a catastrophic performanse regression,
# especially slow start at first time.  This rate is critical for me
# because current file is taken into account by various integrations,
# for example, by Emacs.
[ -d /usr/local/opt/llvm/bin ] && path+=(/usr/local/opt/llvm/bin)

# QT
#
# To explain the reasons for this design, see above (LLVM).
[ -d /usr/local/opt/qt/bin ] && path+=(/usr/local/opt/qt/bin)

# kubectl
#
# To explain the reasons for this design, see above (LLVM).
[ -d /usr/local/opt/kubernetes-cli/bin ] &&
  path+=(/usr/local/opt/kubernetes-cli/bin)

# Go lang local workspace
if [ -d "$HOME/go" ]
then
  export GOPATH="$HOME/go"

  [ ! -d "$GOPATH/bin" ] && mkdir -p "$GOPATH/bin"

  # Put binary files created using "go install" command
  # in "$GOPATH/bin"
  export GOBIN="$GOPATH/bin"
  path+=("$GOBIN")

  # Enable the go modules feature
  export GO111MODULE=on
fi

# TinyGo
#
# See: https://github.com/tinygo-org/tinygo
[ -d /usr/local/tinygo/bin ] && path+=(/usr/local/tinygo/bin)

# hlint
#
# See: https://github.com/ndmitchell/hlint
[ -d "$HOME/.hlint" ] && path+=("$HOME/.hlint")

# Cabal
[ -d "$HOME/.cabal/bin" ] && path+=("$HOME/.cabal/bin")

# Cask
[ -d "$HOME/.cask/bin" ] && path+=("$HOME/.cask/bin")

# Composer
if [ -d "$XDG_CONFIG_HOME/composer" ]
then
  export COMPOSER_HOME="$XDG_CONFIG_HOME/composer"
  export COMPOSER_CACHE_DIR="$XDG_CACHE_HOME/composer"

  [ -d "$COMPOSER_HOME/vendor/bin" ] && path+=("$COMPOSER_HOME/vendor/bin")
fi

# Disabled.
#
# There are some issues, for example see:
# https://github.com/linux-test-project/lcov/issues/37
#
# export MAKEFLAGS="-j$(getconf _NPROCESSORS_ONLN)"

export PATH

# Local Variables:
# mode: sh
# End:
