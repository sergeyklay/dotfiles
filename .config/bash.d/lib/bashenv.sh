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

# Setup platform independed environment variables.  This script
# WILL NOT change previously set veriables (if any).
function bashenv() {
  # If one of these is already set we won't override it.
  # Thus we need a copy before we load the cache.
  [ -z "$OSLONG" ]    || OSLONG_BACK="$OSLONG"
  [ -z "$OSSHORT" ]   || OSSHORT_BACK="$OSSHORT"
  [ -z "$OSDISTRO" ]  || OSDISTRO_BACK="$OSDISTRO"
  [ -z "$OSRELEASE" ] || OSRELEASE_BACK="$OSRELEASE"
  [ -z "$ARCH" ]      || ARCH_BACK="$ARCH"
  [ -z "$HOST" ]      || HOST_BACK="$HOST"
  [ -z "$HOSTNAME" ]  || HOSTNAME_BACK="$HOSTNAME"
  [ -z "$UID" ]       || UID_BACK="$UID"
  [ -z "$GID" ]       || GID_BACK="$GID"

  # Create cache directory if needed
  local cache_dir
  cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/bash.d"
  [ -d "$cache_dir" ] || mkdir -p "$cache_dir"

  # If the values of the somewhat more complex variables are already
  # detected, source them from a file instead of invoking this whole
  # thing each time the function call.

  local env_cache
  if command -v hostname >/dev/null 2>&1; then
    env_cache="$cache_dir/env/$(hostname -s)"
  else
    env_cache="$cache_dir/env/localhost"
  fi

  local cache_lock
  cache_lock="${env_cache}.lock"

  if [ -L "$cache_lock" ]; then
    # Someone is writing to the cache, let's just wait a little.
    echo -n "bashenv: Found lockfile: \"$cache_lock\", "
    echo -n "sleeping for 1 second..."
    sleep 1

    if [ -L "$cache_lock" ]; then
      echo "bashenv: Lockfile still around, giving another 5 seconds..."
      sleep 5

      if [ -L "$cache_lock" ]; then
        echo "bashenv: Assuming stale lockfile, removing both lock and cache..."
        rm -f "$cache_lock" "$env_cache"
      fi
    fi
  fi

  if [ -f "$env_cache" ]; then
    # shellcheck disable=SC1090
    . "$env_cache"

    # Restore previously set variables (if any)
    [ x"$OSLONG_BACK" = x ]    || OSLONG="$OSLONG_BACK"
    [ x"$OSSHORT_BACK" = x ]   || OSSHORT="$OSSHORT_BACK"
    [ x"$OSDISTRO_BACK" = x ]  || OSDISTRO="$OSDISTRO_BACK"
    [ x"$OSRELEASE_BACK" = x ] || OSRELEASE="$OSRELEASE_BACK"
    [ x"$ARCH_BACK" = x ]      || ARCH="$ARCH_BACK"
    [ x"$HOST_BACK" = x ]      || HOST="$HOST_BACK"
    [ x"$HOSTNAME_BACK" = x ]  || HOSTNAME="$HOSTNAME_BACK"
    [ x"$UID" = x ]            || UID="$UID_BACK"
    [ x"$GID" = x ]            || GID="$GID_BACK"

    # Cleanup
    unset OSLONG_BACK OSSHORT_BACK OSDISTRO_BACK OSRELEASE_BACK
    unset ARCH_BACK HOST_BACK HOSTNAME_BACK UID_BACK GID_BACK

    # Stop sourcing this file and exit with a success status
    return 0
  fi

  # Load required functions
  for f in locknwait upcase; do
    if [ -z "$(LC_ALL=C type -t $f)" ] || \
         [ "$(LC_ALL=C type -t $f)" != function ]; then
      # shellcheck disable=SC1090
      . "$BASHD_ROOT/lib/${f}.sh"
    fi
  done

  # If we can't load from cache, then set all the required variables
  # by hand.

  # Create the cache directory if it isn't present
  [ -d "${env_cache%/*}" ] || mkdir -p "${env_cache%/*}"

  locknwait "$cache_lock"

  # A workaround to get OS name on Linux and macOS systems
  OSLONG="$(uname -o 2>/dev/null || uname -s)"

  case $OSLONG in
    *Linux)
      OSSHORT=Linux

      if command -v hostname >/dev/null 2>&1; then
        HOST="$(hostname -s)"
        HOSTNAME="$(hostname --fqdn)"
      else
        HOST=localhost
        HOSTNAME="$HOST.localdomain"
      fi

      ARCH=$(uname -m)
      [ "$ARCH" = i386 ] && ARCH=x86_32
      [ "$ARCH" = amd64 ] && ARCH=x86_64

      if command -v lsb_release >/dev/null 2>&1; then
        OSDISTRO="$(lsb_release -i | cut -f2-)"
        OSRELEASE="$(lsb_release -r | cut -f2-)"
        OSCODENAME="$(lsb_release -c | cut -f2-)"

        if [[ $OSRELEASE = "n/a" ]] || [[ $OSRELEASE = *rolling ]]
        then
          unset OSRELEASE
        elif [[ $OSCODENAME = "n/a" ]] || [[ $OSCODENAME = Final ]]
        then
          unset OSCODENAME
        else
          OSRELEASE="$OSRELEASE ($OSCODENAME)"
        fi
      elif [ -f /etc/redhat-release ]; then
        OSDISTRO=$(head -n 1 /etc/redhat-release | cut -d' ' -f1)
      elif [ -f /etc/os-release ]; then
        OSDISTRO=$(awk -F= '/^ID/{ printf "%s", $2; exit }' \
                       /etc/os-release)

        # arch -> Arch
        # gentoo -> Gentoo
        OSDISTRO="$(upcase "$OSDISTRO")"

        if [ -f /etc/gentoo-release ]; then
          OSRELEASE=$(grep -oE '[^ ]+$' /etc/gentoo-release)
        else
          OSRELEASE=$(awk -F= '/^BUILD_ID/{ printf "%s", $2; exit }' \
                          /etc/os-release)
        fi

        if [[ $OSRELEASE = *rolling ]]; then
          unset OSRELEASE
        fi
      elif [ -f /etc/arch-release ]; then
        OSDISTRO=Arch
      elif command -v pacman >/dev/null 2>&1; then
        OSDISTRO=Arch
      elif grep -q Ubuntu /proc/version; then
        OSDISTRO=Ubuntu
      elif grep -q Debian /proc/version; then
        OSDISTRO=Debian
      elif grep -qi centos /proc/version; then
        OSDISTRO=CentOS
      fi
      ;;
    FreeBSD)
      OSSHORT="$OSLONG"

      if command -v hostname >/dev/null 2>&1; then
        HOST="$(hostname -s)"
        HOSTNAME="$(hostname -f)"
      else
        HOST=localhost
        HOSTNAME="$HOST.localdomain"
      fi

      ARCH="$(uname -m)"
      OSRELEASE="$(uname -r)"
      ;;
    Darwin)
      OSLONG=macOs
      OSSHORT=OSX

      if command -v hostname >/dev/null 2>&1; then
        HOST="$(hostname -s)"
        HOSTNAME="$(hostname -f)"
      else
        HOST=localhost
        HOSTNAME="$HOST.localdomain"
      fi

      ARCH="$(uname -p)"
      case $ARCH in
        i386)
          ARCH=x86
          [ "$(uname -m)" = x86_64 ] && ARCH=x86_64
          ;;
        powerpc)
          ARCH=ppc32
          ;;
      esac

      local osx_version
      osx_version="$(sw_vers | grep ProductVersion | cut -f2)"
      OSRELEASE="${osx_version%.*}"

      case "$OSRELEASE" in
        10.4)
          OSCODENAME="Tiger"
          ;;
        10.5)
          OSCODENAME="Leopard"
          ;;
        10.6)
          OSCODENAME="Snow Leopard"
          ;;
        10.7)
          OSCODENAME="Lion"
          ;;
        10.8)
          OSCODENAME="Mountain Lion"
          ;;
        10.9)
          OSCODENAME="Mavericks"
          ;;
        10.10)
          OSCODENAME="Yosemite"
          ;;
        10.11)
          OSCODENAME="El Capitan"
          ;;
        10.12)
          OSCODENAME="Sierra"
          ;;
        10.13)
          OSCODENAME="High Sierra"
          ;;
        10.14)
          OSCODENAME="Mojave"
          ;;
        10.15)
          OSCODENAME="Catalina"
          ;;
        11.0)
          OSCODENAME="Big Sur"
          ;;
        *)
          OSCODENAME="Unknown"
          ;;
      esac

      OSRELEASE="$OSRELEASE ($OSCODENAME)"
      ;;
    *)
      OSSHORT=Unknown
      OSLONG="$OSSHORT"
      OSRELEASE="$OSSHORT"
      ARCH="$OSSHORT"
      HOST=localhost
      HOSTNAME="$HOST.localdomain"
      ;;
  esac

  UID="$(id -u)"
  GID="$(id -g)"

  if ! touch "$env_cache" >/dev/null 2>&1; then
    >&2 echo -n "bashenv: Unable to create cache file: "
    >&2 echo "\"$env_cache\".  Using \"/dev/null\" as a fallback."
    env_cache=/dev/null
  else
    chmod 600 "$env_cache"
  fi

  cat <<EOF > "$env_cache"
# This file was generated automatically by bashenv function.
#
# DO NOT EDIT THIS FILE BY HAND -- YOUR CHANGES WILL BE OVERWRITTEN.

export ARCH="$ARCH"

export UID="$UID"
export GID="$GID"

export HOST="$HOST"
export HOSTNAME="$HOSTNAME"

export OSLONG="$OSLONG"
export OSSHORT="$OSSHORT"
EOF

  if [ -n "$OSRELEASE" ]; then
    echo "export OSRELEASE=\"$OSRELEASE\"" >> "$env_cache"
  fi

  if [ "$OSSHORT" = Linux ]; then
    echo "export OSDISTRO=\"$OSDISTRO\"" >> "$env_cache"
  fi

  # We don't need lock file now
  rm -f "$cache_lock"

  export HOST HOSTNAME
  export OSLONG OSSHORT ARCH OSRELEASE
  export UID GID

  if [ "$OSSHORT" = Linux ]; then
    export OSDISTRO
  fi

  # Cleanup
  unset OSLONG_BACK OSSHORT_BACK OSDISTRO_BACK OSRELEASE_BACK
  unset ARCH_BACK HOST_BACK HOSTNAME_BACK UID_BACK GID_BACK
}

# Local Variables:
# mode: sh
# End:
