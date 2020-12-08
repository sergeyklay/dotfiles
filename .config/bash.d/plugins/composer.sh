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

_plugin_composer() {
  # Note: ~ is only expanded by the shell if it's unquoted.
  # When it's quoted it's a literal tilde symbol.
  if [ -d "${XDG_CONFIG_HOME:-$HOME/.config}/composer" ]; then
    COMPOSER_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/composer"
    COMPOSER_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/composer"
    export COMPOSER_HOME COMPOSER_CACHE_DIR

    if [ -d "$COMPOSER_HOME/vendor/bin" ]; then
      pathmunge "$COMPOSER_HOME/vendor/bin"
    fi
  fi
}

# Local Variables:
# mode: sh
# End:
