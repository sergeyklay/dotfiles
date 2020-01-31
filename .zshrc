#!/usr/bin/env zsh

# Zsh startup file.
#
# This file is sourced on all interactive shells.
#   .zshenv -> .zprofile -> .zshrc -> .zlogin

# Used for setting user's interactive shell configuration and
# executing commands, will be read when starting as an interactive
# shell.

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Initialize several associative arrays to map color names to the
# ANSI standard eight-color terminal codes.  These are used by the
# prompt theme system.  This function should be autoloaded before
# using (see .zshenv -> defuns).
colors

# Only macOS
[ $OSSHORT = darwin ] && {
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

[ -r $ZDOT_USER/conf.d/history ] && source $ZDOT_USER/conf.d/history
[ -r $ZDOT_USER/conf.d/aliases ] && source $ZDOT_USER/conf.d/aliases
[ -r $ZDOT_USER/conf.d/prompt ] && source $ZDOT_USER/conf.d/prompt

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
# End:
