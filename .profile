# Copyright (C) 2014-2024 Serghei Iakovlev <gnu@serghei.pl>
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

# --------------------------------------------------------------------
# User-specific environment and startup programs configuration.
#
# This file is executed for login shells only. It serves as a
# universal profile setup for defining environment variables, PATH
# adjustments, and system-wide startup configurations.
#
# Recommended Usage:
# - Define global environment variables (e.g., PATH, LANG).
# - Setup PATH for system and user-specific binaries.
# - Initialize user agents or services (e.g., ssh-agent, gpg-agent).
#
# Restrictions:
# - Avoid interactive commands (e.g., aliases, functions meant for
#   interactive use).
# - Do not place shell-specific configurations here (e.g., bash
#   aliases should go in ~/.bashrc).
# - Avoid commands that produce output, to prevent side effects in
#   non-interactive contexts.
#
# Notes:
# - ~/.profile should be compatible with any POSIX-compliant shell
#   (sh, bash, etc.).
# - When used with Bash, this file often sources ~/.bashrc to maintain
#   a unified environment.
# --------------------------------------------------------------------

# shellcheck shell=sh

if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# --------------------------------------------------------------------
# Setup PATHs
# --------------------------------------------------------------------

if ! command -v pathmunge >/dev/null 2>&1; then
  # Add a directory to PATH if it's not already present.
  pathmunge() {
    if ! echo "$PATH" | grep -q -E "(^|:)$1($|:)" ; then
      if [ "$2" = "after" ]; then
        PATH="$PATH:$1"
      else
        PATH="$1:$PATH"
      fi
    fi
    export PATH
  }
fi

if [ -d "/opt/homebrew/bin" ]; then
  pathmunge "/opt/homebrew/bin"
fi

if [ -d /opt/homebrew/opt/mysql-client/bin ]; then
  pathmunge /opt/homebrew/opt/mysql-client/bin
fi

if [ -d /opt/homebrew/opt/libpq/bin ]; then
  pathmunge /opt/homebrew/opt/libpq/bin
fi

if [ -d "$HOME/Library/Application Support/Coursier/bin" ]; then
  pathmunge "$HOME/Library/Application Support/Coursier/bin"
fi

if [ -d /opt/homebrew/opt/m4/bin ]; then
  pathmunge /opt/homebrew/opt/m4/bin
fi

if [ -d "$HOME/go" ]; then
  GOPATH="$HOME/go"
  export GOPATH

  [ -d $GOPATH/bin ] && {
    # Put binary files created using "go install" command
    # in "$GOPATH/bin"
    GOBIN="$GOPATH/bin"
    export GOBIN
    pathmunge "$GOBIN"
  }
fi

if [ -d "$HOME/.cabal/bin" ]; then
  pathmunge "$HOME/.cabal/bin"
fi

if [ -d "$HOME/.cask/bin" ]; then
  pathmunge "$HOME/.cask/bin"
fi

if [ -d "$HOME/bin" ]; then
  pathmunge "$HOME/bin"
fi

# Should be last, so that I can override any binary path
if [ -d "$HOME/.local/bin" ]; then
  pathmunge "$HOME/.local/bin"
fi

# --------------------------------------------------------------------
# Setup MANPATHs
# --------------------------------------------------------------------

if ! command -v manpathmunge >/dev/null 2>&1; then
  # Add a directory to MANPATH if it's not already present.
  manpathmunge() {
    if ! echo "$MANPATH" | grep -q -E "(^|:)$1($|:)"; then
      if [ "$2" = "after" ]; then
        MANPATH="$MANPATH:$1"
      else
        MANPATH="$1:$MANPATH"
      fi
    fi
    export MANPATH
  }
fi

# Only do this if the MANPATH variable isn't already set.
if [ -z "${MANPATH+x}" ] || [ "$MANPATH" = ":" ]; then
  if command -v manpath >/dev/null 2>&1; then
    # Get the original manpath, then modify it bellow
    MANPATH="$(manpath 2>/dev/null)"
  else
    MANPATH=""
  fi
fi

if [ -d "$HOME/share/man" ]; then
  manpathmunge "$HOME/share/man"
fi

# Local Variables:
# mode: sh
# End:
