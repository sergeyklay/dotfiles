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

# --------------------------------------------------------------------
# Setup PATHs
# --------------------------------------------------------------------

if ! command -v add_path >/dev/null 2>&1; then
  # Add a directory to PATH if it's not already present.
  add_path() {
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

if [ "$(uname)" = "Darwin" ]; then
  if [ -d /opt/homebrew/bin ]; then
    add_path /opt/homebrew/bin
  fi

  if [ -d /opt/homebrew/opt/coreutils/libexec/gnubin ]; then
    add_path /opt/homebrew/opt/coreutils/libexec/gnubin
  fi

  if [ -d /opt/homebrew/opt/mysql-client/bin ]; then
    add_path /opt/homebrew/opt/mysql-client/bin
  fi

  if [ -d /opt/homebrew/opt/libpq/bin ]; then
    add_path /opt/homebrew/opt/libpq/bin
  fi

  if [ -d "$HOME/Library/Application Support/Coursier/bin" ]; then
    add_path "$HOME/Library/Application Support/Coursier/bin"
  fi
fi

if [ -d "$HOME/go" ]; then
  GOPATH="$HOME/go"
  export GOPATH

  [ -d $GOPATH/bin ] && {
    # Put binary files created using "go install" command
    # in "$GOPATH/bin"
    GOBIN="$GOPATH/bin"
    export GOBIN
    add_path "$GOBIN"
  }
fi

if [ -d "$HOME/.cabal/bin" ]; then
  add_path "$HOME/.cabal/bin"
fi

if [ -d "$HOME/.cask/bin" ]; then
  add_path "$HOME/.cask/bin"
fi

if [ -d "$HOME/bin" ]; then
  add_path "$HOME/bin"
fi

# Should be last, so that I can override any binary path
if [ -d "$HOME/.local/bin" ]; then
  add_path "$HOME/.local/bin"
fi

# --------------------------------------------------------------------
# Setup MANPATHs
# --------------------------------------------------------------------

if ! command -v add_manpath >/dev/null 2>&1; then
  # Add a directory to MANPATH if it's not already present.
  add_manpath() {
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

if [ "$(uname)" = "Darwin" ]; then
  if [ -d /Library/Apple/usr/share/man ]; then
    add_manpath /Library/Apple/usr/share/man
  fi
fi

if [ -d "$HOME/share/man" ]; then
  add_manpath "$HOME/share/man"
fi

# --------------------------------------------------------------------
# Setup INFOPATHs
# --------------------------------------------------------------------

if ! command -v add_infopath >/dev/null 2>&1; then
  # Add a directory to MANPATH if it's not already present.
  add_infopath() {
    if ! echo "$INFOPATH" | grep -q -E "(^|:)$1($|:)"; then
      if [ "$INFOPATH" = "" ]; then
        INFOPATH="$1"
      else
        if [ "$2" = "after" ]; then
          INFOPATH="$INFOPATH:$1"
        else
          INFOPATH="$1:$INFOPATH"
        fi
      fi
    fi
    export INFOPATH
  }
fi

# Only do this if the INFOPATH variable isn't already set.
if [ -z "${INFOPATH+x}" ] || [ "$INFOPATH" = ":" ]; then
  INOPATH=""
fi

if [ "$(uname)" = "Darwin" ]; then
  if [ -d /opt/homebrew/share/info ]; then
    add_infopath /opt/homebrew/share/info
  fi

  if [ -d /Applications/Emacs.app/Contents/Resources/info ]; then
    add_infopath /Applications/Emacs.app/Contents/Resources/info
  fi
fi

# --------------------------------------------------------------------
# Setup Locales
# --------------------------------------------------------------------

LANG=en_US.UTF-8;   export LANG
LC_ALL=en_US.UTF-8; export LC_ALL

# --------------------------------------------------------------------
# Setup Editor
# --------------------------------------------------------------------

# Editor to fallback to if the server is not running.  If this
# variable is empty, then start GNU Emacs in daemon mode and try
# connecting again.
ALTERNATE_EDITOR=''
export ALTERNATE_EDITOR

EDITOR='emacsclient -c -nw -a ""'
export EDITOR

VISUAL="$EDITOR"
export VISUAL

# More for less
if [[ $TERM == "dumb" ]] ; then
  PAGER=cat
else
  PAGER=less
fi
export PAGER

if [[ $TERM != "dumb" ]]; then
  # -X will leave the text in your Terminal, so it doesn't disappear
  #    when you exit less.
  # -F will exit less if the output fits on one screen (so you don't
  #    have to press "q").
  # -R ANSI "color" escape sequences are output in "raw" form.
  #
  # See: https://unix.stackexchange.com/q/38634/50400
  LESS="-X -F -R"
  LESSCHARSET=UTF-8
  LESSHISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/lesshst"
  export LESS LESSCHARSET LESSHISTFILE
fi

# Set the Less input preprocessor.
# Try to find either `lesspipe` or `lesspipe.sh` in the system path.
#
# Install using: `brew install lesspipe` on macOS
if [ -z "$LESSOPEN" ]; then
  # Check for the existence of lesspipe or lesspipe.sh
  if command -v lesspipe >/dev/null 2>&1; then
    LESSOPEN="| /usr/bin/env lesspipe %s 2>&-"
  elif command -v lesspipe.sh >/dev/null 2>&1; then
    LESSOPEN="| /usr/bin/env lesspipe.sh %s 2>&-"
  fi
  [ -n "$LESSOPEN" ] && export LESSOPEN
fi

# --------------------------------------------------------------------
# Setup interactive shell (if needed)
# --------------------------------------------------------------------

if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# Local Variables:
# mode: sh
# End:
