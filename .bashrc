# Copyright (C) 2014-2025 Serghei Iakovlev <gnu@serghei.pl>
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

# User wide interactive shell configuration and executing commands.
#
# This file is sourced by the second for login shells (after
# '~/.profile').  Or by the first for interactive non-login shells.

# shellcheck shell=bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Some app and vitual terminals unable in login shells
if [ -z "${BASH_PROFILE_SOURCED+x}" ]; then
  if [ -f "$HOME/.bash_profile" ]; then
    source "$HOME/.bash_profile"
  fi
fi

# Auto-fix minor typos in interactive use of 'cd'
shopt -q -s cdspell

# Bash can automatically prepend cd when entering just a path in
# the shell
shopt -q -s autocd

# Case-insensitive globbing (used in pathname expansion).
shopt -s nocaseglob

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS
shopt -q -s checkwinsize

# Don't let Ctrl-D exit the shell
set -o ignoreeof

# Immediate notification of background job termination
set -o notify

# --------------------------------------------------------------------
# History
# --------------------------------------------------------------------

# Append to the history file, don't overwrite it
shopt -s histappend

# Bash attempts to save all lines of a multiple-line command in the
# same history entry.  This allows easy re-editing of multi-line
# commands.
shopt -q -s cmdhist

# See man -P 'less -rp HISTCONTROL' bash
HISTCONTROL="erasedups:ignoreboth"

# The number of commands in history stack in memory
HISTSIZE=5000

# Maximum number of history lines
HISTFILESIZE=10000

# For the protection and ability for future analyzing
HISTTIMEFORMAT="%h %d %H:%M:%S "

# Omit:
#  &            duplicates
#  [ ]        lines starting with spaces
#  history *    history command
#  cd -*/cd +*  navigation on directory stack
HISTIGNORE='&:[ ]*:history *:cd -*[0-9]*:cd +*[0-9]*'

# Save commands immediately after use to have shared history
# between Bash sessions.
#  'history -a'  append the current history to the history file
#  'history -c'  clear the history list
#  'history -r'  read the history file and append its contents to
#                the history list.
PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND}"

if [ -f ~/.config/dirstack.sh ]; then
  . ~/.config/dirstack.sh
fi

# --------------------------------------------------------------------
# Utils
# --------------------------------------------------------------------

if [ -f ~/.config/proctools.sh ]; then
  . ~/.config/proctools.sh
fi

# --------------------------------------------------------------------
# DE setup
# --------------------------------------------------------------------

# Check if running under Wayland
if [ "$XDG_SESSION_TYPE" = "wayland" ] || [ -n "$WAYLAND_DISPLAY" ]; then
    # Set environment variables for Wayland compatibility
    GDK_BACKEND=wayland
    QT_QPA_PLATFORM=wayland
    export GDK_BACKEND QT_QPA_PLATFORM

    # Optimize Java AWT for non-reparenting window managers.
    # See: https://wiki.archlinux.org/title/Sway#Java_applications
    _JAVA_AWT_WM_NONREPARENTING=1
    export _JAVA_AWT_WM_NONREPARENTING

    # Enable native Wayland support for Firefox
    MOZ_ENABLE_WAYLAND=1
    export MOZ_ENABLE_WAYLAND

    # Force Clutter to use Wayland backend
    CLUTTER_BACKEND=wayland
    export CLUTTER_BACKEND

    # Force SDL to use Wayland video driver
    SDL_VIDEODRIVER=wayland
    export SDL_VIDEODRIVER
else
    # Not a Wayland session, do nothing
    :
fi

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
# Bash completion
# --------------------------------------------------------------------

if [ "$(uname)" = "Darwin" ] && command -v brew >/dev/null 2>&1; then
  __brew_prefix=$(brew --prefix)

  # brew install bash-completion
  if [ -f "$brew_prefix"/etc/bash_completion ]; then
    . "$brew_prefix"/etc/bash_completion
  elif [ -f "$brew_prefix"/etc/profile.d/bash_completion.sh ]; then
    # brew install bash-completion@2
    if [ -d "$brew_prefix"/etc/bash_completion.d ]; then
      BASH_COMPLETION_COMPAT_DIR="$brew_prefix"/etc/bash_completion.d
      export BASH_COMPLETION_COMPAT_DIR
    fi

    . "$brew_prefix"/etc/profile.d/bash_completion.sh
  fi

  unset __brew_prefix
elif ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# --------------------------------------------------------------------
# Setup colors
# --------------------------------------------------------------------

# Default to no color.
color_prompt=no

# Check explicit color preferences.
if [ "${COLORTERM:-}" = "truecolor" ]           \
     || [ "${COLORTERM:-}" = "24bit" ]          \
     || [ "${COLORTERM:-}" = "1" ]              \
     || [ "${COLORTERM:-}" = "gnome-terminal" ] \
     || [ "${USE_ANSI_COLORS:-}" = "true" ]     \
     || [ "$TERM" = "xterm-256color" ]          \
     || tput setaf 1 >/dev/null 2>&1; then
  color_prompt=yes
else
  # Detect support for colors based on terminal type.
  case "$TERM" in
    *-256color) color_prompt=yes;;
    xterm | xterm-color) color_prompt=yes;;
  esac

  # Fallback to terminfo detection if no explicit preference is
  # found.
  if [ "$color_prompt" = "no" ]; then
    if command -v tput >/dev/null 2>&1; then
      if tput setaf 1 >/dev/null 2>&1; then
        color_prompt=yes
      fi
    fi
  fi
fi

if [ "$colors_support" = true ]; then
  # colorize gcc output
  GCC_COLORS='error=01;31:'
  GCC_COLORS+='warning=01;35:'
  GCC_COLORS+='note=01;36:'
  GCC_COLORS+='caret=01;32:'
  GCC_COLORS+='locus=01:'
  GCC_COLORS+='quote=01'
  export GCC_COLORS

  [[ -z "$COLORTERM" ]] || COLORTERM=1
  [[ -z "$CLICOLOR" ]]  || CLICOLOR=1
  export CLICOLOR COLORTERM
fi
unset colors_support

# Enable color support of ls and also add handy aliases
if [ "$(uname)" = "Darwin" ]; then
  if command -v dircolors >/dev/null 2>&1; then
    if [ -f ~/.dircolors ]; then
      eval "$(dircolors -b ~/.dircolors)"
    else
      eval "$(dircolors -b)"
    fi
  fi
else
  if command -v gdircolors >/dev/null 2>&1; then
    if [ -f ~/.dircolors ]; then
      eval "$(gdircolors -b ~/.dircolors)"
    else
      eval "$(gdircolors -b)"
    fi
  fi
fi

# --------------------------------------------------------------------
# Setup aliases
# --------------------------------------------------------------------

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi


# --------------------------------------------------------------------
# Initialize pyenv
# --------------------------------------------------------------------

# Check if PYENV_SHELL is not set
if [ -z "${PYENV_SHELL+x}" ]; then
  # Check if the pyenv command exists
  if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"

    # Check if pyenv has the virtualenv-init command
    if pyenv commands | grep -q virtualenv-init; then
      eval "$(pyenv virtualenv-init -)"
    fi

    # Disable the virtualenv prompt
    PYENV_VIRTUALENV_DISABLE_PROMPT=1
    export PYENV_VIRTUALENV_DISABLE_PROMPT
  fi
fi

# --------------------------------------------------------------------
# Setup Ruby Env Manager
# --------------------------------------------------------------------

if [[ -z "${RBENV_SHELL+x}" ]]; then
  if [[ -d "$HOME/.rbenv" && -r "$HOME/.rbenv/bin/rbenv" ]]; then
    eval "$("$HOME/.rbenv/bin/rbenv" init - --no-rehash bash)"
  fi
fi

# --------------------------------------------------------------------
# Setup Nodejs
# --------------------------------------------------------------------

setup_nvm() {
  local nvm_dirs=()

  [ -n "$XDG_CONFIG_HOME" ] && nvm_dirs+=("${XDG_CONFIG_HOME}/nvm")
  nvm_dirs+=("$HOME/.nvm" "${XDG_CONFIG_HOME:-$HOME/.config}/nvm")

  for d in "${nvm_dirs[@]}"; do
    if [ -d "$d" ]; then
      NVM_DIR="${d}"
      # If nvm.sh exists and is readable, source it and exit the loop
      if [ -r "$NVM_DIR/nvm.sh" ]; then
        export NVM_DIR

        # Do not use NPM_CONFIG_PREFIX env var when nvm is used.
        # nvm is not compatible with the NPM_CONFIG_PREFIX env var.
        unset NPM_CONFIG_PREFIX

        if [ -s "$NVM_DIR/nvm.sh" ]; then
          . "$NVM_DIR/nvm.sh"
        fi

        if [ -s "$NVM_DIR/bash_completion" ]; then
          . "$NVM_DIR/bash_completion"
        fi

        return 0
      fi
    fi
  done

  return 0
}

if [[ -z "${NVM_DIR+x}" ]]; then
  setup_nvm
fi

export -f setup_nvm

# Do not use NPM_CONFIG_PREFIX env var when nvm is used.
# nvm is not compatible with the NPM_CONFIG_PREFIX env var.
if [ -z "$NVM_DIR" ]; then
  # Resolving EACCES permissions errors when installing packages globally.
  NPM_CONFIG_PREFIX="$HOME/.local/"
  export NPM_CONFIG_PREFIX
fi

# --------------------------------------------------------------------
# Setup direnv
# --------------------------------------------------------------------

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook bash)"
fi

# --------------------------------------------------------------------
# Misc functions and aliases
# --------------------------------------------------------------------

function cursor {
  local app="$HOME/Applications/cursor.appimage"
  local wayland_args=""
  local base_args="--no-sandbox"

  # Validate appimage exists and is executable
  if [ ! -f "$app" ] || [ ! -x "$app" ]; then
    echo "Error: Cursor appimage not found or not executable at $app" >&2
    return 1
  fi

  # Add Wayland support if running under Wayland
  if [ "$XDG_SESSION_TYPE" = "wayland" ] || [ -n "$WAYLAND_DISPLAY" ]; then
    wayland_args="--ozone-platform=wayland"
  fi

  # Run with no arguments - open Cursor
  if [[ $# = 0 ]]; then
    (nohup "$app" $base_args $wayland_args >/dev/null 2>&1 & disown)
  else
    (nohup "$app" $base_args $wayland_args "$@" >/dev/null 2>&1 & disown)
  fi
}

# --------------------------------------------------------------------
# Setup Bash prompt
# --------------------------------------------------------------------

show_virtual_env() {
  if [ -n "$VIRTUAL_ENV_PROMPT" ]; then
    echo "${VIRTUAL_ENV_PROMPT} "
  elif [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
    echo "($(basename $VIRTUAL_ENV)) "
  else
    echo ""
  fi
}

export -f show_virtual_env

__prompt_command() {
  local exit_code="$?"

  local rcol=''
  local bldylw=''
  local bldblu=''
  local bldblk=''
  local bldred=''

  if [ "${COLORTERM:-}" = "truecolor" ]       \
       || [ "${COLORTERM:-}" = "24bit" ]      \
       || [ "${COLORTERM:-}" = "1" ]          \
       || [ "${CLICOLOR:-}" = "1" ]           \
       || [ "${USE_ANSI_COLORS:-}" = "true" ] \
       || [ "$TERM" = "xterm-256color" ]      \
       || tput setaf 1 >/dev/null 2>&1; then
    rcol='\[\e[0m\]'
    bldylw='\[\e[1;33m\]'
    bldblu='\[\e[1;34m\]'
    bldblk='\[\e[1;30m\]'
    bldred='\[\e[1;31m\]'
  fi

  PS1='$(show_virtual_env)'

  PS1+="${bldblk}"
  PS1+='\u@\h'
  PS1+="${rcol}"

  if [ $exit_code != 0 ]; then
    PS1+=" [${bldred}${exit_code}${rcol}]"
  fi

  PS1+=" ${bldblu}"
  PS1+='\w'

  local b="$(git symbolic-ref HEAD 2>/dev/null)";
  if [ -n "$b" ]; then
    PS1+="${rcol} ${bldylw}${b##refs/heads/}"
  fi

  PS1+="${rcol}"
  PS1+='\n\$ '
}

PROMPT_COMMAND="__prompt_command; ${PROMPT_COMMAND}"
PS2='> '

# Local Variables:
# mode: sh
# End:
