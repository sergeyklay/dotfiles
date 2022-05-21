#!/usr/bin/env zsh

# Zsh startup file.
#
# This file is sourced on all interactive shells.
#   .zshenv -> .zprofile -> .zshrc -> .zlogin
#
# Used for setting user's interactive shell configuration and
# executing commands, will be read when starting as an interactive
# shell.
#
# For $OSSHORT, $ZSHDDIR and other variables see .zshenv.

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# OS specific configuration.
# This comes first as it tends to mess up things.
if [ -r $ZSHDDIR/conf.d/OS/$OSSHORT/zshrc ]; then
  source $ZSHDDIR/conf.d/OS/$OSSHORT/zshrc
fi

# Note, order is matter.
configs=(
  zle            # Zsh Line Editor
  history        # Setting up history
  aliases        # The definition of aliases
  prompt         # The definition of the prompts
  completion     # Setting up completion support
  keybindings    # Definition of keybindings
)

for c in "$configs[@]" ;  do
  [ -r $ZSHDDIR/conf.d/$c ] && source $ZSHDDIR/conf.d/$c
done

unset c configs
