# ~/.bashrc
#
# User wide interactive shell configuration and executing commands.
#
# This file is sourced by the second for login shells
# (after '~/.bash_profile').  Or by the first for interactive
# non-login shells.

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

# Set $DIRSTACK size limit to 20
# shellcheck disable=SC2034
DIRSTACKSIZE=20

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

# Use a lesspipe filter, if we can find it.
# This sets the $LESSOPEN variable.
if command -v lesspipe.sh >/dev/null 2>&1 ; then
  export LESSOPEN="| lesspipe.sh %s";
elif command -v lesspipe >/dev/null 2>&1 ; then
  eval "$(lesspipe)"
fi

# Main prompt
PS1='$ \w '
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
if [ "$color_support" = true ]; then
  # colorize prompt
  PS1="\[\033[1;32m\]$\[\033[00m\] \w "
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

# Include aliases
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

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

# Enable bash completion for git
if [ -f /usr/share/bash-completion/completions/git ]; then
  . /usr/share/bash-completion/completions/git
fi

# Enable bash completion for docker-compose
if [ -f /etc/bash_completion.d/docker-compose ]; then
  . /etc/bash_completion.d/docker-compose
fi

# Enable bash completion for zephir
if [ -f /etc/bash_completion.d/zephir-autocomplete ]; then
  . /etc/bash_completion.d/zephir-autocomplete
fi

# Enable bash completion for composer
# See: https://github.com/bramus/composer-autocomplete
if [ -f /etc/bash_completion.d/composer ]; then
  . /etc/bash_completion.d/composer
fi

# Enable bash completion for pass
if [ -f /usr/share/bash-completion/completions/pass ]; then
  . /usr/share/bash-completion/completions/pass
fi

# Enable bash completion for kubectl
# See: https://kubernetes.io/docs/tasks/tools/install-kubectl
test -n "$(command -v kubectl 2>/dev/null)" && \
  source <(kubectl completion bash | sed s/kubectl/k/g)
test -n "$(command -v minikube 2>/dev/null)" && \
  source <(minikube completion bash)

# The next line enables shell command completion for gcloud.
[ -f ~/gcp/completion.bash.inc ] && . ~/gcp/completion.bash.inc

# Local Variables:
# mode: sh
# End:
