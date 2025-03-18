
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