# Copyright (C) 2014-2026 Serghei Iakovlev <gnu@serghei.pl>
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

_is_under_zed_remote() {
  local pid=$PPID name

  while [[ -n "$pid" && "$pid" -gt 1 ]]; do
    name=$(</proc/"$pid"/comm) 2>/dev/null || return 1
    case "$name" in
      *zed-server*|*zed-remote*|*zed_server*) return 0 ;;
    esac
    pid=$(awk '/^PPid:/{print $2}' /proc/"$pid"/status 2>/dev/null)
  done

  return 1
}

_is_embed_terminal() {
  # VSCode and derivatives
  [[ "$TERM_PROGRAM" == "vscode" ]]    && return 0
  [[ -n "$VSCODE_SHELL_INTEGRATION" ]] && return 0

  # Zed
  [[ "$TERM_PROGRAM" == "zed" ]] && return 0
  [[ -n "$ZED_TERM" ]]           && return 0
  _is_under_zed_remote           && return 0

  # Jetbrains
  [[ "$TERMINAL_EMULATOR" == "JetBrains-JediTerm" ]] && return 0

  # Claude Code
  [[ -n "$CLAUDECODE" ]] && return 0

  # GitHub Codespaces
  [[ "$CODESPACES" == "true" ]] && return 0

  # Emacs
  [[ -n "$INSIDE_EMACS" ]] && return 0
  [[ "$TERM" == "dumb" ]]  && return 0

  return 1
}

# Auto-attach to tmux for interactive SSH/WSL sessions.
# Skip for AI agents, IDE terminals, CI, and non-TTY pipes.
_should_tmux() {
  ! _is_embed_terminal        || return 1
  [[ -z "${TMUX}" ]]          || return 1
  command -v tmux &>/dev/null || return 1
  [[ -t 0 ]]                  || return 1  # no TTY
  [[ -z "${CI}" ]]            || return 1

  # Always on SSH
  [[ -n "$SSH_CONNECTION" ]] && return 0

  # On WSL, only auto-attach if running in Windows Terminal
  [[ -n "$WSL_DISTRO_NAME" && -n "$WT_SESSION" ]] && return 0

  return 1
}

if _should_tmux; then
  exec tmux new-session -A -s main
fi

unset -f _should_tmux _is_under_zed_remote

# Some app and virtual terminals unable in login shells
if [ -z "${BASH_PROFILE_SOURCED+x}" ]; then
  if [ -f "$HOME/.profile" ]; then
    # shellcheck disable=SC1091
    . "$HOME/.profile"
  fi
fi

# --------------------------------------------------------------------
# Setup asdf-golang environment (GOROOT, GOPATH, GOBIN)
# --------------------------------------------------------------------

_asdf_golang_env="${ASDF_DATA_DIR:-$HOME/.asdf}/plugins/golang/set-env.bash"
if [ -f "$_asdf_golang_env" ]; then
  # shellcheck disable=SC1090
  . "$_asdf_golang_env"
  # Guard against broken dirname chains (e.g. GOROOT=/ -> GOPATH=//packages)
  if [ -n "$GOROOT" ] && [ ! -x "$GOROOT/bin/go" ]; then
    unset GOROOT GOPATH GOBIN
  fi
fi
unset _asdf_golang_env

# --------------------------------------------------------------------
# Shell options
# --------------------------------------------------------------------

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
if [[ "$PROMPT_COMMAND" != *"history -a"* ]]; then
  PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND}"
fi

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

  : "${COLORTERM:=truecolor}"
  : "${CLICOLOR:=1}"
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
if _is_embed_terminal; then
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

__auto_venv() {
  # Auto-activate .venv in current directory; deactivate when leaving.
  # Only checks PWD - no directory walking, no subshells.
  local candidate="$PWD/.venv"

  if [ -f "$candidate/bin/activate" ]; then
    # Already active for this directory - nothing to do
    [ "$VIRTUAL_ENV" = "$candidate" ] && return
    # Deactivate previous venv if any
    [ "$(type -t deactivate)" = "function" ] && deactivate
    # shellcheck disable=SC1091
    VIRTUAL_ENV_DISABLE_PROMPT=1 source "$candidate/bin/activate"
  elif [ -n "$VIRTUAL_ENV" ]; then
    # Left a project directory - deactivate
    [ "$(type -t deactivate)" = "function" ] && deactivate
  fi
  return 0
}

__prompt_command() {
  local exit_code="$?"

  # Suppress stale exit codes on empty Enter.
  #
  # PS0 sets _cmd_ran=1 before each real command.  It does not
  # fire on empty Enter or Ctrl+C, so we can distinguish:
  #   _cmd_ran=1  -> real command, show its $?
  #   _cmd_ran=0  -> no command; show $? once, then clear
  if [ "${_cmd_ran:-0}" -eq 1 ]; then
    # Real command ran - show its exit code
    _cmd_ran=0
    _idle_code="$exit_code"
  elif [ "$exit_code" -ne 0 ] && [ "$exit_code" != "${_idle_code-}" ]; then
    # No command, but $? changed (e.g. Ctrl+C) - show once
    _idle_code="$exit_code"
  else
    # Repeated empty Enter - suppress stale code
    exit_code=0
    _idle_code="${_idle_code-}"
  fi

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

  PS1=""
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

if [[ "$PROMPT_COMMAND" != *"__prompt_command"* ]]; then
  PROMPT_COMMAND="__prompt_command; ${PROMPT_COMMAND}"
fi

# PS0 is expanded after a command is read but before it executes.
# It does not fire on empty Enter or Ctrl+C - exactly what we need
# to distinguish "no command" from "real command".  The parameter
# expansion trick sets _cmd_ran=1 as a side effect without printing
# anything.  Requires bash 4.4+.
if [[ "$PS0" != *'_cmd_ran'* ]]; then
  # shellcheck disable=SC2016
  PS0='${_cmd_ran:$((_cmd_ran=1,0)):0}'
fi
PS2='> '

# Load local overrides (not tracked in git)
if [[ -f ~/.bashrc.local ]]; then
  # shellcheck disable=SC1090
  source ~/.bashrc.local
fi

# Local Variables:
# mode: sh
# End:
