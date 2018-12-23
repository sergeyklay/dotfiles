#!/bin/bash

#
# ~/.bash_logout
# executed by bash(1) when login shell exits.
#

# When leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
  [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

# vim:ft=sh:ts=8:sw=2:sts=2:tw=80:et
