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

[ -r "$BASHD_ROOT/conf.d/fun.sh" ] && . "$BASHD_ROOT/conf.d/fun.sh"
[ -r "$BASHD_ROOT/conf.d/editor.sh" ] && . "$BASHD_ROOT/conf.d/editor.sh"

# Setup platform independed environment variables.  This function
# WILL NOT change previously set veriables (if any).
bashenv

# OS specific environment
if [ -r "$BASHD_ROOT/conf.d/OS/$OSSHORT/env.sh" ]; then
  . "$BASHD_ROOT/conf.d/OS/$OSSHORT/env.sh"
fi

# Configure virtualenv
if [ -r "$BASHD_ROOT/conf.d/venv.sh" ]; then
  # shellcheck source=./.config/bash.d/conf.d/venv.sh
  . "$BASHD_ROOT/conf.d/venv.sh"
fi

# Setting up PATHs
if [ -r "$BASHD_ROOT/conf.d/paths.sh" ]; then
  . "$BASHD_ROOT/conf.d/paths.sh"
fi

# Setting up MAN's paths
if [ -r "$BASHD_ROOT/conf.d/mans.sh" ]; then
  . "$BASHD_ROOT/conf.d/mans.sh"
fi

# GnuPG configuration
[ -r "$BASHD_ROOT/conf.d/gpg.sh" ] && . "$BASHD_ROOT/conf.d/gpg.sh"

# Include '.bashrc' if it exists
if [ -r ~/.bashrc ]; then
  # shellcheck source=./.bashrc
  . ~/.bashrc
fi

# Local Variables:
# mode: sh
# End:
