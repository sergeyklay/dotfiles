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

# The next line enables shell command completion for gcloud.
# shellcheck disable=SC1090
[ -r ~/gcp/completion.bash.inc ] && . ~/gcp/completion.bash.inc

# Use bash-completion, if available.
# For more see: https://github.com/scop/bash-completion
if [ -r /usr/local/etc/profile.d/bash_completion.sh ]; then
  # shellcheck disable=SC1091
  . /usr/local/etc/profile.d/bash_completion.sh
elif [ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]; then
  # shellcheck disable=SC1091
  . /opt/homebrew/etc/profile.d/bash_completion.sh
fi

# Local Variables:
# mode: sh
# End:
