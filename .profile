# ~/.profile
#
# User wide environment and startup programs, for login setup.
#
# This file is sourced by the first for login shells.

# Editor to fallback to if the server is not running.  If this
# variable is empty, then start GNU Emacs in daemon mode and try
# connecting again.
export ALTERNATE_EDITOR=''

# See:
# https://github.com/sergeyklay/.emacs.d/blob/master/bin/emacsclient.wrapper
export EDITOR=emacsclient.wrapper
export VISUAL=$EDITOR

alias ec=$EDITOR

# A workaround to get OS name on Linux and macOS systems
export OS="$(uname -o 2>/dev/null || uname -s)"

# HOSTNAME contains name of the machine, as known to applications
# that run locally
if [ x$HOSTNAME = x ]; then
  if command -v hostname >/dev/null 2>&1; then
    export HOSTNAME=$(hostname -s)
  else
    export HOSTHAME=localhost
  fi
fi

# HOST contains long host name (FQDN)
if [ x$HOST = x ]; then
  if command -v hostname >/dev/null 2>&1; then
    export HOST=$(hostname -f)
  else
    export HOST="${HOSTNAME}.localdomain"
  fi
fi

case $OS in
  Darwin)
    # See: https://stackoverflow.com/q/7165108/1661465
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    ;;
  *Linux)
    [ -r ${XDG_CONFIG_HOME:-~/.config}/xdg-dirs ] && {
      . ${XDG_CONFIG_HOME:-~/.config}/xdg-dirs
    }
    ;;
esac

# Custom Bash functions
for file in ~/profile.d/*.sh; do
  source ${file} || true;
done

# Include local bin
[ -e ~/bin ] && {
  [ -L ~/bin ] || [ -d ~/bin ] && {
    pathmunge "$HOME/bin"
  }
}


# LLVM
#
# Previously I used here 'brew --prefix llvm'
# however, profiling showed a catastrophic performanse regression,
# especially slow start at first time.  This rate is critical for me
# because current file is taken into account by various integrations,
# for example, by Emacs.
[ -d /usr/local/opt/llvm/bin ] && pathmunge /usr/local/opt/llvm/bin

# QT
#
# For explanation of this design, see above (LLVM).
[ -d /usr/local/opt/qt/bin ] && pathmunge /usr/local/opt/qt/bin

# kubectl
#
# For explanation of this design, see above (LLVM).
[ -d /usr/local/opt/kubernetes-cli/bin ] &&
  pathmunge /usr/local/opt/kubernetes-cli/bin

# Add .NET Core SDK tools
[ -d ~/.dotnet/tools ] && {
  export DOTNET_CLI_TELEMETRY_OPTOUT=1
  pathmunge "$HOME/.dotnet/tools"
}

# rbenv
#
# Only set PATH here to prevent performance degradation.
# For explanation see bellow (LLVM).
for dir in ~/.rbenv "/usr/local/opt/rbenv"; do
  if [[ -d "$dir/bin" ]]; then
    pathmunge "$dir/bin"
    break
  fi
done

# phpenv
#
# Only set PATH here to prevent performance degradation.
# For explanation see bellow (LLVM).
[ -d ~/.phpenv/bin ] && {
  pathmunge "$HOME/.phpenv/bin"
}

# php-build
[ -d ~/.phpenv/plugins/php-build/bin ] && {
  export PHP_BUILD_EXTRA_MAKE_ARGUMENTS=-j"$(getconf _NPROCESSORS_ONLN)"
  [ -d "$HOME/src/php" ] && {
    export PHP_BUILD_TMPDIR="$HOME/src/php"
  }

  pathmunge "$HOME/.phpenv/plugins/php-build/bin"
}

# Local binaries
[ -d ~/.local/bin ] && pathmunge "$HOME/.local/bin"

# Google Cloud SDK
[ -d ~/gcp/bin ] && pathmunge "$HOME/gcp/bin"

# Go lang local workspace
[ -d /usr/local/go/bin ] && pathmunge /usr/local/go/bin

# Cargo binaries
[ -d ~/.cargo/bin ] && pathmunge "$HOME/.cargo/bin"
[ -d /usr/lib/cargo/bin ] && pathmunge /usr/lib/cargo/bin

# Go lang local workspace
if [ -d ~/go ]; then
  export GOPATH="$HOME/go"

  [ -d "$GOPATH/bin" ] && {
    # Put binary files created using "go install" command
    # in "$GOPATH/bin"
    export GOBIN="$GOPATH/bin"
    pathmunge "$GOBIN"
  }

  export GO111MODULE=on
fi

# TinyGo
#
# See: https://github.com/tinygo-org/tinygo
[ -d /usr/local/tinygo/bin ] && pathmunge /usr/local/tinygo/bin

# hlint
#
# See: https://github.com/ndmitchell/hlint
[ -d ~/.hlint ] && pathmunge "$HOME/.hlint"

# Cabal
[ -d ~/.cabal/bin ] && pathmunge "$HOME/.cabal/bin"

# Cask
[ -d ~/.cask/bin ] && pathmunge "$HOME/.cask/bin"

# Composer
if [ -d "${XDG_CONFIG_HOME:-~/.config}/composer" ]; then
  export COMPOSER_HOME="${XDG_CONFIG_HOME:-~/.config}/composer"
  export COMPOSER_CACHE_DIR="${XDG_CACHE_HOME:-~/.cache}/composer"

  [ -d "$COMPOSER_HOME/vendor/bin" ] &&
    pathmunge "$COMPOSER_HOME/vendor/bin"
fi

# The next line updates PATH for the Google Cloud SDK.
[ -f ~/gcp/path.zsh.inc ] && . ~/gcp/path.zsh.inc

# This file is accessible not only by Bash, thus we need make
# sure we're in Bash
if [ -n "$BASH_VERSION" ]; then
  # Include '.bashrc' if it exists
  [ -r ~/.bashrc ] && . ~/.bashrc
fi

# Local Variables:
# mode: sh
# End:
