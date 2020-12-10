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

autoload pathmunge

_plugin_sdkman() {
  if [ -z ${SDKMAN_DIR+x} ]; then
    if [ -d ~/.sdkman ]; then
      SDKMAN_DIR="$HOME/.sdkman"
      export SDKMAN_DIR
    fi
  else
    if [[ ! -d $SDKMAN_DIR ]]; then
      unset SDKMAN_DIR
    fi
  fi

  if [ -n "$SDKMAN_DIR" ]; then
    if [[ -f $SDKMAN_DIR/bin/sdkman-init.sh ]]; then
      # shellcheck disable=SC1090
      . "$SDKMAN_DIR/bin/sdkman-init.sh"
    else
      >&2 echo -n "The file $SDKMAN_DIR/bin/sdkman-init.sh does "
      >&2 echo "not exist. Did you install sdkman?"
      return 1
    fi
  else
    >&2 echo -n "The directory ~/.sdkman does not exist. "
    >&2 echo -n "Try to (re) install sdkman and (or) create "
    >&2 echo "$HOME/.sdkman directory."
    return 1
  fi
}

# Local Variables:
# mode: sh
# End:
