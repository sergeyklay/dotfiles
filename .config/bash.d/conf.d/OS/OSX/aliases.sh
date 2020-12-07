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

# Definition of the macOs-wide Bash aliases

# shellcheck shell=bash

# brew install coreutils
if command -v gls >/dev/null 2>&1; then
  # GNU's ls uses --color to enable colorized output.
  # For LC_ALL see URL https://superuser.com/a/448294/280737
  alias ll='LC_ALL="C.UTF-8" gls --color=auto -alF --group-directories-first'
  alias la='gls --color=auto -A'
  alias l='gls --color=auto -CF'
else
  # BSD's ls uses -G to enable colorized output.
  # For LC_ALL see URL https://superuser.com/a/448294/280737
  alias ll='LC_ALL="C.UTF-8" ls -G -alF'
  alias la='ls -G -A'
  alias l='ls -G -CF'
fi

# macOS uses too outdated make.  I prefer install a fresh one
# using brew and alias it here.
if command -v gmake >/dev/null 2>&1; then
  alias make='gmake'
fi

# brew install coreutils
if command -v gcp >/dev/null 2>&1; then
  alias cp='gcp'
fi

# Local Variables:
# mode: sh
# End:
