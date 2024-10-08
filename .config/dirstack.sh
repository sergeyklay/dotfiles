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

# The Directory Stack Functions \ Aliases.
#
# Configure Bash to remember the DIRSTACKSIZE last visited folders.
# This can then be used to cd them very quickly.
#
# This file is intended to be sourced from interactive shells,
# i.e. in '~/.bashrc' file.

# shellcheck shell=bash

# Set the directory stack size limit to 20.
DIRSTACKSIZE=20

# Set the path to persist a directory path.
# Do not use '~' here.
DIRSTACKFILE="${XDG_CACHE_HOME:-$HOME/.cache}/dirs"

# Reverts the +/- operators for an integer argument.
#
#   $ polarize -1  # +1
#   $ polarize +12 # -12
#   $ polarize 2-2 # 2-2
#   $ polarize - 1 # - 1
#
# Meant for 'pushd' (see  bellow).
polarize() {
  if [[ "$*" =~ ^[-+][1-9][[:digit:]]*$ ]]; then
    printf '%+d' "$(( -$@ ))"
  else
    echo -n "$@"
  fi
}

# Removes duplicate values from the directory stack.
#
#   $ ln -s /tmp /tmp2         # Create symlink
#   $ pushd /tmp ; pushd /tmp2 # Add two directories to the stack
#   $ dirs -v | wc -l          # Will return 1
#   $ pushd ~                  # Change directory
#   $ dirs -v | wc -l          # Will return 2
#
# Note: Two elements are considered equal iff
# 'realpath $elem1 == realpath $elem2' i.e. when the resolved
# representation is the same, the first element will be used.
# Thus, this will work for symlinks too.
#
# Meant for 'pushd' (see bellow).
uniqd() {
  local -i dups
  dups=0

  local cwd
  cwd="$(pwd -P)"

  for i in $(seq 0 $((${#DIRSTACK[@]}-1))); do
    dir="${DIRSTACK[$i]/%\//}"
    if [ -z "$dir" ]; then
      continue
    fi

    dir="$(realpath "$dir" 2>/dev/null || true)"

    # realpath for a non existent nested directory will return empty
    # string.  Remove them from the directory stack
    if [ -z "$dir" ]; then
      builtin popd -n "+$i" 1>/dev/null || true
      continue
    fi

    # Remove no longer existent paths from the directory stack
    if [ ! -d "$dir" ]; then
      builtin popd -n "+$i" 1>/dev/null || true
      continue
    fi

    # Remove duplicates
    if [ "$dir" = "$cwd" ]; then
      ((dups++))
      if [ "$dups" -gt 1 ]; then
        builtin popd -n "+$i" 1>/dev/null || true
        dups=1
      fi
    fi
  done
}

# Persist current directory stack to DIRSTACKFILE file.
#
# Meant for 'pushd' (see below).
persistd() {
  local dbfile
  dbfile="${DIRSTACKFILE:-/dev/null}"

  local dbpath
  dbpath="$(dirname "$dbfile")"

  [ "$dbfile" = "/dev/null" ] && return

  ([ -d "$dbpath" ] || mkdir -p "$dbpath" 2>/dev/null) || return
  ([ -f "$dbfile" ] || touch "$dbfile" 2>/dev/null) || return

  # Empty the directory stack file
  echo -n "" >|"$dbfile" 2>/dev/null || return

  for i in $(seq 0 $((${#DIRSTACK[@]}-1))); do
    # Do not insert final newline
    if [[ "$i" -eq $((${#DIRSTACK[@]}-1)) ]]; then
      printf "%s" "${DIRSTACK[$i]}" >> "$dbfile"
    else
      printf "%s\\n" "${DIRSTACK[$i]}" >> "$dbfile"
    fi
  done
}

# Limit DIRSTACK size up to DIRSTACKSIZE.
#
# Meant for 'pushd' (see bellow).
limitd() {
  local -i ssize
  ssize="$(printf '%d' "${DIRSTACKSIZE:-20}")"

  if [ "$ssize" -gt 0 ]; then
    while [ ${#DIRSTACK[*]} -gt "$ssize" ]; do
      # Remove last element
      builtin popd -n -0 1>/dev/null || true
    done
  fi
}

# Restore previous directory history from the cache and cd to
# first directory in the directory stack.
restored() {
  declare -r dbfile="${DIRSTACKFILE:-/dev/null}"
  declare -a stack

  [ "$dbfile" = "/dev/null" ] && return
  if [ ! -f "$dbfile" ] || [ ${#DIRSTACK[*]} -gt 1 ]; then
    return
  fi

  readarray -t stack < "$DIRSTACKFILE"

  # Reverse a for loop
  for ((i=${#stack[@]}-1; i>=0; --i)); do
    # Skip empty or new lines
    if [ "x$(printf '%s' "${stack[$i]}" | tr -d "$IFS")" = x ]; then
      continue
    fi

    builtin pushd -n "${stack[$i]}" 1>/dev/null
  done

  # In case when we're started from a fresh session
  # we need to remove the first element.
  if (( ${#DIRSTACK[*]} > 1)) && [[ -d "${DIRSTACK[1]}" ]]; then
    builtin popd +0 1>/dev/null || true
  elif [[ -d "${DIRSTACK[0]}" ]]; then
    builtin cd -- "${DIRSTACK[0]}" || return
  fi
}

# Save the current directory on the top of the directory stack
# and then cd to dir.
#
# Meant for 'cd' (see bellow).
pushd() {
  local dir

  # Have pushd with no arguments act like `pushd $HOME'.
  # This is similar with how 'cd' it does.
  if [ $# -eq 0 ]; then
    dir="${HOME}"
  else
    dir="$(polarize "$1")"
  fi

  # Do not print the directory stack after pushd
  builtin pushd "${dir}" 1>/dev/null || return

  # Don't store multiple copies of the same directory onto the
  # directory stack.
  uniqd

  # Limit $DIRSTACK size up to $DIRSTACKSIZE.
  limitd

  # Persist current directory stack.
  persistd
}

# Silently removes the top directory from the stack
# and performs a cd to the new top directory.
#
# Meant for 'back' (see bellow).
popd() {
  # Do not print the directory stack after popd
  builtin popd 1> /dev/null || return
}

# Move between the current and previous directories
# without popping them from the directory stack.
#
#   $ cd /usr  # We're at /usr now
#   $ cd /tmp  # We're at /tmp now
#   $ flipd    # We're at /usr now
flipd() {
  # Do not print the directory stack after pushd
  builtin pushd 1> /dev/null || return
}

# Keep track of visited directories.
#
# Performs normal 'cd', but writes dirstack to a rotating file
# which is shared between terminals/sessions.
#
#   $ dirs -v # See the directories stack
#   $ cd -N   # Go back to a visited folder N
alias cd='pushd'

# Goes to the previous directory that you 'cd'-ed from.
#
#   $ cd ~/ ; cd /tmp # We're at /tmp now
#   $ back            # We're at $HOME now
alias back='popd'

# Restore the directory stack
restored

# Local Variables:
# mode: sh
# flycheck-disabled-checkers: (sh-posix-dash sh-shellcheck)
# End:
