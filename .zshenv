# Zsh startup file.
#
# This file is sourced on all invocations of the shell, unless the
# `-f' option is set.
#   [.zshenv] -> .zprofile -> .zshrc -> .zlogin
#
# What goes in it:
#
# - Set up the command search path
# - Other important environment variables
# - Commands to set up aliases and functions that are needed for other
#   scripts
#
# What does NOT go in it:
#
# - Commands that produce output
# - Anything that assumes the shell is attached to a tty
#
# For more see 'man zsh(1)'.


# If a word begins with an unquoted '=' and the EQUALS option is
# set, the remainder of the word is taken as the name of a command.
#
#   $ (setopt equals; echo =make)
#   /usr/bin/make
#
#   $ (setopt noequals; echo =make)
#   =make
#
# For more see: man zshexpn(1)
setopt equals

# Allows '>' redirection to truncate existing files.
# For more see: man zshoptions(1)
setopt clobber

# This will enable a separated context for options in functions.
#
#   $ setopt localoptions
#   $ function t { setopt noequals; }
#   $ t
#   $ setopt | grep noequals | wc -l
#   0
#
#   $ setopt nolocaloptions
#   $ function t { setopt noequals; }
#   $ t
#   $ setopt | grep noequals | wc -l
#   1
#
# For more see: man zshoptions(1)
setopt local_options

# Resolve the path to the physical directory when changing to a
# directory containing a path segment '..'.
#
#   $ setopt no_chase_dots
#   $ mkdir -p /tmp/foo/bar && ln -s /tmp/foo /tmp/alt
#   $ cd /tmp/alt/bar/..
#   $ pwd
#   /tmp/alt
#
#   $ setopt chase_dots
#   $ mkdir -p /tmp/foo/bar && ln -s /tmp/foo /tmp/alt
#   $ cd /tmp/alt/bar/..
#   $ pwd
#   /tmp/foo
#
# For more see: man zshoptions(1)
setopt chase_dots

# Resolve symbolic links to their true values when changing
# directory.
#
#   $ setopt no_chase_links
#   $ mkdir -p /tmp/foo/bar && ln -s /tmp/foo /tmp/alt
#   $ cd /tmp/alt/bar
#   $ pwd
#   /tmp/alt/bar
#
#   $ setopt chase_links
#   $ mkdir -p /tmp/foo/bar && ln -s /tmp/foo /tmp/alt
#   $ cd /tmp/alt/bar
#   $ pwd
#   /tmp/foo/bar
#
# For more see: man zshoptions(1)
setopt no_chase_links

# Do not warn if there a glob with no matches.
#
#   $ setopt nomatch
#   $ ls *bar
#   zsh: no matches found: *bar
#
#   $ setopt no_nomatch
#   $ ls *bar
#   ls: cannot access '*bar': No such file or directory
#
# For more see: man zshoptions(1)
setopt no_nomatch

# Do not send the HUP signal to running jobs when the shell exits.
# For more see: man zshoptions(1).
setopt no_hup

# Split white space separated strings into arrays. The splitting
# is done by default, in most other shells but in zsh it should be
# disabled (by default).  In fact this is the only way for zsh to
# convert a list of words into an array.  I disable this by default
# an will enable in functions thanks to `local_optoins'.
#
#   $ touch a b c
#   $ files="a b c"
#   $ setopt sh_word_split
#   $ ls $files
#   a  b  c
#
#   $ touch a b c
#   $ files="a b c"
#   $ setopt no_sh_word_split
#   $ ls $files
#   ls: cannot access 'a b c': No such file or directory
#
# For more see: man zshoptions(1).
setopt no_sh_word_split

# Allow comments even in interactive shells.
# For more see: man zshoptions(1)
setopt interactive_comments

# Manipulating hook functions.
# This will provide ability to add and remove custom functions for
# builtin zsh hooks.
#
# For more see: man zshcontrib(1)
autoload -Uz add-zsh-hook

# Skip /etc/profile processing which calls path_helper
setopt no_global_rcs

# --------------------------------------------------------------------
# PATH
# --------------------------------------------------------------------

# No duplicate entries are needed.
typeset -U path

typeset -a places=(
  /sbin
  /usr/sbin
  /usr/local/sbin
  /opt/homebrew/sbin
  /bin
  /usr/bin
  /System/Cryptexes/App/usr/bin
  /usr/local/MacGPG2/bin
  /usr/local/bin
  /opt/homebrew/bin
)

for p in $places; do
  [ -d $p ] && path=($p $path)
done
unset p places

# PostgreSQL client
[ -d /opt/homebrew/opt/libpq/bin ] && path=(/opt/homebrew/opt/libpq/bin $path)

# brew install m4
if [ -d /opt/homebrew/opt/m4/bin ]; then
  path=(/opt/homebrew/opt/m4/bin $path)
fi

# Cabal
[ -d $HOME/.cabal/bin ] && path=($HOME/.cabal/bin $path)

# Cargo
[ -d $HOME/.cargo/bin ] && path=($HOME/.cargo/bin $path)

# Set up Rust source path for tools like racer if not already defined
# See https://github.com/racer-rust/racer#configuration
if (( ! ${+RUST_SRC_PATH} )) && (( $+commands[rustc] )); then
  local rust_sysroot="${$(rustc --print sysroot):A}"
  local rust_src_path="${rust_sysroot}/lib/rustlib/src/rust/library"

  if [[ -d $rust_src_path ]]; then
    export RUST_SRC_PATH=$rust_src_path
  fi
  unset rust_sysroot rust_src_path
fi

# Cask
[ -d $HOME/.cask/bin ] && path=($HOME/.cask/bin $path)

# Go lang local workspace
if [[ -d $HOME/go ]]; then
  export GOPATH=$HOME/go

  [[ -d $GOPATH/bin ]] && {
    # Put binary files created using "go install" command
    # in "$GOPATH/bin"
    export GOBIN=$GOPATH/bin
    path=($GOBIN $path)
  }
fi

# pyenv configuration
# Initialize PYENV_ROOT if not already set and .pyenv exists
if [[ -z $PYENV_ROOT && -d $HOME/.pyenv ]]; then
  export PYENV_ROOT=$HOME/.pyenv
fi

# Add pyenv bin directory to path if it exists
if [[ -n $PYENV_ROOT && -d $PYENV_ROOT/bin ]]; then
  path=($PYENV_ROOT/bin $path)
fi

# Initialize pyenv if available
if (( $+commands[pyenv] )); then
  eval "$(pyenv init -)"
fi

# Local binaries
[ -d $HOME/bin ] && path=($HOME/bin $path)
[ -d $HOME/.local/bin ] && path=($HOME/.local/bin $path)

export PATH

# --------------------------------------------------------------------
# MANPATHs
# --------------------------------------------------------------------

# Initialize MANPATH if not already set
if [[ -z ${MANPATH+x} ]] || [[ $MANPATH == ":" ]]; then
  if (( $+commands[manpath] )); then
    # Get the original manpath, then modify it
    MANPATH="$(manpath 2>/dev/null)"
  else
    MANPATH=()
  fi
fi

# Define standard man page directories
typeset -a manpath_dirs=(
  /Library/Apple/usr/share/man
  /usr/man
  /usr/share/man
  /usr/local/man
  /opt/homebrew/man
  /opt/homebrew/manpages
  /opt/homebrew/opt/readline/share/man
  /usr/local/share/man
  /opt/homebrew/share/man
  /opt/man
  $HOME/man
  $HOME/share/man
  $HOME/.local/share/man
)

# Add existing directories to manpath
for dir in $manpath_dirs; do
  [[ -d $dir ]] && manpath=($dir $manpath)
done
unset dir manpath_dirs

# Add Rust man pages if RUST_SYSROOT is set and directory exists
if (( ${+RUST_SYSROOT} )) && [[ -d "$RUST_SYSROOT/share/man" ]]; then
  manpath=($RUST_SYSROOT/share/man $manpath)
fi

# Load OS-specific man page configurations
[[ -r $ZSHDDIR/conf.d/OS/$OSSHORT/mans ]] && source $ZSHDDIR/conf.d/OS/$OSSHORT/mans

# Remove duplicate entries and export
typeset -U manpath
export MANPATH

# --------------------------------------------------------------------
# Setup INFOPATHs
# --------------------------------------------------------------------

# Initialize INFOPATH if not already set
if [[ -z ${INFOPATH+x} ]] || [[ $INFOPATH == ":" ]]; then
  INFOPATH=""
fi

# Define standard info directories
typeset -a infopath_dirs=(
  /opt/homebrew/share/info
  /opt/homebrew/opt/readline/share/info
  /Applications/Emacs.app/Contents/Resources/info
)

# Add existing directories to infopath (macOS specific)
if [[ $OSTYPE == darwin* ]]; then
  for dir in $infopath_dirs; do
    [[ -d $dir ]] && infopath=($dir $infopath)
  done
fi
unset dir infopath_dirs

# Remove duplicate entries and export
typeset -U infopath
export INFOPATH

# --------------------------------------------------------------------
# Setup Locales
# --------------------------------------------------------------------

# See: https://stackoverflow.com/q/7165108/1661465
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# --------------------------------------------------------------------
# Setup GnuPG
# --------------------------------------------------------------------

# Set GnuPG home directory if not already defined
: ${GNUPGHOME:=$HOME/.gnupg}
export GNUPGHOME

# Setup GPG agent
if (( $+commands[gpgconf] )); then
  # Start gpg-agent if not running or socket is missing
  if (( $+commands[gpg-agent] )); then
    if ! pgrep -x gpg-agent >/dev/null ||
       [[ ! -S "$(gpgconf --list-dirs agent-socket)" ]]; then
      gpg-agent --homedir "$GNUPGHOME" --daemon --use-standard-socket >/dev/null 2>&1
    fi
  fi

  # Let gpgconf handle the environment setup
  if [[ -o interactive ]]; then
    gpgconf --launch gpg-agent >/dev/null 2>&1
  fi
fi

# Set GPG TTY for pinentry
: ${GPG_TTY:=$(tty 2>/dev/null)}
export GPG_TTY

# Ensure GPG passphrase prompt appears on the correct TTY
# Reference: https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html#option-_002d_002denable_002dssh_002dsupport
_gpg_update_tty() {
  # Update the GPG agent with the current TTY for proper passphrase prompting
  [[ -n "$GPG_TTY" ]] && gpg-connect-agent UPDATESTARTUPTTY /bye >/dev/null 2>&1
}

# Register the function to run before each command execution
add-zsh-hook preexec _gpg_update_tty

# Determine which GPG binary to use
if (( $+commands[gpg2] )); then
  export GPG=gpg2
elif (( $+commands[gpg] )); then
  export GPG=gpg
fi

# --------------------------------------------------------------------
# Setup SSH
# --------------------------------------------------------------------

# Setup SSH agent if not already running
if [[ -z "$SSH_AUTH_SOCK" ]]; then
  # Define socket path
  typeset ssh_socket="$HOME/.cache/ssh-agent.sock"

  # Check if ssh-agent is running for current user
  if ! pgrep -u "$USER" ssh-agent >/dev/null; then
    # Remove stale socket if it exists
    [[ -e "$ssh_socket" ]] && rm -f "$ssh_socket"

    # Start new ssh-agent with custom socket path
    eval "$(ssh-agent -a "$ssh_socket" -s)"
  else
    # Agent is running, set environment variables
    SSH_AGENT_PID=$(pgrep -u "$USER" ssh-agent)
    SSH_AUTH_SOCK="$ssh_socket"
    export SSH_AGENT_PID SSH_AUTH_SOCK
  fi

  unset ssh_socket
elif (( $+commands[ssh-agent] )); then
  export SSH_AGENT_PID=$(pgrep -u "$USER" ssh-agent)
fi

# Add keys if agent has no identities loaded
if [[ -n "$SSH_AUTH_SOCK" ]] && ! ssh-add -l &>/dev/null; then
  ssh-add -q
fi

# --------------------------------------------------------------------
# Setup hostname
# --------------------------------------------------------------------

# Set default hostname values
typeset -g HOST=localhost
typeset -g HOSTNAME="${HOST}.localdomain"

# Get system hostname if available
if (( $+commands[hostname] )) && [[ "$OSTYPE" =~ ^(linux|freebsd|darwin) ]]; then
  # Get full hostname
  HOSTNAME="$(hostname)"
  # Extract short hostname (everything before the first dot)
  HOST="${HOSTNAME%%.*}"
fi

# Export variables for use in other scripts
export HOST HOSTNAME

# --------------------------------------------------------------------

export ZSH_ENV_SOURCED=1
