#!/usr/bin/env zsh

# Executes commands at login post-zshrc.
#
# This file is sourced last for login-shells.
#   .zshenv -> .zprofile -> .zshrc -> [.zlogin]

# Execute code that does not affect the current session in the background.
{
  # compile the completion dump to increase startup speed.
  if [[ -s "$ZSH_COMPDUMP" && (! -s "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc") ]]
  then
    zcompile "$ZSH_COMPDUMP"
  fi
} &!

