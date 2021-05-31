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
autoload() {
  if [  $# -eq 0 ]; then
    >&2 echo "autoload: Missing required argument #1"
    return 1
  fi

  local library
  local sfile

  if [  $# -gt 1 ]; then
    case "$2" in
      "function")
        library="${BASHD_ROOT}/lib"
        sfile="$1.sh"
        ;;
      "plugin")
        library="${BASHD_ROOT}/plugins"
        sfile="plugin.$1.sh"
        ;;
      *)
        >&2 echo "autoload: unexpected type of autoloading"
        return 1
        ;;
    esac
  else
    library="${BASHD_ROOT}/lib"
    sfile="$1.sh"
  fi

  if [[ ! -d $library ]]; then
    >&2 echo "autoload: direcory $library not found"
    return 1
  fi

  local name
  if [[ $2 = "plugin" ]]; then
    name="_plugin_${1}"
  else
    name="$1"
  fi

  if [ "$(LC_ALL=C type -t "$name")" != "function" ]; then
    if [[ -f $library/$sfile ]]; then
      # shellcheck disable=SC1090
      . "$library/$sfile"
    else
      >&2 echo "autoload: file $library/$sfile not found"
      return 1
    fi
  fi
}

autoload utils

# Meant for autoloading plugins.
# For more see 'autoload' function.
plugin() {
  if [  $# -eq 0 ]; then
    abort "Missing required argument #1"
  fi

  local func

  func="$1"
  autoload "$func" plugin

  func="_plugin_$func"

  # Second argument stands for load mode
  if [ $# -eq 2 ]; then
    local mode
    mode="$2"

    case $mode in
      l)
        func="${func}_login"
        ;;
      *)
        warn "Invalid mode '$mode' for plugin '$func'"
        return 1
        ;;
    esac
  fi

  if [ -z "$(LC_ALL=C type -t "$func")" ] || \
      [ "$(LC_ALL=C type -t "$func")" != function ]; then
    warn "'$func' is not a function"
    return 1
  fi

  $func
}

# Local Variables:
# mode: shell-script
# End:
