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

# User wide environment and startup programs, for login setup.
#
# This file is sourced by the first for login shells.

# shellcheck shell=bash

# The base directories for all startup/shutdown files
BASHD_HOME="${BASHD_HOME:-${HOME}}"
BASHD_ROOT="${XDG_CONFIG_HOME:-${BASHD_HOME}/.config}/bash.d"

# shellcheck source=./.config/bash.d/conf.d/fun.sh
[[ -f $BASHD_ROOT/conf.d/fun.sh ]] && . "$BASHD_ROOT/conf.d/fun.sh"

# Setup platform independed environment variables.  This function
# WILL NOT change previously set veriables (if any).
autoload bashenv
bashenv

# OS specific environment
# shellcheck disable=SC1090
[[ -f $BASHD_ROOT/conf.d/OS/$OSSHORT/env.sh ]] && . "$BASHD_ROOT/conf.d/OS/$OSSHORT/env.sh"

# Setting up PATHs
# shellcheck source=./.config/bash.d/conf.d/paths.sh
[[ -f $BASHD_ROOT/conf.d/paths.sh ]] && . "$BASHD_ROOT/conf.d/paths.sh"

# Setting up MAN's paths
# shellcheck source=./.config/bash.d/conf.d/mans.sh
[[ -f $BASHD_ROOT/conf.d/mans.sh ]] && . "$BASHD_ROOT/conf.d/mans.sh"

# shellcheck source=./.config/bash.d/conf.d/editor.sh
[[ -f $BASHD_ROOT/conf.d/editor.sh ]] && . "$BASHD_ROOT/conf.d/editor.sh"

# GnuPG configuration
# shellcheck source=./.config/bash.d/conf.d/gpg.sh
[[ -f $BASHD_ROOT/conf.d/gpg.sh ]] && . "$BASHD_ROOT/conf.d/gpg.sh"

# Include '.bashrc' if it exists
# shellcheck source=./.bashrc
[ -f ~/.bashrc ] && . ~/.bashrc

# Local Variables:
# mode: sh
# End:
