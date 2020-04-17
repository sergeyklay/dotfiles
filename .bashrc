# ~/.bashrc
#
# User wide interactive shell configuration and executing commands.
#
# This file is sourced by the second for login shells
# (after '.profile').  Or by the first for interactive non-login
# shells.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS
shopt -s checkwinsize

# Save all strings of multiline commands in the same history entry
shopt -s cmdhist

# Bash can automatically prepend cd when entering just a path in
# the shell
shopt -s autocd

# See man -P 'less -rp HISTCONTROL' bash
HISTCONTROL="ignoreboth:erasedups"

# Every command being saved on the history list
HISTSIZE=-1

# Maximum number of history lines
HISTFILESIZE=100000

# For the protection and ability for future analyzing
HISTTIMEFORMAT="%h %d %H:%M:%S "

# Stroe all commands in the history
HISTIGNORE=

# Save commands immediately after use
PROMPT_COMMAND='history -a'

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
