# Copyright (C) 2014-2024 Serghei Iakovlev <gnu@serghei.pl>
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

psproc() {
  if [ -z "$1" ]; then
    echo "Usage: psproc <keyword> [-n | -p ]" >&2
    return 1
  fi

  local keyword="$1"
  local show_header=true
  local pid_only=false

  case "$2" in
    -n)
      show_header=false
      ;;
    -p)
      show_header=false
      pid_only=true
      ;;
  esac


  if [ "$pid_only" == true ]; then
    printf "%-10s\n" "PID"
  elif [ "$show_header" == true ]; then
      printf "%-10s %s\n" "PID" "COMMAND"
  fi

  ps -eo pid,command | awk -v kw="$keyword" -v head="$show_header" -v pid="$pid_only" '
    BEGIN { IGNORECASE = 1 }

    $0 ~ kw && $2 !~ "awk" {
      if (pid == "true") {
        printf "%s\n", $1
      } else {
        com = substr($0, index($0, $2))

        if (head == "true") {
          printf "%-10s %s\n", $1, com
        } else {
          printf "%s %s\n", $1, com
        }
      }
    }
  '

  return 0
}

# Local Variables:
# mode: sh
# flycheck-disabled-checkers: (sh-posix-dash sh-shellcheck)
# End:
