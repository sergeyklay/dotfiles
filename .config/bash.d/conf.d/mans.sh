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

# Setting the tist of directories to search for manpages.

# shellcheck shell=bash

autoload utils

# Only do this if the MANPATH variable isn't already set.
if [ -z ${MANPATH+x} ] || [ "$MANPATH" = ":" ] ; then
  if command -v manpath >/dev/null 2>&1; then
    # Get the original manpath, then modify it.
    MANPATH="$(manpath 2>/dev/null)"
  else
    MANPATH=""
  fi
fi

IFS=':' read -ra mans <<< "$MANPATH"

places=(
  /usr/man
  /usr/share/man
  /usr/local/man
  /opt/homebrew/man
  /usr/local/share/man
  /opt/homebrew/share/man
  /opt/man
  "$HOME/man"
  "$HOME/.local/share/man"
)

for p in "${places[@]}"; do
  if [[ -d $p ]] && ! in_array "$p" "${mans[@]}"; then
    mans=("$p" "${mans[@]}")
  fi
done
unset places

MANPATH="$( IFS=$':'; echo -n "${mans[*]}" )"
unset mans

MANPATH="${MANPATH//\/:/:}"
MANPATH="${MANPATH%/}"

export MANPATH
