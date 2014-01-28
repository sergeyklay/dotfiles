# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Save all strings of multiline commands in the same history entry
shopt -s cmdhist

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

# actual ruby gems home
GEM_HOME=$(ruby -e 'puts Gem.user_dir')

# user-specific configuration files
XDG_CONFIG_HOME=~/.config

# user-specific data files
XDG_DATA_HOME=~/.local/share

# base directories relative to which data files should be searched
XDG_DATA_DIRS=/usr/share

# configuration files should be searched relative to this directory
XDG_CONFIG_DIRS=/etc/xdg

# user-specific cached data should be written relative to this directory
XDG_CACHE_HOME=~/.cache

# user-specific runtime files should be placed relative to this directory
$XDG_RUNTIME_DIR=$(id -u)

# some defaults
EDITOR=vim
CHROME_BIN=/usr/bin/chromium

# more for less
PAGER=less
LESS=-R # use -X to avoid sending terminal initialization
LESSCHARSET=UTF-8
LESS_TERMCAP_mb=$'\033[01;31m'
LESS_TERMCAP_md=$'\033[01;38;5;74m'
LESS_TERMCAP_me=$'\033[0m'
LESS_TERMCAP_se=$'\033[0m'
LESS_TERMCAP_so=$'\033[38;5;246m'
LESS_TERMCAP_ue=$'\033[0m'
LESS_TERMCAP_us=$'\033[04;38;5;146m'

# font config
GDK_USE_XFT=1
QT_XFT=true

# setup prompt
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "`dircolors -b`"
    # Design prompt
    PS1="\[\033[1;35m\]%\[\033[00m\] \[\033[1;34m\]\w\[\033[00m\] "
else
    # Default promt
    PS1='% \w '
fi

# include aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# git completion
if [ -f ~/git-completion.sh ]; then
    . ~/git-completion.sh
fi

# actual ruby gems binaries path
if [ -d $GEM_HOME/bin ]; then
    PATH+=:$GEM_HOME/bin
fi

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ]; then
    PATH+=:~/bin
fi