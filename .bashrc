#!/bin/bash

#
# Bash configuration
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Save all strings of multiline commands in the same history entry
shopt -s cmdhist

# Bash can automatically prepend cd when entering just a path in the shell
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

# User-specific configuration files
export XDG_CONFIG_HOME=$HOME/.config

# User-specific data files
export XDG_DATA_HOME=$HOME/.local/share

# Base directories relative to which data files should be searched
export XDG_DATA_DIRS=/usr/share

# Configuration files should be searched relative to this directory
export XDG_CONFIG_DIRS=/etc/xdg

# User-specific cached data should be written relative to this directory
export XDG_CACHE_HOME=$HOME/.cache

# User-specific runtime files should be placed relative to this directory
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# See: https://stackoverflow.com/a/27965014/1661465
export XDG_STATE_HOME=$HOME/.local/state

# See: https://github.com/sergeyklay/vimfiles
export EDITOR="vim"
export VIEWER="vim -R"

# More for less
export PAGER=less

# See: https://unix.stackexchange.com/q/38634/50400
export LESS=-X

export LESSCHARSET=UTF-8
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

# font config
export GDK_USE_XFT=1
export QT_XFT=true

# Main prompt
PS1='$ \w '
# Continuation prompt
PS2="| "

if [ $(which dircolors) ]; then
  if [ -r $HOME/.dircolors ]; then
    eval "$(dircolors -b $HOME/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi

  # This will used in ~/.bash_aliases
  colors_support=true
fi

# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$colors_support" = true ]; then
  # colorize prompt
  PS1="\[\033[1;32m\]$\[\033[00m\] \w "
  PS2="\[\033[1;37m\]|\[\033[00m\] "

  # Color man pages
  export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
  export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
  export LESS_TERMCAP_me=$'\E[0m'           # end mode
  export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
  export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
  export LESS_TERMCAP_ue=$'\E[0m'           # end underline
  export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

  export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

  [[ -z "$COLORTERM" ]] || COLORTERM=1
fi

# Include aliases
if [ -f $HOME/.bash_aliases ]; then
  source $HOME/.bash_aliases
fi

unset colors_support

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# Enable bash completion for git
if [ -f $HOME/git/completion.sh ]; then
  source $HOME/git/completion.sh
fi

# Enable bash completion for docker-compose
if [ -f /etc/bash_completion.d/docker-compose ]; then
  source /etc/bash_completion.d/docker-compose
fi

# Enable bash completion for zephir
if [ -f /etc/bash_completion.d/zephir-autocomplete ]; then
  source /etc/bash_completion.d/zephir-autocomplete
fi

# Enable bash completion for composer
# See: https://github.com/bramus/composer-autocomplete
if [ -f /etc/bash_completion.d/composer ]; then
  source /etc/bash_completion.d/composer
fi

# Enable bash completion for pass
if [ -f /usr/share/bash-completion/completions/pass ]; then
  source /usr/share/bash-completion/completions/pass
fi

export SSH_AGENT_CONFIG="$HOME/.ssh_agent_session"
if [[ -e "$SSH_AGENT_CONFIG" ]]; then
  source "$SSH_AGENT_CONFIG" > /dev/null
fi

# Start `ssh-agent'
# `ssh-add' returns 2 if it can not connect to the authentication agent.
if [[ -z "$SSH_AUTH_SOCK" ]] || \
  { ssh-add -l > /dev/null 2>&1; test $? -eq 2; }; then
  SSH_AGENT_DATA="$(ssh-agent -s)"
  UMASK_SAVE="$(umask -p)"
  umask 077
  echo "$SSH_AGENT_DATA" >| "$SSH_AGENT_CONFIG"
  $UMASK_SAVE
  eval $SSH_AGENT_DATA > /dev/null

  unset SSH_AGENT_DATA UMASK_SAVE
fi

[[ -n "$INSIDE_EMACS" && -n "$SSH_AUTH_SOCK" && -n "$SSH_AGENT_PID" ]] && \
  type -t esetenv > /dev/null 2>&1 && \
  esetenv SSH_AUTH_SOCK SSH_AGENT_PID

echo Agent pid $SSH_AGENT_PID

# Auto add ssh key to `ssh-agent'
# Note: to add ECDSA keys see https://stackoverflow.com/a/45370592/1661465
grep -slR "PRIVATE" ~/.ssh/ | xargs ssh-add >/dev/null 2>&1

# Update GPG_TTY
export GPG_TTY=$(/usr/bin/tty)

# Added by travis gem
[ -f ${HOME}/.travis/travis.sh ] && source ${HOME}/.travis/travis.sh

# Path to the bash it configuration
export BASH_IT="/home/klay/.bash_it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
export BASH_IT_THEME='powerline-plain'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='weechat'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking
# within the prompt for all themes
export SCM_CHECK=true

# Load Bash It
source "$BASH_IT"/bash_it.sh

# vim:ft=sh:ts=2:sw=2:sts=2:tw=78:fenc=utf-8:et
