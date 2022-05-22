#!/usr/bin/env zsh

# Zsh startup file.
#
# This file is sourced on all invokations of zsh.
#   [.zshenv] -> .zprofile -> .zshrc -> .zlogin
#
# This file is sourced on all invocations of the shell, unless the `-f`
# option is set.
#
# What goes in it:
#
# - Set up the command search path
# - Other important environment variables
# - Commands to set up aliases and functions that are needed for other
#   scripts
#
# What does NOT go in it:
#
# - Commands that produce output
# - Anything that assumes the shell is attached to a tty
#
# For more see 'man zsh(1)'.

# The base directories for all startup/shutdown files.
ZDOTDIR=${ZDOTDIR:-${HOME}}
ZSHDDIR="${XDG_CONFIG_HOME:-$ZDOTDIR/.config}/zsh"

[ -r $ZSHDDIR/conf.d/gopts ] && source $ZSHDDIR/conf.d/gopts
[ -r $ZSHDDIR/conf.d/functions ] && source $ZSHDDIR/conf.d/functions

# This function tries to setup platoform independed environment
# variables.  This function WILL NOT change previously set veriables
# (if any).
zenv

# OS specific environment.
if [ -r $ZSHDDIR/conf.d/OS/$OSSHORT/zshenv ]; then
  source $ZSHDDIR/conf.d/OS/$OSSHORT/zshenv
fi

# Order is matter
typeset -a configs
configs=(
  paths   # Setting up PATHs
  mans    # Setting up MAN pages paths
  editor  # Setting up the editor
  gpg     # Setting up GnuPG
)

for c in $configs ;  do
  [ -r $ZSHDDIR/conf.d/$c ] && source $ZSHDDIR/conf.d/$c
done
unset c configs
