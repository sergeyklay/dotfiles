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

# Linux-wide configuration for editor, pager, and so on.

# shellcheck shell=bash

# Use a lesspipe filter, if we can find it.
# This sets the $LESSOPEN variable.
if command -v lesspipe >/dev/null 2>&1 ; then
  # eval "$(lesspipe)"
  LESSOPEN="|lesspipe %s"
  export LESSOPEN
fi

# Local Variables:
# mode: sh
# End:
