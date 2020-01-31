#!/usr/bin/env zsh

# Zsh startup file.
#
# This file is sourced on all interactive shells.
#   .zshenv -> .zprofile -> .zshrc -> .zlogin

# Used for setting user's interactive shell configuration and
# executing commands, will be read when starting as an interactive
# shell.
#

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# TODO(serghei): Deprecated
# Path to my oh-my-zsh installation
[ -d "$HOME/.oh-my-zsh" ] && export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME=bira

plugins=(
  bundler
  docker
  docker-compose
  gem
  git
  git-extras
  pass
  pip
  ssh-agent
  rake
  ruby
  vagrant
)

zstyle :omz:plugins:ssh-agent ssh_add_args "-q"
zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities \
  $(grep -slR "PRIVATE" ~/.ssh | grep -E -v "authorized_keys$|config$|known_hosts$" | xargs -L 1 basename | xargs)

[ ! -z "$(command -v cask 2>/dev/null || true)" ] && plugins+=(cask)

# Only macOS
[[  "$OSTYPE" = darwin*  ]] && {
  plugins+=(osx brew)
  [ -d /usr/local/share/zsh/site-functions ] &&
    FPATH="/usr/local/share/zsh/site-functions:$FPATH"
}

# https://gnunn1.github.io/tilix-web/manual/vteconfig
if [ $TILIX_ID ] || [ $VTE_VERSION ]
then
  if [ -f /etc/profile.d/vte-2.91.sh ]
  then
    source /etc/profile.d/vte-2.91.sh
  elif [ -f /etc/profile.d/vte.sh ]
  then
    source /etc/profile.d/vte.sh
  fi
fi

# TODO(serghei): Deprecated
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# TODO(serghei): Deprecated
# Personal aliases
[ -f "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"

[ -r $ZDOT_USER/conf.d/history ] && source $ZDOT_USER/conf.d/history

# kubectl completion
[ ! -z "$(command -v kubectl 2>/dev/null || true)" ] && {
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
# fill-column: 68
# End:
