#!/usr/bin/env zsh

# Zsh startup file.
#
# This file is sourced on interactive invokations of zsh.
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
  zle            # Zsh Line Editor
  history        # Setting up history
  aliases        # The definition of aliases
  colors         # Setting up colors
  prompt         # The definition of the prompts
  completion     # Setting up completion support
  keybindings    # Definition of keybindings
  mans           # Setting up MAN pages paths
  nvm            # Setting up Node Version Manager
)

for c in $configs ;  do
  [ -r $ZSHDDIR/conf.d/$c ] && source $ZSHDDIR/conf.d/$c
done
unset c configs
