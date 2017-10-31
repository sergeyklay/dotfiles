#!/bin/bash

#
# Bash configuration
#

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Save all strings of multiline commands in the same history entry
shopt -s cmdhist

# Bash can automatically prepend cd when entering just a path in the shell
shopt -s autocd

# man -P 'less -rp HISTCONTROL' bash
HISTCONTROL="ignoreboth:erasedups"

# amount of commands that need to remember in the history list
HISTSIZE=10000

# maximum file size
HISTFILESIZE=20000

# for the protection and ability for future analyzing
HISTTIMEFORMAT="%h %d %H:%M:%S "

# don't log some frequent commands
# and commands starting with whitespace
HISTIGNORE="[ \t]*:ls:bg:fg:jobs:pwd"

# save commands immediately after use
PROMPT_COMMAND='history -a'

# user-specific configuration files
export XDG_CONFIG_HOME=~/.config

# user-specific data files
export XDG_DATA_HOME=~/.local/share

# base directories relative to which data files should be searched
export XDG_DATA_DIRS=/usr/share

# configuration files should be searched relative to this directory
export XDG_CONFIG_DIRS=/etc/xdg

# user-specific cached data should be written relative to this directory
export XDG_CACHE_HOME=~/.cache

# user-specific runtime files should be placed relative to this directory
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# some defaults
export EDITOR=vim

# more for less
export PAGER=less
export LESS=-X
export LESSCHARSET=UTF-8
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

# font config
export GDK_USE_XFT=1
export QT_XFT=true

# Default ruby binaries path, can be overridden interactive
export RUBY_BIN=$(which ruby | sed 's/ruby$//')

# Main prompt
PS1='$ \w '
# Continuation prompt
PS2="| "

if [ $(which dircolors) ]; then
  if [ -r ~/.dircolors ]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
 
  colors_support=true
fi
  
if [ "$colors_support" = true ]; then
  # config for mc skins. 256 colors support
  export TERM=xterm-256color

  # colorize prompt
  PS1="\[\033[1;32m\]$\[\033[00m\] \w "
  PS2="\[\033[1;37m\]|\[\033[00m\] "

  # color man pages
  export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
  export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
  export LESS_TERMCAP_me=$'\E[0m'           # end mode
  export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
  export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
  export LESS_TERMCAP_ue=$'\E[0m'           # end underline
  export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

  COLORTERM=1
fi

# include aliases
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# git completion
if [ -f ~/git/completion.sh ]; then
  . ~/git/completion.sh
fi

# auto add ssh key to ssh-agent
if [ ! -S ~/ssh_auth_sock ]; then
  eval `ssh-agent`

  ln -sf "$SSH_AUTH_SOCK" ~/ssh_auth_sock
fi

export SSH_AUTH_SOCK=$(readlink ~/ssh_auth_sock)
ssh-add -l | grep "The agent has no identities" && ssh-add

# this is necessary since enigmail in thunderbird requires gpg2, it no longer# works with the default gnome keyring.
# this is taken from the gpg-agent man page:
# /usr/bin/gpg-agent --daemon --write-env-file "${HOME}/.gpg-agent-info"
# which helps, but it spawns a new agent for each terminal.
# adjusting for the advice here (even though it's for OSX):
## https://www.semipol.de/2015/05/03/letting-enigmail-use-gpg-agent-for-passphrase-caching-on-osx.html
# that is, make sure it's not running already (test the right file exists and
# that the pid it lists is running (kill -0 just checks if a pid is alive)
if test -f "$HOME/.gpg-agent-info" && \
     kill -0 "$(cut -d: -f 2 "$HOME/.gpg-agent-info")" 2>/dev/null
then
    echo "already running" > /dev/null
else
    /usr/bin/gpg-agent --daemon --write-env-file "${HOME}/.gpg-agent-info" > /dev/null
fi

# then do the rest of the stuff from the gpg-agent man page
# This should be run "for each interactive session"
if [ -f "${HOME}/.gpg-agent-info" ]
then
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
fi

GPG_TTY=$(tty)
export GPG_TTY

# vim:ft=sh:ts=8:sw=2:sts=2:tw=80:et
