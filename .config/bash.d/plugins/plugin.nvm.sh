# Copyright (C) 2014-2021 Serghei Iakovlev <egrep@protonmail.ch>
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

# Node Version Manager configuration plugin.
#
# Links:
# * https://github.com/nvm-sh/nvm

autoload pathmunge
autoload warn

# Meant for non-interactive login shells.
_plugin_nvm_login() {
  for dir in "$HOME/.nvm" "${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
  do
    if [[ -d $dir ]]; then
      NVM_DIR="$dir"
      export NVM_DIR
      if [[ -s $NVM_DIR/nvm.sh ]]; then
        # This loads nvm
        . "$NVM_DIR/nvm.sh"
      fi
    fi
  done
}

# Meant for interactive shells.
_plugin_nvm() {
  if [ -z ${NVM_DIR+x} ] || ! command -v nvm >/dev/null 2>&1
  then
    warn "nvm plugin is not configured"
    return 1
  fi

  if [[ -s $NVM_DIR/bash_completion ]]; then
      # This loads nvm bash_completion
      . "$NVM_DIR/bash_completion"
  fi
}

# Local Variables:
# mode: shell-script
# End:
