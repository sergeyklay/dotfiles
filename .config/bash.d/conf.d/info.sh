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

# Setup list of directories to search for Info documentation files.

# shellcheck shell=bash

autoload utils

# Only do this if the INFOPATH variable isn't already set.
if [ -z ${INFOPATH+x} ] || [ "$INFOPATH" = ":" ]; then
  INFOPATH=""
fi

IFS=':' read -ra paths <<< "$INFOPATH"

places=(
  /usr/share/info
  /usr/local/share/info
  "$HOME/info"
  "$HOME/.local/share/info"
)

for p in "${places[@]}"; do
  if [[ -d $p ]] && ! in_array "$p" "${paths[@]}"; then
    paths=("$p" "${paths[@]}")
  fi
done
unset places

INFOPATH="$( IFS=$':'; echo -n "${paths[*]}" )"
unset paths

INFOPATH="${INFOPATH//\/:/:}"
INFOPATH="${INFOPATH%/}"

export INFOPATH
