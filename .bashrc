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

# every command being saved on the history list
HISTSIZE=-1

# maximum number of history lines
HISTFILESIZE=100000

# for the protection and ability for future analyzing
HISTTIMEFORMAT="%h %d %H:%M:%S "

# stroe all commands in the history
HISTIGNORE=

# save commands immediately after use
PROMPT_COMMAND='history -a'

# user-specific configuration files
export XDG_CONFIG_HOME=$HOME/.config

# user-specific data files
export XDG_DATA_HOME=$HOME/.local/share

# base directories relative to which data files should be searched
export XDG_DATA_DIRS=/usr/share

# configuration files should be searched relative to this directory
export XDG_CONFIG_DIRS=/etc/xdg

# user-specific cached data should be written relative to this directory
export XDG_CACHE_HOME=$HOME/.cache

# user-specific runtime files should be placed relative to this directory
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# See: https://stackoverflow.com/a/27965014/1661465
export XDG_STATE_HOME=$HOME/.local/state

# See: https://github.com/sergeyklay/vimfiles
export EDITOR="vim"

# more for less
export PAGER=less
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

  # used in ~/.bash_aliases
  colors_support=true
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$colors_support" = true ]; then
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

  export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

  [[ -z "$COLORTERM" ]] || COLORTERM=1
fi

# include aliases
if [ -f $HOME/.bash_aliases ]; then
  source $HOME/.bash_aliases
fi

unset colors_support

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# git completion
if [ -f $HOME/git/completion.sh ]; then
  source $HOME/git/completion.sh
fi

if [ -f /etc/bash_completion.d/docker-compose ]; then
  source /etc/bash_completion.d/docker-compose
fi

# Zephir completion
if [ -f /etc/bash_completion.d/zephir-autocomplete ]; then
  source /etc/bash_completion.d/zephir-autocomplete
fi

# Composer completion
# See: https://github.com/bramus/composer-autocomplete
if [ -f /etc/bash_completion.d/composer ]; then
  source /etc/bash_completion.d/composer
fi

# pass
if [ -f /usr/share/bash-completion/completions/pass ]; then
  source /usr/share/bash-completion/completions/pass
fi

export SSH_AGENT_CONFIG="$HOME/.ssh_agent_session"
if [[ -e "$SSH_AGENT_CONFIG" ]]; then
  source "$SSH_AGENT_CONFIG" > /dev/null
fi

# start `ssh-agent'
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

# auto add ssh key to `ssh-agent'
# Note: to add ECDSA keys see https://stackoverflow.com/a/45370592/1661465
grep -slR "PRIVATE" ~/.ssh/ | xargs ssh-add >/dev/null 2>&1

# Update GPG_TTY
export GPG_TTY=$(/usr/bin/tty)

# added by travis gem
[ -f ${HOME}/.travis/travis.sh ] && source ${HOME}/.travis/travis.sh

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Path to the bash it configuration
export BASH_IT="/home/klay/.bash_it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
export BASH_IT_THEME='bobby'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Uncomment this to make Bash-it create alias reload.
# export BASH_IT_RELOAD_LEGACY=1

# Load Bash It
source "$BASH_IT"/bash_it.sh
