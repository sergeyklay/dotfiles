#!/bin/zsh

#
# Zsh profile
#
# .zprofile is basically the same as .zlogin except that it's sourced
# directly before .zshrc is sourced instead of directly after it.
#

# OpenSSL
if [ -d "/usr/local/opt/openssl/bin" ]; then
    export PATH="/usr/local/opt/openssl/bin:$PATH"
fi

# SQLite
if [ -d "/usr/local/opt/sqlite/bin" ]; then
    export PATH="/usr/local/opt/sqlite/bin:$PATH"
fi

# Homebrew, etc
if [ -d "/opt/local/bin" ]; then
    export PATH="/opt/local/bin:$PATH"
fi

if [ -d "/opt/local/sbin" ]; then
    export PATH="/opt/local/sbin:$PATH"
fi

# Local binaries
if [ -d "/usr/local/sbin" ]; then
    export PATH="/usr/local/sbin:$PATH"
fi

if [ -d "/usr/local/opt/imagemagick@6/bin" ]; then
    export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
fi

# Rust & Cargo
if [ -f "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
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

# Setting up the man pages
if [ -d "/usr/local/opt/gnu-tar/libexec/gnuman" ]; then
    export MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"
fi

# Rbenv
if [ -d "$HOME/.rbenv" ]; then
    eval "$(rbenv init -)"
elif [ -f /usr/local/bin/rbenv ]; then
    eval "$(/usr/local/bin/rbenv init -)"
fi

#  vim:ft=zsh:ts=4:sw=4:tw=78:fenc=utf-8:et
