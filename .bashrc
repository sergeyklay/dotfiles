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
export CHROME_BIN=/usr/bin/chromium

# more for less
export PAGER=less
export LESS=-R # use -X to avoid sending terminal initialization
export LESSCHARSET=UTF-8

# font config
export GDK_USE_XFT=1
export QT_XFT=true

# setup prompt
PS1='% \w '

if [ -x /usr/bin/dircolors ]
then
  [ -r ~/.dircolors ] && eval "$(dircolors -b ~/.dircolors)" || eval \
    "$(dircolors -b)"

  colors_support=true

  # color man pages
  export LESS_TERMCAP_mb=$(printf "\e[01;31m")
  export LESS_TERMCAP_md=$(printf "\e[01;35m")
  export LESS_TERMCAP_me=$(printf "\e[0m")
  export LESS_TERMCAP_se=$(printf "\e[0m")
  export LESS_TERMCAP_so=$(printf "\e[01;33m")
  export LESS_TERMCAP_ue=$(printf "\e[0m")
  export LESS_TERMCAP_us=$(printf "\e[04;36m")

fi

# config for mc skins. 256 colors support
if [ "$color_support" = true ]
then
  export TERM=xterm-256color mc
fi

# include aliases
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# git completion
if [ -f ~/git/completion.sh ]; then
  . ~/git/completion.sh
fi

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ]; then
  PATH+=:~/bin
fi

# Ruby environment with Rbenv
if [ -d ~/.rbenv/bin ]
  PATH+=:~/.rbenv/bin
  eval "$(rbenv init -)"
fi

# vim:ft=sh:ts=8:sw=2:sts=2:tw=80:et
