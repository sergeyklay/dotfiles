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

# XDG Base Directory Configuration

# shellcheck shell=bash

# https://bugzilla.redhat.com/show_bug.cgi?id=755553
BROWSER="firefox:elinks"
export BROWSER

# User-specific configuration files.
if [ -z "$XDG_CONFIG_HOME" ]; then
  XDG_CONFIG_HOME="$HOME/.config"
  export XDG_CONFIG_HOME
fi

# Configuration files should be searched relative to this directory.
if [ -z "$XDG_CONFIG_DIRS" ]; then
  XDG_CONFIG_DIRS=/etc/xdg
  export XDG_CONFIG_DIRS
fi

# User-specific cached data should be written relative to this
# directory.
if [ -z "$XDG_CACHE_HOME" ]; then
  XDG_CACHE_HOME="$HOME/.cache"
  export XDG_CACHE_HOME
fi

# User-specific data files.
if [ -z "$XDG_DATA_HOME" ]; then
  XDG_DATA_HOME="$HOME/.local/share"
  export XDG_DATA_HOME
fi

# User-specific runtime files should be placed relative to this
# directory.
if [ -z "$XDG_RUNTIME_DIR" ]; then
  if [ -d /run/user ]; then
    XDG_RUNTIME_DIR="/run/user/$(id -u)"
    export XDG_RUNTIME_DIR
  fi
fi

# See: https://stackoverflow.com/a/27965014/1661465
if [ -z "$XDG_STATE_HOME" ]; then
  XDG_STATE_HOME="$HOME/.local/state"
  export XDG_STATE_HOME
fi

[ ! -d "$XDG_STATE_HOME" ] && mkdir -p "$XDG_STATE_HOME"

# Base directories relative to which data files should be searched
if [ -n "$XDG_DATA_DIRS" ]; then
  # Trim leading slashes to avoid array like
  #     (/foo/bar /foo/bar/)
  XDG_DATA_DIRS="${XDG_DATA_DIRS//\/:/:}"
  XDG_DATA_DIRS="${XDG_DATA_DIRS%/}"
else
  XDG_DATA_DIRS="/usr/local/share:/usr/share"
fi

if command -v flatpak >/dev/null 2>&1; then
  if [ -d /var/lib/flatpak/exports/share ]; then
    XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"
  fi

  if [ -d "$XDG_DATA_HOME/flatpak/exports/share" ]; then
    XDG_DATA_DIRS="$XDG_DATA_HOME/flatpak/exports/share:$XDG_DATA_DIRS"
  fi
fi

export XDG_DATA_DIRS

if test -r "$XDG_CONFIG_HOME/user-dirs.dirs"
then
  # shellcheck disable=SC1090
  . "$XDG_CONFIG_HOME/user-dirs.dirs"

  test -n "$XDG_DESKTOP_DIR" && export XDG_DESKTOP_DIR
  test -n "$XDG_DOCUMENTS_DIR" && export XDG_DOCUMENTS_DIR
  test -n "$XDG_DOWNLOAD_DIR" && export XDG_DOWNLOAD_DIR
  test -n "$XDG_MUSIC_DIR" && export XDG_MUSIC_DIR
  test -n "$XDG_PICTURES_DIR" && export XDG_PICTURES_DIR
  test -n "$XDG_PUBLICSHARE_DIR" && export XDG_PUBLICSHARE_DIR
  test -n "$XDG_VIDEOS_DIR" && export XDG_VIDEOS_DIR
fi

# Local Variables:
# mode: sh
# End:
