# Copyright (C) 2014-2020 Serghei Iakovlev <egrep@protonmail.ch>
#
# This file is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# This file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this file.  If not, see <https://www.gnu.org/licenses/>.

# User wide interactive shell configuration and executing commands.
#
# This file is sourced by the second for login shells
# (after '~/.bash_profile').  Or by the first for interactive
# non-login shells.
#
# For $OSSHORT, $BASHD_ROOT and other variables see '.bash_profile'.

# shellcheck shell=bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
  # shellcheck disable=SC1091
  . /etc/bashrc
elif [ -f /etc/bash.bashrc ]; then
  # shellcheck disable=SC1091
  . /etc/bash.bashrc
fi

# OS specific configuration.
# This comes first as it tends to mess up things.
if [[ -f $BASHD_ROOT/conf.d/OS/$OSSHORT/bashrc.sh ]]; then
  # shellcheck disable=SC1090
  . "$BASHD_ROOT/conf.d/OS/$OSSHORT/bashrc.sh"
fi

# Order is matter
configs=(
  ble      # Bash Line Editor
  hist     # Setting up history
  aliases  # The definition of aliases
  prompt   # The definition of the prompts
  comp     # Configure completion
)

for c in "${configs[@]}" ;  do
  # shellcheck disable=SC1090
  [[ -f $BASHD_ROOT/conf.d/$c.sh ]] && . "$BASHD_ROOT/conf.d/$c.sh"
done

plugins=(
#  phpenv
#  rbenv
  sdkman
  venv
)

for p in "${plugins[@]}" ;  do
  plugin "$p"
done

unset c p configs plugins

# Local Variables:
# mode: sh
# End:
