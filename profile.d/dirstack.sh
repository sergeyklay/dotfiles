# The Directory Stack Functions \ Aliases.

# Reverts the +/- operators for an integer argument.
#
#   $ polarize -1  # +1
#   $ polarize +12 # -12
#   $ polarize 2-2 # 2-2
#   $ polarize - 1 # - 1
#
# Meant for 'pushd' (see  bellow).
function polarize() {
  [ $# -ne 1 ] && echo -n "$@" && return

  if [[ "$1" =~ ^[-+]{1}[[:digit:]]$ ]]; then
    printf "%+d" $(($1 * -1))
  else
    echo -n "$1"
  fi
}

# Removes duplicate values from the $DIRSTACK.
#
# Note: Two elements are considered equal iff
# 'realpath $elem1 == realpath $elem2' i.e. when the reloved
# representation is the same, the first element will be used.
# Thus, this will work for symlinks too.
#
# Meant for 'pushd' (see bellow).
function dirstack-unique() {
  local dups
  local dir
  local cwd

  dups=0
  cwd="$(pwd -P)"

  for i in $(seq 0 $((${#DIRSTACK[@]}-1))); do
    dir="${DIRSTACK[$i]/%\//}"
    if [ -z "$dir" ]; then
      continue
    fi

    if [ "$(realpath "$dir")" = "$cwd" ]; then
      ((dups++))
      if [ "$dups" -gt 1 ]; then
        builtin popd -n "+$i" 1>/dev/null || true
        dups=1
      fi
    fi
  done
}

# Save the current directory on the top of the directory stack
# and then cd to dir.
#
# Meant for 'cd' (see bellow).
function pushd() {
  local dir
  local ssize

  ssize="$(printf '%d' "${DIRSTACKSIZE:-20}")"

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
  #
  #   $ ln -s /tmp /tmp2         # Create symlink
  #   $ pushd /tmp ; pushd /tmp2 # Add two directories to the stack
  #   $ dirs -v | wc -l          # Will return 1
  #   $ pushd ~                  # Change directory
  #   $ dirs -v | wc -l          # Will return 2
  dirstack-unique

  # Limit $DIRSTACK size up to $DIRSTACKSIZE
  if [ "$ssize" -gt 0 ]; then
    while [ ${#DIRSTACK[*]} -gt "$ssize" ]; do
      # Remove last element
      builtin popd -n -0 1>/dev/null || true
    done
  fi
}

# Silently removes the top directory from the stack
# and performs a cd to the new top directory.
#
# Meant for 'back' (see bellow).
function popd() {
  # Do not print the directory stack after popd
  builtin popd 1> /dev/null || return
}

# Move between the current and previous directories
# without popping them from the directory stack.
#
#   $ cd /usr  # We're at /usr now
#   $ cd /tmp  # We're at /tmp now
#   $ flip     # We're at /usr now
function flip() {
  # Do not print the directory stack after pushd
  builtin pushd 1> /dev/null || return
}

# Keep track of visited directories.
#
#   $ dirs -v # See the directores stack
#   $ cd -N   # Go back to a visited folder N
alias cd='pushd'

# Goes to the previous directory that you 'cd'-ed from.
#
#   $ cd ~/ ; cd /tmp # We're at /tmp now
#   $ back            # We're at $HOME now
alias back='popd'

# Local Variables:
# mode: sh
# End:
