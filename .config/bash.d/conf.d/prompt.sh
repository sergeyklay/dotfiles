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

# The file containing the definition of the prompts

# shellcheck shell=bash

# Main prompt
PS1='<\t> \u@\h \w [$(echo $?)]
\$ '
# Continuation prompt
PS2="> "

colors_support=false

# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color)
    colors_support=true
    ;;
esac

# Colorize output
if [ "$colors_support" = true ]; then
  # colorize prompt
  PS1='\[\e[0;33m\]<\t>\e[0m\] \e[0;32m\]\u@\h\e[0m\] \e[0;36m\]\w\e[0m\] [$(echo $?)]\]
\$ '
  PS2="\[\033[1;37m\]>\[\033[00m\] "

  # colorize gcc output
  GCC_COLORS='error=01;31:'
  GCC_COLORS+='warning=01;35:'
  GCC_COLORS+='note=01;36:'
  GCC_COLORS+='caret=01;32:'
  GCC_COLORS+='locus=01:'
  GCC_COLORS+='quote=01'
  export GCC_COLORS

  [[ -z "$COLORTERM" ]] || COLORTERM=1
fi

unset colors_support

# Local Variables:
# mode: sh
# End:
