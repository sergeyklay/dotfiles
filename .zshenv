#!/usr/bin/env zsh

# Zsh startup file.
#
# This file is sourced on all invokations of zsh.
#   .zshenv -> .zprofile -> .zshrc -> .zlogin

# Used for setting user's environment variables.
# For more see 'man zsh(1)'.

# The base directories for all startup/shutdown files.
ZDOTDIR=${ZDOTDIR:-${HOME}}
ZSHDDIR="${XDG_CONFIG_HOME:-$ZDOTDIR/.config}/zsh"

[ -r $ZSHDDIR/conf.d/gopts ] && source $ZSHDDIR/conf.d/gopts
[ -r $ZSHDDIR/conf.d/defuns ] && source $ZSHDDIR/conf.d/defuns
[ -r $ZSHDDIR/conf.d/editor ] && source $ZSHDDIR/conf.d/editor

# This function tries to setup platoform independed environment
# variables.  This function WILL NOT change previously set veriables
# (if any).
zenv

# OS specific environment.
if [ -r $ZSHDDIR/conf.d/OS/$OSSHORT/zshenv ]; then
  source $ZSHDDIR/conf.d/OS/$OSSHORT/zshenv
fi

# No duplicate entries are needed.
typeset -U path
path=(/usr/local/bin /usr/local/sbin $path /usr/sbin /sbin)

# TODO(serghei): Deprecated
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump"

# Include local bin
[ -e "$HOME/bin" ] && {
  [ -L "$HOME/bin" ] || [ -f "$HOME/bin" ] && {
    path=("$HOME/bin" $path)
  }
}

# rbenv
#
# Only set PATH here to prevent performance degradation.
# For explanation see bellow (LLVM).
rbenvdirs=("$HOME/.rbenv" "/usr/local/opt/rbenv")
for dir in $rbenvdirs; do
  if [[ -d $dir/bin ]]; then
    path=("$dir/bin" $path)
    break
  fi
done

# phpenv
#
# Only set PATH here to prevent performance degradation.
# For explanation see bellow (LLVM).
[ -d "$HOME/.phpenv/bin" ] && {
  path=("$HOME/.phpenv/bin" $path)
}

# php-build
[ -d "$HOME/.phpenv/plugins/php-build/bin" ] && {
  export PHP_BUILD_EXTRA_MAKE_ARGUMENTS=-j"$(getconf _NPROCESSORS_ONLN)"
  [ -d "$HOME/src/php" ] && {
    export PHP_BUILD_TMPDIR="$HOME/src/php"
  }

  path=("$HOME/.phpenv/plugins/php-build/bin" $path)
}

# virtualenv
#
# Only set PATH here to prevent performance degradation.
# For explanation see bellow (LLVM).
[ -d "$HOME/.venv/local/bin" ] && {
  path=("$HOME/.venv/local/bin" $path)
}

# Local binaries
[ -d "$HOME/.local/bin" ] && path=("$HOME/.local/bin" $path)

# Google Cloud SDK
[ -d "$HOME/gcp/bin" ] && path=("$HOME/gcp/bin" $path)

# Go lang local workspace
[ -d /usr/local/go/bin ] && path=(/usr/local/go/bin $path)

# LLVM
#
# Previously I used here 'brew --prefix llvm'
# however, profiling showed a catastrophic performanse regression,
# especially slow start at first time.  This rate is critical for me
# because current file is taken into account by various integrations,
# for example, by Emacs.
[ -d /usr/local/opt/llvm/bin ] && path=(/usr/local/opt/llvm/bin $path)

# QT
#
# For explanation of this design, see above (LLVM).
[ -d /usr/local/opt/qt/bin ] && path=(/usr/local/opt/qt/bin $path)

# kubectl
#
# For explanation of this design, see above (LLVM).
[ -d /usr/local/opt/kubernetes-cli/bin ] &&
  path=(/usr/local/opt/kubernetes-cli/bin $path)

# Add .NET Core SDK tools
[ -d "$HOME/.dotnet/tools" ] && {
  export DOTNET_CLI_TELEMETRY_OPTOUT=1
  path=("$HOME/.dotnet/tools" $path)
}

# Cargo binaries
[ -d $HOME/.cargo/bin ] && path=($HOME/.cargo/bin $path)
[ -d /usr/lib/cargo/bin ] && path=(/usr/lib/cargo/bin $path)

# Go lang local workspace
if [ -d "$HOME/go" ]; then
  export GOPATH="$HOME/go"

  [ -d "$GOPATH/bin" ] && {
    # Put binary files created using "go install" command
    # in "$GOPATH/bin"
    export GOBIN="$GOPATH/bin"
    path=("$GOBIN" $path)
  }

  # Enable the go modules feature
  export GO111MODULE=on
fi

# TinyGo
#
# See: https://github.com/tinygo-org/tinygo
[ -d /usr/local/tinygo/bin ] && path=(/usr/local/tinygo/bin $path)

# hlint
#
# See: https://github.com/ndmitchell/hlint
[ -d "$HOME/.hlint" ] && path=("$HOME/.hlint" $path)

# Cabal
[ -d "$HOME/.cabal/bin" ] && path=("$HOME/.cabal/bin" $path)

# Cask
[ -d "$HOME/.cask/bin" ] && path=("$HOME/.cask/bin" $path)

# Composer
if [ -d "${XDG_CONFIG_HOME:-$ZDOTDIR/.config}/composer" ]; then
  export COMPOSER_HOME="${XDG_CONFIG_HOME:-$ZDOTDIR/.config}/composer"
  export COMPOSER_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/composer"

  [ -d "$COMPOSER_HOME/vendor/bin" ] &&
    path=("$COMPOSER_HOME/vendor/bin" $path)
fi

# The next line updates PATH for the Google Cloud SDK.
[ -f $HOME/gcp/path.zsh.inc ] && source $HOME/gcp/path.zsh.inc

export PATH

[ -r $ZSHDDIR/conf.d/mans ] && source $ZSHDDIR/conf.d/mans

# Local Variables:
# mode: sh
# End:
