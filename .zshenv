#!/bin/zsh

#
# Zsh startup file
#

# Common PATH setup
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Rust & Cargo
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# Prefered editor
export EDITOR="vim"

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# Locale setup
export LANG=en_US.UTF-8

# SSH
SSH_KEY_TYPE=${SSH_KEY_TYPE:-ed25519}
SSH_KEY_PATH=$HOME/.ssh/id_$SSH_KEY_TYPE

#  vim:ft=zsh:ts=4:sw=4:tw=78:fenc=utf-8:et
