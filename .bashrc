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

# Bash attempts to save all lines of a multiple-line command in the same history entry.
# This allows easy re-editing of multi-line commands.
shopt -s cmdhist

# Check the window size after each command and, if necessary,
# update the values of lines and columns.
shopt -s checkwinsize

# --------------------------------------------------------------------
# Setup colors
# --------------------------------------------------------------------

# Default to no color.
color_prompt=no

# Check explicit color preferences.
if [ "${USE_ANSI_COLORS:-}" = "true" ] || [ "${COLORTERM:-}" = "truecolor" ]; then
  color_prompt=yes
else
  if [ "${COLORTERM:-}" = "gnome-terminal" ]; then
    color_prompt=yes
  else
    # Detect support for colors based on terminal type.
    case "$TERM" in
      *-256color) color_prompt=yes;;
      xterm | xterm-color | xterm-256color) color_prompt=yes;;
    esac

    # Fallback to terminfo detection if no explicit preference is found.
    if [ "$color_prompt" = "no" ]; then
      if command -v tput >/dev/null 2>&1; then
        if tput setaf 1 >/dev/null 2>&1; then
          color_prompt=yes
        fi
      fi
    fi
  fi
fi

if [ "function" != "$(type -t __git_ps1)" ]; then
  __git_ps1 () {
    local b="$(git symbolic-ref HEAD 2>/dev/null)";
    if [ -n "$b" ]; then
      printf "$1" "${b##refs/heads/}";
    fi
  }
fi

# Bash prompt.
if [ "$color_prompt" = yes ]; then
  PS1='\n\[\e[36m\]\w$(__git_ps1 "\[\033[00m\] on \[\e[35m\] %s")\[\033[00m\]\n$ '
else
  PS1='\n\[\e[36m\]\w$(__git_ps1 "\[\033[00m\] on \[\e[35m\] %s")\[\033[00m\]\n$ '
fi
unset color_prompt

# dircolors.
if [ -x "$(command -v dircolors)" ]; then
    eval "$(dircolors -b ~/.dircolors)"
fi

# Local Variables:
# mode: sh
# End:
