# Path to my oh-my-zsh installation
[ -d "$HOME/.oh-my-zsh" ] && export ZSH="$HOME/.oh-my-zsh"

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

# if history needs to be trimmed, expire dups first
setopt HIST_EXPIRE_DUPS_FIRST

# don't add dups to history
setopt HIST_IGNORE_DUPS

# don't add commands starting with space to history
setopt HIST_IGNORE_SPACE

# remove junk whitespace from commands before adding to history
setopt HIST_REDUCE_BLANKS

# if a cmd triggers history expansion, show it instead of running
setopt HIST_VERIFY

# write and import history on every command
setopt SHARE_HISTORY

# write timestamps to history
setopt EXTENDED_HISTORY

# User-specific configuration files
export XDG_CONFIG_HOME=$HOME/.config

# User-specific data files
export XDG_DATA_HOME=$HOME/.local/share

# Base directories relative to which data files should be searched
export XDG_DATA_DIRS=/usr/share

# Configuration files should be searched relative to this directory
[ -d /etc/xdg ] && export XDG_CONFIG_DIRS=/etc/xdg

# User-specific cached data should be written relative to this directory
export XDG_CACHE_HOME=$HOME/.cache

# User-specific runtime files should be placed relative to this directory
[ -d /run/user ] && export XDG_RUNTIME_DIR=/run/user/$(id -u)

# See: https://stackoverflow.com/a/27965014/1661465
export XDG_STATE_HOME=$HOME/.local/state

# See: https://github.com/sergeyklay/vimfiles
export EDITOR="vim"
export VIEWER="vim -R"

# More for less
export PAGER=less

if [ -f /usr/local/bin/lesspipe.sh ]
then
  LESSPIPE="$(which lesspipe.sh)"
  LESSOPEN="| ${LESSPIPE} %s"; export LESSOPEN
elif [ -x /usr/bin/lesspipe ]
then
  eval "$(lesspipe)"
fi

# -X will leave the text in your Terminal, so it doesn't disappear
#    when you exit less
# -F will exit less if the output fits on one screen (so you don't
#    have to press "q").
#
# See: https://unix.stackexchange.com/q/38634/50400
export LESS="-X -F"
export LESSCHARSET=UTF-8

# Set name of the theme to load
ZSH_THEME="robbyrussell"

plugins=(
  bundler
  cabal
  composer
  docker
  docker-compose
  gem
  git
  git-extras
  pass
  rake
  ruby
  vagrant
)


[ "$(command -v cask 2>/dev/null || true)" != "" ] && plugins+=(cask)

# Only macOS
[ "$(uname)" = "Darwin" ] && plugins+=(osx)

[ ! -z $BREW_PATH ] && plugins+=(brew)
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# Personal aliases
[ -f "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"

[ ! -z $BREW_PATH ] && {
  _bsf="$(brew --prefix)/share/zsh/site-functions"
  [ ! -z $_bsf ] && [ -d "$_bsf" ] && {
    FPATH="$_bsf:$FPATH"
  }
  unset _bsf
}

# kubectl completion
[ ! -z "$KUBECTL_PATH" ] && source <(kubectl completion zsh | sed s/kubectl/k/g)

[ -d /usr/local/man ] && export MANPATH="/usr/local/man:$MANPATH"
[ -d /usr/share/man ] && export MANPATH="/usr/share/man:$MANPATH"

# The next line updates PATH for the Google Cloud SDK.
[ -f "$HOME/gcp/path.zsh.inc" ] && source "$HOME/gcp/path.zsh.inc"

# The next line enables shell command completion for gcloud.
[ -f "$HOME/gcp/completion.zsh.inc" ] && source "$HOME/gcp/completion.zsh.inc"

# vim:ft=sh:ts=2:sw=2:sts=2:tw=78:fenc=utf-8:et
