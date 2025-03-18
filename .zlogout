# This file is sourced when logging out from a login shell.

# Clean maybe broken zcompdump file
[[ -e "$ZSH_COMPDUMP" ]] && rm -f "$ZSH_COMPDUMP"

# Clear the screen on logout to prevent information leaks, if not already
# set as an exit trap elsewhere
[ -n "$PS1" ] && clear
