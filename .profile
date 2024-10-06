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

# Check if PYENV_ROOT is not set and .pyenv directory exists
if [ -z "${PYENV_ROOT+x}" ] && [ -d "$HOME/.pyenv" ]; then
  PYENV_ROOT="$HOME/.pyenv"
  export PYENV_ROOT
fi

# If PYENV_ROOT is set and its bin directory exists, add it to PATH
if [ -n "${PYENV_ROOT+x}" ] && [ -d "$PYENV_ROOT/bin" ]; then
  add_path "$PYENV_ROOT/bin"
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

  # brew install readline
  if [ -d /opt/homebrew/opt/readline/share/man ]; then
    add_manpath /opt/homebrew/opt/readline/share/man
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

  # brew install readline
  if [ -d /opt/homebrew/opt/readline/share/info ]; then
    add_infopath /opt/homebrew/opt/readline/share/info
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
# Setup GnuPG
# --------------------------------------------------------------------

GNUPGHOME=${GNUPGHOME:-$HOME/.gnupg}
export GNUPGHOME

# Enable gpg-agent if it is not running
if command -v gpgconf >/dev/null 2>&1 && \
    command -v gpg-agent >/dev/null 2>&1; then
  if [ -z "$(pgrep -x gpg-agent)" ] || \
       [ ! -S "$(gpgconf --list-dirs agent-socket)" ]; then
    gpg-agent \
      --homedir "$GNUPGHOME" \
      --daemon \
      --use-standard-socket >/dev/null 2>&1
  fi
fi

# Update GPG_TTY.  See 'man 1 gpg-agent'.
GPG_TTY="${TTY:-$(tty)}"
export GPG_TTY

# Using a PGP key for SSH authentication if it's enabled.
#
# Once gpg-agent is running the list of approved keys
# should be stored in the $GNUPGHOME/sshcontrol file
# (unless you have your GPG key on a keycard).  Consider
# the following example to see the general idea:
#
#    $ rm ~/.gnupg/sshcontrol
#    $ ssh-add -l
#    The agent has no identities.
#    $ echo YOUR_KEYGRIP > ~/.gnupg/sshcontrol
#    $ ssh-add -l
#    4096 SHA256:YOUR_KEY_HERE (none) (RSA)
#
# Note: This feature requires a key with the Authentication
# capability.  To check key copability see:
#
#    $ grep '\[A]' <(gpg -K your@id.here)
#
if command -v gpgconf >/dev/null 2>&1; then
  if [ "$(gpgconf --list-options gpg-agent 2>/dev/null | \
    grep '^enable-ssh-support:' | cut -d: -f10)" = "1" ]; then
    unset SSH_AGENT_PID
    if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" != "$$" ]; then
      SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
      export SSH_AUTH_SOCK
    fi
  fi
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
