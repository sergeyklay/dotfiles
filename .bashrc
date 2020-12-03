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

# User wide interactive shell configuration and executing commands.
#
# This file is sourced by the second for login shells
# (after '~/.bash_profile').  Or by the first for interactive
# non-login shells.

# shellcheck shell=bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
elif [ -f /etc/bash.bashrc ]; then
  # shellcheck disable=SC1091
  . /etc/bash.bashrc
fi

# Auto-fix minor typos in interactive use of 'cd'
shopt -q -s cdspell

# Bash can automatically prepend cd when entering just a path in
# the shell
shopt -q -s autocd

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS
shopt -q -s checkwinsize

# Immediate notification of background job termination
set -o notify

# Don't let Ctrl-D exit the shell
set -o ignoreeof

# Append to the history file, don't overwrite it
shopt -s histappend

# Save all strings of multiline commands in the same history entry
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
#  [ \t]        lines starting with spaces
#  history *    history command
#  cd -*/cd +*  navigation on directory stack
HISTIGNORE='&:[ \t]*:history *:cd -*[0-9]*:cd +*[0-9]*'

# Save commands immediately after use to have shared history
# between Bash sessions.
#  'history -a'  append the current history to the history file
#  'history -n'  rereading anything new in history file into the
#                current shell’s history
PROMPT_COMMAND='history -a ; history -n'

# More for less
export PAGER=less

# -X will leave the text in your Terminal, so it doesn't disappear
#    when you exit less.
# -F will exit less if the output fits on one screen (so you don't
#    have to press "q").
# -R ANSI "color" escape sequences are output in "raw" form.
#
# See: https://unix.stackexchange.com/q/38634/50400
export LESS="-X -F -R"
export LESSCHARSET=UTF-8

export LESSHISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/lesshst"

# Use a lesspipe filter, if we can find it.
# This sets the $LESSOPEN variable.
if command -v lesspipe.sh >/dev/null 2>&1 ; then
  export LESSOPEN="| lesspipe.sh %s";
elif command -v lesspipe >/dev/null 2>&1 ; then
  eval "$(lesspipe)"
fi

# Main prompt
PS1='<\t> \u@\h \w [$(echo $?)]
\$ '
# Continuation prompt
PS2="> "

# All the colorizing may or may not work depending on your terminal
# emulation and settings, especially. ANSI color.   But it shouldn't
# hurt to have.
if command -v dircolors >/dev/null 2>&1 ; then
  if [ -r ~/.dircolors ]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi

  # This will used for aliases and prompt.
  colors_support=true
fi

# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color)
    colors_support=true
    ;;
esac

# Colorize output
if [ "$colors_support" = true ]; then
  # colorize prompt
  PS1='\[\e[0;33m\]<\t>\e[0m\] \e[0;32m\]\u@\h\e[0m\] \e[0;36m\]\w\e[0m\] [$(echo $?)]\]
\$ '
  PS2="\[\033[1;37m\]>\[\033[00m\] "

  # colorize gcc output
  GCC_COLORS='error=01;31:'
  GCC_COLORS+='warning=01;35:'
  GCC_COLORS+='note=01;36:'
  GCC_COLORS+='caret=01;32:'
  GCC_COLORS+='locus=01:'
  GCC_COLORS+='quote=01'
  export GCC_COLORS

  [[ -z "$COLORTERM" ]] || COLORTERM=1
fi

# The Directory Stack Functions \ Aliases
# shellcheck source=./bash.d/dirstack.sh
. ~/bash.d/dirstack.sh

# Include aliases
if [ -f ~/.bash_aliases ]; then
  # shellcheck source=./.bash_aliases
  . ~/.bash_aliases
fi

unset colors_support

# phpenv
if command -v phpenv >/dev/null 2>&1 ; then
  eval "$(phpenv init -)"
fi

# rbenv
if [ -z "$RBENV_SHELL" ]; then
  if command -v rbenv >/dev/null 2>&1; then
    eval "$(rbenv init -)"
  fi
fi

# sdkman
if [ -n "${SDKMAN_DIR+x}" ]; then
    if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
      # shellcheck disable=SC1090
      . "$SDKMAN_DIR/bin/sdkman-init.sh"
    fi
fi

# Enable bash completion with sudo
complete -cf sudo

# Use bash-completion, if available.
# For more see: https://github.com/scop/bash-completion
#
# Linux
if [[ $PS1 && -f /usr/share/bash-completion/bash_completion ]]; then
  # shellcheck disable=SC1091
  . /usr/share/bash-completion/bash_completion
fi

# macOs
if [[ $PS1 && -r /usr/local/etc/profile.d/bash_completion.sh ]]; then
  # shellcheck disable=SC1091
  . /usr/local/etc/profile.d/bash_completion.sh
fi

# Local Variables:
# mode: sh
# flycheck-shellcheck-excluded-warnings: ("SC1090")
# flycheck-disabled-checkers: (sh-posix-dash sh-shellcheck)
# End:
