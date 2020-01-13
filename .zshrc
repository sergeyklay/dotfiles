#!/usr/bin/env zsh

#
# Zsh startup file.
#
# Used for setting user's interactive shell configuration and
# executing commands, will be read when starting as an interactive
# shell.
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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

HISTFILE="$ZSH_CACHE_DIR/history"

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

# Set name of the theme to load
ZSH_THEME=bira

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
  pip
  ssh-agent
  rake
  rbenv
  ruby
  vagrant
)

zstyle :omz:plugins:ssh-agent ssh_add_args "-q"
zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities \
  $(grep -slR "PRIVATE" ~/.ssh | grep -E -v "authorized_keys$|config$|known_hosts$" | xargs -L 1 basename | xargs)

[ ! -z "$(command -v cask 2>/dev/null || true)" ] && plugins+=(cask)

# Only macOS
[[  "$OSTYPE" = darwin*  ]] && plugins+=(osx)

[ ! -z "$BREW_BIN" ] && plugins+=(brew)
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# Personal aliases
[ -f "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"

[ ! -z "$BREW_BIN" ] && {
  _bsf="$(brew --prefix)/share/zsh/site-functions"
  [ ! -z $_bsf ] && [ -d "$_bsf" ] && {
    FPATH="$_bsf:$FPATH"
  }
  unset _bsf
}

# kubectl completion
[ ! -z "$KUBECTL_BIN" ] && {
    source <(kubectl completion zsh | sed s/kubectl/k/g)
}

# The next line updates PATH for the Google Cloud SDK.
[ -f "$HOME/gcp/path.zsh.inc" ] && source "$HOME/gcp/path.zsh.inc"

# The next line enables shell command completion for gcloud.
[ -f "$HOME/gcp/completion.zsh.inc" ] && {
    source "$HOME/gcp/completion.zsh.inc"
}

# Local Variables:
# mode: sh
# End:
