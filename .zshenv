#!/usr/bin/env zsh

# Zsh startup file.
#
# This file is sourced on all invokations of zsh.
#   .zshenv -> .zprofile -> .zshrc -> .zlogin

# Used for setting user's environment variables.
# For more see 'man zsh(1)'.

# The base directories for all startup/shutdown files.
ZDOTDIR=${ZDOTDIR:-${HOME}}
ZSHDDIR="${XDG_CONFIG_HOME:-$ZDOTDIR/.config}/zsh"

[ -r $ZSHDDIR/conf.d/gopts ] && source $ZSHDDIR/conf.d/gopts
[ -r $ZSHDDIR/conf.d/defuns ] && source $ZSHDDIR/conf.d/defuns
[ -r $ZSHDDIR/conf.d/editor ] && source $ZSHDDIR/conf.d/editor

# This function tries to setup platoform independed environment
# variables.  This function WILL NOT change previously set veriables
# (if any).
if typeset -f zenv > /dev/null; then
  zenv
fi

# OS specific environment.
if [ -r $ZSHDDIR/conf.d/OS/$OSSHORT/zshenv ]; then
  source $ZSHDDIR/conf.d/OS/$OSSHORT/zshenv
fi

[ -r $ZSHDDIR/conf.d/path ] && source $ZSHDDIR/conf.d/path
[ -r $ZSHDDIR/conf.d/mans ] && source $ZSHDDIR/conf.d/mans
