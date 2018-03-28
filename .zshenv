#!/bin/zsh

#
# Zsh startup file
#

# Common PATH setup
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# OpenSSL
if [ -d "/usr/local/opt/openssl/bin" ]; then
    export PATH="/usr/local/opt/openssl/bin:$PATH"
fi

# SQLite
if [ -d "/usr/local/opt/sqlite/bin" ]; then
    export PATH="/usr/local/opt/sqlite/bin:$PATH"
fi

# Homebrew and etc
if [ -d "/opt/local/bin" ]; then
    export PATH="/opt/local/bin:$PATH"
fi

if [ -d "/opt/local/sbin" ]; then
    export PATH="/opt/local/sbin:$PATH"
fi

if [ -d "/usr/local/sbin" ]; then
    export PATH="/usr/local/sbin:$PATH"
fi

if [ -d "/usr/local/opt/imagemagick@6/bin" ]; then
    export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
fi

# Rust & Cargo
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# Haskell
if [ -d "$HOME/Library/Haskell/bin" ]; then
    export PATH="$HOME/Library/Haskell/bin:$PATH"
fi

# PHP
if [ -d "$(brew --prefix php)/bin" ]; then
    export PATH="$(brew --prefix php)/bin:$PATH"
fi

# Home bin
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d "/usr/local/opt/imagemagick@6/bin" ]; then
    export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
fi

# Prefered editor
export EDITOR="vim"

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# Locale setup
export LANG=en_US.UTF-8

# Setting up the man pages
if [ -d "/usr/local/opt/gnu-tar/libexec/gnuman" ]; then
    export MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"
fi

# SSH
SSH_KEY_TYPE=${SSH_KEY_TYPE:-ed25519}
SSH_KEY_PATH=$HOME/.ssh/id_$SSH_KEY_TYPE

# Rbenv
if [ -d "$HOME/.rbenv" ]; then
    eval "$(rbenv init -)"
fi

#  vim:ft=zsh:ts=4:sw=4:tw=78:fenc=utf-8:et
