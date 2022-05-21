#!/usr/bin/env zsh

# This file is sourced when logging out from a login shell.

# Clean maybe broken zcompdump file
[[ -e "$ZSH_COMPDUMP" ]] && rm -f "$ZSH_COMPDUMP"
