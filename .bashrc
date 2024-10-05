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

# User wide interactive shell configuration and executing commands.
#
# This file is sourced by the second for login shells (after
# '~/.profile').  Or by the first for interactive non-login shells.

# shellcheck shell=bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

for file in ~/.aliases; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Autocorrect typos in path names when using `cd`.
shopt -s cdspell

# Case-insensitive globbing (used in pathname expansion).
shopt -s nocaseglob

# Bash attempts to save all lines of a multiple-line command in the
# same history entry.  This allows easy re-editing of multi-line
# commands.
shopt -s cmdhist

# Check the window size after each command and, if necessary,
# update the values of lines and columns.
shopt -s checkwinsize

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
  export COLORTERM
fi
unset colors_support

# dircolors.
if [ -f ~/.dircolors ] && command -v dircolors >/dev/null 2>&1; then
    eval "$(dircolors -b ~/.dircolors)"
fi

# --------------------------------------------------------------------
# Setup Bash prompt
# --------------------------------------------------------------------

__prompt_command() {
  local exit_code="$?"

  local rcol=''
  local txtred=''
  local txtpur=''
  local txtcyn=''
  local bldylw=''
  local bldblu=''
  local bldblk=''

  if [ "${COLORTERM:-}" = "truecolor" ]       \
       || [ "${COLORTERM:-}" = "24bit" ]      \
       || [ "${COLORTERM:-}" = "1" ]          \
       || [ "${USE_ANSI_COLORS:-}" = "true" ] \
       || [ "$TERM" = "xterm-256color" ]      \
       || tput setaf 1 >/dev/null 2>&1; then
    rcol='\[\e[0m\]'
    txtred='\[\e[0;31m\]'
    txtpur='\[\e[0;35m\]'
    txtcyn='\[\e[0;36m\]'
    bldylw='\[\e[1;33m\]'
    bldblu='\[\e[1;34m\]'
    bldblk='\[\e[1;30m\]'
  fi

  PS1="${bldblk}"
  PS1+='\u@\h'
  PS1+="${rcol}"

  if [ $exit_code != 0 ]; then
    PS1+=" [${txtred}${exit_code}${rcol}]"
  fi

  PS1+=" ${bldblu}"
  PS1+='\w'

  local b="$(git symbolic-ref HEAD 2>/dev/null)";
  if [ -n "$b" ]; then
    PS1+="${rcol} on ${bldylw} ${b##refs/heads/}"
  fi

  PS1+="${rcol}"
  PS1+='\n\$ '
}

PROMPT_COMMAND="__prompt_command; ${PROMPT_COMMAND}"
PS2='> '

# Local Variables:
# mode: sh
# End:
