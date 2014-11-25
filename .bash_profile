#!/bin/bash

#
# Bash profile
#

# Load local configuration file
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Local run (per user) of mpd
[[ ! -s ~/.config/mpd/pid ]] && mpd

# vim:ft=sh:ts=8:sw=2:sts=2:tw=80:et
