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

# shellcheck shell=bash

# Checks if a value exists in an array.
#
#     # Check if the array has a certain key:
#     $ in_array "key" "${!array[@]}"
#
#     # Check if the array contains a certain value:
#     $ in_array "key" "${array[@]}"
#
in_array() {
  local p

  for p in "${@:2}"; do
    [[ "$p" = "$1" ]] && return 0
  done

  return 1
}

ucfirst() {
  local p

  # shellcheck disable=SC2016
  p='{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) }}1'

  echo -n "$1" | awk "$p"
}

warn() {
  { if [ "$#" -eq 0 ]; then cat -
    else echo "bash.d: $*"
    fi
  } >&2
}

abort() {
  { if [ "$#" -eq 0 ]; then cat -
    else echo "bash.d: $*"
    fi
  } >&2
  exit 1
}
