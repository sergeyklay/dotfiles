#!/usr/bin/env zsh

# Zsh startup file.
#
# This file is sourced on interactive invocations of zsh.
#   .zshenv -> .zprofile -> [.zshrc] -> .zlogin
#
# Used for setting user's interactive shell configuration and
# executing commands, will be read when starting as an interactive
# shell.
#
# For $OSSHORT, $ZSHDDIR and other variables see .zshenv.

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# This means ~/.zshenv was not sourced.
if [ -z ${ZDOTDIR+x} ] && [ -r $HOME/.zshenv ]; then
  source $HOME/.zshenv
fi

# OS specific configuration.
# This comes first as it tends to mess up things.
if [ -r $ZSHDDIR/conf.d/OS/$OSSHORT/zshrc ]; then
  source $ZSHDDIR/conf.d/OS/$OSSHORT/zshrc
fi

# Note, order is matter.
typeset -a configs
configs=(
  editor         # Editor
  zle            # Zsh Line Editor
  colors         # Colors
  completion     # Completion support
  keybindings    # Definition of keybindings
  nvm            # Node Version Manager
  pyenv          # Python Version Manager
)

for c in $configs ;  do
  [ -r $ZSHDDIR/conf.d/$c ] && source $ZSHDDIR/conf.d/$c
done
unset c configs
