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

# Homebrew on Apple Silicon
if [ -d /opt/homebrew/bin ]; then
  pathmunge /opt/homebrew/bin
fi

# Include alternate sbin
if [ -d /usr/local/sbin ]; then
  pathmunge /usr/local/sbin
elif [ -d /opt/homebrew/sbin ]; then
  pathmunge /opt/homebrew/sbin
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

# The next line updates PATH for the Google Cloud SDK.
if [ -d ~/gcp/bin ]; then
  pathmunge ~/gcp/bin
fi

if [ -r ~/gcp/path.bash.inc ]; then
  # shellcheck disable=SC1090
  . ~/gcp/path.bash.inc
fi

# Apache Maven
# See: https://maven.apache.org/install.html
if [ -d ~/opt/apache-maven/bin ]; then
  pathmunge ~/opt/apache-maven/bin
fi

# OS specific PATHs
[ -r "$BASHD_ROOT/conf.d/OS/$OSSHORT/paths.sh" ] && {
  # shellcheck disable=SC1090
  . "$BASHD_ROOT/conf.d/OS/$OSSHORT/paths.sh"
}

export PATH

# Local Variables:
# mode: sh
# End:
