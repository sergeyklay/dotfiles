#!/usr/bin/env zsh

# Zsh startup file.
#
# This file is sourced on all interactive shells.
#   .zshenv -> .zprofile -> .zshrc -> .zlogin
#
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

# OS specific configuration.
# This comes first as it tends to mess up things.
if [ -r $ZSHDDIR/conf.d/OS/$OSSHORT/zshrc ]
then
  source $ZSHDDIR/conf.d/OS/$OSSHORT/zshrc
fi

[ -r $ZSHDDIR/conf.d/history ] && source $ZSHDDIR/conf.d/history
[ -r $ZSHDDIR/conf.d/aliases ] && source $ZSHDDIR/conf.d/aliases
[ -r $ZSHDDIR/conf.d/prompt ] && source $ZSHDDIR/conf.d/prompt

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
