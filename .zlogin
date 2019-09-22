#!/usr/bin/env zsh
#
# Executes commands at login post-zshrc.
#

# execute code that does not affect the current session in the background.
{
  # compile the completion dump to increase startup speed.
  if [[ -s "$ZSH_COMPDUMP" && (! -s "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc") ]]
  then
    zcompile "$ZSH_COMPDUMP"
  fi
} &!

# vim:ft=zsh:ts=2:sw=2:sts=2:tw=78:fenc=utf-8:et
