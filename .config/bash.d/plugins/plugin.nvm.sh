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

# See: https://github.com/nvm-sh/nvm
_plugin_nvm() {
  if [[ -d ~/.nvm ]]; then
    NVM_DIR="$HOME/.nvm"
    export NVM_DIR

    if [[ -s $NVM_DIR/nvm.sh ]]; then
        # This loads nvm
        . "$NVM_DIR/nvm.sh"

        # This loads nvm bash_completion
        . "$NVM_DIR/bash_completion"
    fi
  fi
}

# Local Variables:
# mode: sh
# End:
