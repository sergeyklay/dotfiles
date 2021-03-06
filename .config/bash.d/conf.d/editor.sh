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

# This file contains the definition of the editor.

# shellcheck shell=bash

# Editor to fallback to if the server is not running.  If this
# variable is empty, then start GNU Emacs in daemon mode and try
# connecting again.
ALTERNATE_EDITOR=''
export ALTERNATE_EDITOR

# See:
# https://github.com/sergeyklay/.emacs.d/blob/master/bin/emacsclient.wrapper
if command -v emacsclient.wrapper >/dev/null 2>&1 ; then
  EDITOR=emacsclient.wrapper
else
  EDITOR='emacs -nw'
fi
export EDITOR

VISUAL="$EDITOR"
export VISUAL

# Setting alias for emacsclient.  See '.bash_profile' for more.
# shellcheck disable=SC2139
alias ec="$EDITOR"

# More for less
PAGER=less
export PAGER

# -X will leave the text in your Terminal, so it doesn't disappear
#    when you exit less.
# -F will exit less if the output fits on one screen (so you don't
#    have to press "q").
# -R ANSI "color" escape sequences are output in "raw" form.
#
# See: https://unix.stackexchange.com/q/38634/50400
LESS="-X -F -R"
LESSCHARSET=UTF-8
LESSHISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/lesshst"
export LESS LESSCHARSET LESSHISTFILE

# OS specific settings for editor, pager, and so on.
if [ -r "$BASHD_ROOT/conf.d/OS/$OSSHORT/editor.sh" ]; then
  # shellcheck disable=SC1090
  . "$BASHD_ROOT/conf.d/OS/$OSSHORT/editor.sh"
fi

# Local Variables:
# mode: sh
# End:
