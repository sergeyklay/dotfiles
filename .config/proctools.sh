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

# psproc - A utility to search for processes by keyword with optional
# output customization
#
# SYNOPSIS
#   psproc <keyword> [-n] [-p]
#
# DESCRIPTION
#   The psproc function searches for processes matching a specified
#   keyword and displays their PID and command. Optional flags allow
#   for customizing the output.
#
#   The search is case-insensitive and excludes the process running
#   the search itself (e.g., the `awk` command).
#
#   Parameters:
#
#   <keyword>
#       The keyword to search for in the process list. The search
#       matches any part of the command line.
#
# OPTIONS
#   -n
#       Suppress the output header. By default, the header includes
#       "PID" and "COMMAND".
#
#   -p
#       Show only the process IDs (PIDs) of matching processes. The
#       command column is excluded.
#
# USAGE
#   1. Search for processes containing "bash" in their command:
#        psproc bash
#
#   2. Search for processes containing "bash" and suppress the header:
#        psproc bash -n
#
#   3. Display only the PIDs of processes containing "bash":
#        psproc bash -p
#
#   4. Combine options: suppress the header and display only PIDs:
#        psproc bash -n -p
#
#   5. Use the keyword after options:
#        psproc -p -n bash
#
# NOTES
#   - The function uses `ps -eo pid,command` to fetch process
#     information and `awk` for filtering and formatting the output.
#   - The function checks for invalid input and prints usage
#     instructions if the arguments are incorrect or insufficient.
#
# ERRORS
#   - If no keyword is provided or multiple arguments are passed
#     without valid options, the function will display the usage:
#        Usage: psproc <keyword> [-n | -p]
#
#   - If no processes match the keyword, an error message will be printed:
#        No matching processes found for keyword: <keyword>
#
# RETURN VALUE
#   - Returns 0 on success.
#   - Returns 1 on errors such as invalid arguments or no matching
#     processes.
#
# DEPENDENCIES
#   - The function relies on standard utilities: `ps`, `awk`, and a
#     POSIX-compliant shell.
#
# EXAMPLES
#   Search for Python processes:
#       psproc python
#
#   Display only the PIDs of processes containing "nginx":
#       psproc nginx -p
#
#   Search for "java" processes without headers:
#       psproc java -n
psproc() {
  local show_header=true
  local pid_only=false

  local args=()
  while [[ "$1" ]]; do
    case "$1" in
      -n) show_header=false ;;
      -p) pid_only=true ;;
      -*)
        echo "Usage: psproc <keyword> [-n | -p]" >&2
        return 1
        ;;
      *)
        args+=("$1")
        ;;
    esac
    shift
  done

  if [[ "${#args[@]}" -ne 1 ]]; then
    echo "Usage: psproc <keyword> [-n | -p ]" >&2
    return 1
  fi

  local keyword="${args[0]}"

  if [ "$show_header" == true ]; then
    if [ "$pid_only" == true ]; then
      printf "%-10s\n" "PID"
    else
      printf "%-10s %s\n" "PID" "COMMAND"
    fi
  fi

  ps -eo pid,command | awk -v kw="$keyword" -v wide="$show_header" -v pid="$pid_only" '
    BEGIN { IGNORECASE = 1 }

    $0 ~ kw && $2 !~ "awk" {
      if (pid == "true") {
        printf "%s\n", $1
      } else {
        com = substr($0, index($0, $2))

        if (wide == "true") {
          printf "%-10s %s\n", $1, com
        } else {
          printf "%s %s\n", $1, com
        }
      }
    }
  ' || {
    echo "No matching processes found for keyword: $keyword" >&2
    return 1
  }

  return 0
}

# Local Variables:
# mode: sh
# End:
