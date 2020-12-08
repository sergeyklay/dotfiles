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

# This file containing user wide settings for functions.

# shellcheck shell=bash

# Load required function.
# TODO(serghei): Refactor to provide ability source custom file
function autoload {
  if [  $# -eq 0 ]; then
    >&2 echo "autoload: Missing required argument #1"
    return 1
  fi

  local library

  if [  $# -gt 1 ]; then
    case "$2" in
      function)
        library="${BASHD_ROOT}/lib"
        ;;
      plugin)
        library="${BASHD_ROOT}/plugins"
        ;;
      *)
        >&2 echo "autoload: unexpected type of autoloading"
        return 1
        ;;
    esac
  else
    library="${BASHD_ROOT}/lib"
  fi

  if [[ ! -d $library ]]; then
    >&2 echo "autoload: $library Direcory not found"
    return 1
  fi

  local name
  if [[ $2 = plugin ]]; then
    name="_plugin_${1}"
  else
    name="$1"
  fi

  if [ "$(LC_ALL=C type -t "$name")" != function ]; then
    if [[ -f $library/$1.sh ]]; then
      # shellcheck disable=SC1090
      . "$library/${1}.sh"
    else
      echo "autoload: file $library/${1}.sh not found"
      return 1
    fi
  fi
}

# Meand for autoloading plugins.
# For more see 'autoload' function.
function plugin {
  if [  $# -eq 0 ]; then
    >&2 echo "plugin: Missing required argument #1"
    return 1
  fi

  local func

  func="$1"
  autoload "$func" plugin

  func="_plugin_$func"
  $func

}

# Local Variables:
# mode: sh
# End:
