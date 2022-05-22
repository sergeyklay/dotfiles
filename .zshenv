#!/usr/bin/env zsh

# Zsh startup file.
#
# This file is sourced on all invokations of zsh.
#   [.zshenv] -> .zprofile -> .zshrc -> .zlogin

# Used for setting user's environment variables.
# For more see 'man zsh(1)'.

# The base directories for all startup/shutdown files.
ZDOTDIR=${ZDOTDIR:-${HOME}}
ZSHDDIR="${XDG_CONFIG_HOME:-$ZDOTDIR/.config}/zsh"

[ -r $ZSHDDIR/conf.d/gopts ] && source $ZSHDDIR/conf.d/gopts
[ -r $ZSHDDIR/conf.d/defuns ] && source $ZSHDDIR/conf.d/defuns

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
