#!/bin/zsh

#
# zsh startup file
#

# Common PATH setup
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# OpenSSL
if [ -d "/usr/local/opt/openssl/bin" ]; then
    PATH="/usr/local/opt/openssl/bin:$PATH"
fi

# SQLite
if [ -d "/usr/local/opt/sqlite/bin" ]; then
    PATH="/usr/local/opt/sqlite/bin:$PATH"
fi

# Homebrew and etc
if [ -d "/opt/local/bin" ]; then
    PATH="/opt/local/bin:$PATH"
fi

if [ -d "/opt/local/sbin" ]; then
    PATH="/opt/local/sbin:$PATH"
fi

# SSH
export SSH_KEY_PATH="$HOME/.ssh/dsa_id"

# Composer
if [ -d "$HOME/.composer" ]; then
    export COMPOSER_HOME="$HOME/.composer"
    if [ -d "$HOME/.composer/vendor/bin" ]; then
        PATH+=:$HOME/.composer/vendor/bin
    fi
fi

# Zephir
export ZEPHIRDIR=$HOME/Projects/c/zephir
export PATH="$ZEPHIRDIR/bin:$PATH"

# Haskel
export PATH="$HOME/Library/Haskell/bin:$PATH"

# Home PATHs
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Prefered editor
export EDITOR="/usr/local/bin/emacsclient -c"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Locale setup
# export LANG=en_US.UTF-8

export MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"

# Rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
