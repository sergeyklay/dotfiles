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

# This file contains the configuration of PATH variable

# shellcheck shell=bash

# Load pathmunge function
autoload pathmunge

# Include alternate sbin
if [ -d /usr/local/sbin ]; then
  pathmunge /usr/local/sbin
fi

# Home binaries
if [ -e ~/bin ]; then
  if [ -L ~/bin ] || [ -d ~/bin ]; then
    pathmunge ~/bin
  fi
fi

# Local binaries
if [ -d ~/.local/bin ]; then
  pathmunge ~/.local/bin
fi

# Add .NET Core SDK tools
if [ -d ~/.dotnet/tools ]; then
  DOTNET_CLI_TELEMETRY_OPTOUT=1
  export DOTNET_CLI_TELEMETRY_OPTOUT
  pathmunge ~/.dotnet/tools
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

# OS specific aliases.
[ -r "$BASHD_ROOT/conf.d/OS/$OSSHORT/paths.sh" ] && {
  # shellcheck disable=SC1090
  . "$BASHD_ROOT/conf.d/OS/$OSSHORT/paths.sh"
}

export PATH

if command -v systemctl >/dev/null 2>&1 ; then
  systemctl --user import-environment PATH >/dev/null
fi

# Local Variables:
# mode: sh
# End:
