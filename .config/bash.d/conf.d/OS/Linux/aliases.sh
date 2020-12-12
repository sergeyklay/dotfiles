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

# Definition of the Linux-wide Bash aliases

# shellcheck shell=bash

# GNU's ls uses --color to enable colorized output.
# For LC_ALL see URL https://superuser.com/a/448294/280737
alias ls='ls --color=auto'
alias ll='LC_ALL="C.UTF-8" ls --color=auto -alF --group-directories-first'
alias la='ls --color=auto -A'
alias l='ls --color=auto -CF'

if command -v xdg-open >/dev/null 2>&1; then
  open() {
    (xdg-open "$@" &)
  }
fi

# Miscellaneous aliases
alias remax="systemctl --user restart emacs"

# Local Variables:
# mode: sh
# End:
