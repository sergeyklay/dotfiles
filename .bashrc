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

# Auto-attach to tmux
if [[ -z "$TMUX" ]] && command -v tmux &>/dev/null; then
  if [[ -n "$SSH_CONNECTION" ]] || [[ -n "$WSL_DISTRO_NAME" ]]; then
    exec tmux new-session -A -s main
  fi
fi

# Some app and virtual terminals unable in login shells
if [ -z "${BASH_PROFILE_SOURCED+x}" ]; then
  if [ -f "$HOME/.profile" ]; then
    # shellcheck disable=SC1091
    . "$HOME/.profile"
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
  # shellcheck disable=SC1090
  . ~/.config/dirstack.sh
fi

# --------------------------------------------------------------------
# Utils
# --------------------------------------------------------------------

if [ -f ~/.config/proctools.sh ]; then
  # shellcheck disable=SC1090
  . ~/.config/proctools.sh
fi

# --------------------------------------------------------------------
# Setup Editor
# --------------------------------------------------------------------

# Editor to fallback to if the server is not running.  If this
# variable is empty, then start GNU Emacs in daemon mode and try
# connecting again.
ALTERNATE_EDITOR=''
export ALTERNATE_EDITOR

EDITOR='emacsclient -c -nw'
export EDITOR

VISUAL="$EDITOR"
export VISUAL

# More for less
if [[ $TERM == "dumb" ]] ; then
  PAGER="cat"
else
  PAGER="less"
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

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    # shellcheck disable=SC1091
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    # shellcheck disable=SC1091
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

if [ "$color_prompt" = "yes" ]; then
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

# Enable color support of ls
_dircolors=dircolors
[ "$(uname)" = "Darwin" ] && _dircolors=gdircolors

if command -v "$_dircolors" >/dev/null 2>&1; then
  if [ -f ~/.dircolors ]; then
    eval "$("$_dircolors" -b ~/.dircolors)"
  else
    eval "$("$_dircolors" -b)"
  fi
fi
unset _dircolors

# --------------------------------------------------------------------
# Setup aliases
# --------------------------------------------------------------------

if [ -f ~/.bash_aliases ]; then
  # shellcheck disable=SC1090
  . ~/.bash_aliases
fi


# --------------------------------------------------------------------
# Setup GPG for interactive shells
# --------------------------------------------------------------------

# Update GPG_TTY.  See 'man 1 gpg-agent'.
# Only set GPG_TTY in real terminals, not in VSCode/Cursor pseudo-terminals
if [ -n "${VSCODE_SHELL_INTEGRATION:-}" ]; then
  # Running in Cursor/VSCode - don't set GPG_TTY
  unset GPG_TTY
else
  # Real terminal - try to set GPG_TTY
  _possible_tty="$(tty 2>/dev/null)"
  if [ -n "$_possible_tty" ] && [ "$_possible_tty" != "not a tty" ]; then
    GPG_TTY="$_possible_tty"
    export GPG_TTY
  else
    unset GPG_TTY
  fi
  unset _possible_tty
fi

# --------------------------------------------------------------------
# Setup Bash prompt
# --------------------------------------------------------------------

show_virtual_env() {
  # Active virtualenv — show project name
  if [ -n "$VIRTUAL_ENV" ]; then
    local venv_name="${VIRTUAL_ENV##*/}"
    case "$venv_name" in
      .venv|venv|env)
        local parent="${VIRTUAL_ENV%/*}"
        printf '(%s) ' "${parent##*/}"
        ;;
      *)
        printf '(%s) ' "$venv_name"
        ;;
    esac
    return
  fi

  # No active venv — show asdf-managed local Python version
  # Only if asdf is configured and the version is actually installed
  [ -z "$ASDF_DATA_DIR" ] && return

  local py_ver=""
  if [ -f .python-version ]; then
    read -r py_ver < .python-version
  elif [ -f .tool-versions ]; then
    py_ver="$(sed -n 's/^python *//p' .tool-versions)"
  fi

  if [ -n "$py_ver" ] && [ -d "$ASDF_DATA_DIR/installs/python/$py_ver" ]; then
    printf '(py:%s) ' "$py_ver"
  fi
}

export -f show_virtual_env

__auto_venv() {
  # Auto-activate .venv in current directory; deactivate when leaving.
  # Only checks PWD — no directory walking, no subshells.
  local candidate="$PWD/.venv"

  if [ -f "$candidate/bin/activate" ]; then
    # Already active for this directory — nothing to do
    [ "$VIRTUAL_ENV" = "$candidate" ] && return
    # Deactivate previous venv if any
    [ "$(type -t deactivate)" = "function" ] && deactivate
    # Suppress the default PS1 prefix — show_virtual_env handles it
    # shellcheck disable=SC1091
    VIRTUAL_ENV_DISABLE_PROMPT=1 source "$candidate/bin/activate"
  elif [ -n "$VIRTUAL_ENV" ]; then
    # Left a project directory — deactivate
    [ "$(type -t deactivate)" = "function" ] && deactivate
  fi
}

__prompt_command() {
  local exit_code="$?"

  # Track history number to detect empty Enter (no command run)
  local hist_num
  hist_num="$(history 1 | awk '{print $1}')"
  if [ "$hist_num" = "$_last_hist_num" ]; then
    exit_code=0
  fi
  _last_hist_num="$hist_num"

  __auto_venv

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

  if [ "$exit_code" != 0 ]; then
    PS1+=" [${bldred}${exit_code}${rcol}]"
  fi

  PS1+=" ${bldblu}"
  PS1+='\w'

  local b
  b="$(git symbolic-ref HEAD 2>/dev/null)"
  if [ -n "$b" ]; then
    PS1+="${rcol} ${bldylw}${b##refs/heads/}"

    local git_indicators=""

    # Unstaged changes (modified/deleted but not added)
    if ! git diff --quiet 2>/dev/null; then
      git_indicators+="*"
    fi

    # Staged changes (added but not committed)
    if ! git diff --cached --quiet 2>/dev/null; then
      git_indicators+="+"
    fi

    # Commits ahead of remote (committed but not pushed)
    local ahead
    ahead="$(git rev-list --count '@{upstream}..HEAD' 2>/dev/null)"
    if [ -n "$ahead" ] && [ "$ahead" -gt 0 ]; then
      git_indicators+="^${ahead}"
    fi

    # Stashed changes
    local stash_count
    stash_count="$(git stash list 2>/dev/null | wc -l)"
    if [ "$stash_count" -gt 0 ]; then
      git_indicators+="{${stash_count}}"
    fi

    if [ -n "$git_indicators" ]; then
      PS1+=" ${rcol}${bldblk}${git_indicators}"
    fi
  fi

  PS1+="${rcol}"
  PS1+="\n${bldblk}\\A${rcol} \\$ "
}

PROMPT_COMMAND="__prompt_command; ${PROMPT_COMMAND}"
PS2='> '

# Load local overrides (not tracked in git)
# shellcheck disable=SC1090
[[ -f ~/.bashrc.local ]] && source ~/.bashrc.local

# Local Variables:
# mode: sh
# End:
