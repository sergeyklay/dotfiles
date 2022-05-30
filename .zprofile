#!/usr/bin/env zsh
#
# This file is sourced first for login-shells.
#   .zshenv -> [.zprofile] -> .zshrc -> .zlogin
#
# This file is sourced in login shells. It is meant as an alternative
# to `zlogin' for `ksh' fans; the two are not intended to be used together,
# although this could certainly be done if desired.
#
# What goes in it:
#
# - Commands that should be executed only in login shells
# - As a general rule, it should not change the shell environment at all
# - As a general rule, set the terminal type then run a series of external
#   commands e.g. fortune, msgs, etc
#
# What does NOT go in it:
#
# - Alias definitions
# - Function definitions
# - Options
# - Environment variable settings

# ~/.zshenv is supposed to be the ideal place to set the PATH.
# However on OS X and Arch (and previously Gentoo), the system
# /etc/zprofile which is executed after ~/.zshenv will overwrite
# the PATH variable - so to workaround that issue, PATH settings
# should be re-read in ~/.zprofile
if command -v hostname >/dev/null 2>&1; then
  ZSH_PATH_CACHE="$ZSH_CACHE_DIR/$(hostname -s).paths"
else
  ZSH_PATH_CACHE=$ZSH_CACHE_DIR/localhost.paths
fi

[ -r $ZSH_PATH_CACHE ] && {
    source $ZSH_PATH_CACHE >/dev/null 2>&1 || true
}
rm $ZSH_PATH_CACHE >/dev/null 2>&1 || true
