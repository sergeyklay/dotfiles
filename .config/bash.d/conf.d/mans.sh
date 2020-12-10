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

# # This file contains the configuration of manpages.

# shellcheck shell=bash

# MANPATH: path for the man command to search.
# Look at the manpath command's output and prepend my own manual
# paths manually.
# TODO(serghei): Do not add dups
if [ -z ${MANPATH+x} ] || [ "$MANPATH" = ":" ] ; then
  # Only do this if the MANPATH variable isn't already set.
  if command -v manpath >/dev/null 2>&1; then
    # Get the original manpath, then modify it.
    MANPATH="$(manpath 2>/dev/null)"
  else
    MANPATH=""
  fi

  IFS=':' read -r -a mans <<< "$MANPATH"

  # TODO(serghei): Add at the start
  mans+=(~/man)
  mans+=(/opt/man)
  mans+=(/usr/local/share/man)
  mans+=(/usr/local/man)
  mans+=(/usr/share/man)
  mans+=(/usr/man)

  MANPATH="$( IFS=$':'; echo -n "${mans[*]}" )"
  unset mans

  MANPATH="${MANPATH//\/:/:}"
  MANPATH="${MANPATH%/}"

  export MANPATH
fi

# Local Variables:
# mode: sh
# End:
