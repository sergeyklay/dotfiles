# Copyright (C) 2016 Mauro Calderara
# Copyright (C) 2020 Serghei Iakovlev <egrep@protonmail.ch>
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

lw_usage() {
  cat <<'EOF'
locknwait v0.0.2

A shell function to create a lockfile or wait for one to vanish.

Usage:
  locknwait <lockfilename> [<granularity>] [<timeout>]

Arguments:
  <lockfilename>        The name of the lockfile
  <granularity>         How fast the lockfile's presence is being
                        rechecked [Default: 1]
  <timeout>             How long to wait before giving up
                        [Default: infinite]

Note: You must remove the generated lockfile manually, locknwait
won't do it for you.
EOF
}

# A shell function to create a lockfile or wait for one to vanish
#
# It takes 3 arguemnts:
#  $1    the lockfile to wait for or to create (required)
#  $2    the granularity (optional, default is 1 second)
#  $3    the timeout (optional, default is infinite)
#
# This locking process is inspired by comp.unix.shell FAQ:
# https://web.archive.org/web/20181117143655/http://dan.hersam.com/docs/cus-faq.html#8
locknwait() {
  if [  $# -eq 0 ]; then
    lw_usage
    return 1
  fi

  if [[ ( $* == "--help") ||  $* == "-h" ]]; then
    lw_usage
    return 0
  fi

  local lockfile
  lockfile="$1"

  local -i granularity

  if [ -n "$2" ]; then
    if [[ "$2" =~ ^[[:digit:]]*$ ]]; then
      granularity="$(printf '%d' "$2")"
    else
      >&2 echo -n "locknwait: Invalid granularity. "
      >&2 echo "Expected a positive number, got \"$2\"."
      return 1
    fi
  else
    granularity=1
  fi

  local -i timeout

  if [[ -n "$3" ]] && [[ "$3" != infinite ]]; then
    if [[ "$3" =~ ^[[:digit:]]*$ ]]; then
      timeout="$(printf '%d' "$3")"
    else
      >&2 echo -n "locknwait: Invalid timeout. "
      >&2 echo "Expected a positive number or \"infinite\", got \"$3\"."
      return 1
    fi
  else
    timeout=0
  fi

  # This will store return status
  local -i ret

  # Introduce some randomness to avoid conflicts when doing massive
  # locking in parallel.
  local to_sleep
  to_sleep="$(echo "scale=4; $RANDOM / 80000" | bc -l)"
  sleep "$to_sleep"

  local tmpdir
  if [ -n "$TMPDIR" ] && [ -w "$TMPDIR" ]; then
    tmpdir="$TMPDIR"
  else
    tmpdir="/tmp"
  fi

  local tmpfile
  tmpfile="$(mktemp -q "${tmpdir}/$$-${lockfile##*/}.XXXXXX")"
  ret=$?

  if [ $ret -ne 0 ]; then
    >&2 echo "locknwait: ERROR: /tmp is not writeable."
    return 1
  fi

  local -i sleept
  sleept=0

  while [ -L "$lockfile" ]; do
    sleep $granularity

    if [ $timeout -gt 0 ]; then
      sleept=$((sleept + granularity))

      if [ $sleept -gt $timeout ]; then
        echo -n "locknwait: Timeout reached, "
        echo -n "trying to remove lockfile by force: "

        if rm -rf "$lockfile" 1>&2 > /dev/null; then
          echo success
        else
          echo failed
          return 1
        fi
      fi
    fi
  done

  ln -s "$tmpfile" "$lockfile"
  ret=$?
  rm "$tmpfile"

  if [ $ret -ne 0 ]; then
    >&2 echo \
        "locknwait: ERROR: unable to write lockfile: \"$lockfile\"."
    return 1
  fi
}

# Local Variables:
# mode: sh
# End:
