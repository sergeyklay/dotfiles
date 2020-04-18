# ~/.bashrc
#
# User wide interactive shell configuration and executing commands.
#
# This file is sourced by the second for login shells
# (after '.profile').  Or by the first for interactive non-login
# shells.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
elif [ -f /etc/bash.bashrc ]; then
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

# Omit dups & lines starting with spaces
HISTIGNORE='&:[ ]*'

# Save commands immediately after use to have shared history
# between Bash sessions.
#  'history -a'  append the current history to the history file
#  'history -n'  rereading anything new in history file into the
#                current shell’s history
PROMPT_COMMAND='history -a ; history -n'

# More for less
export PAGER=less

# -X will leave the text in your Terminal, so it doesn't disappear
#    when you exit less
# -F will exit less if the output fits on one screen (so you don't
#    have to press "q").
#
# See: https://unix.stackexchange.com/q/38634/50400
export LESS="-X -F"
export LESSCHARSET=UTF-8

export LESSHISTFILE="${XDG_CACHE_HOME:-~/.cache}/lesshst"

if command -v lesspipe >/dev/null 2>&1 ; then
  eval "$(lesspipe)"
elif command -v lesspipe.sh >/dev/null 2>&1 ; then
  export LESSOPEN="| lesspipe.sh %s";
fi

# Local Variables:
# mode: sh
# End:
