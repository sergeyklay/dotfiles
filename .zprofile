#!/usr/bin/env zsh

# rbenv
if [ -d "$HOME/.rbenv/bin" ]
then
  path+=("$HOME/.rbenv/bin")
  # Load rbenv
  eval "$(rbenv init -)"

  # Vim setup
  RUBY_BIN=$(rbenv which ruby 2> /dev/null || true | sed 's/ruby$//')
  [ x"$RUBY_BIN" != x ] && export RUBY_BIN
fi

# php-build
PHP_BUILD_EXTRA_MAKE_ARGUMENTS=-j"$(getconf _NPROCESSORS_ONLN)"

[ -d "$HOME/src" ] && {
  [ -d "$HOME/src/php" ] || mkdir -p "$HOME/src/php"
  export PHP_BUILD_TMPDIR="$HOME/src/php"
}

# phpenv
if [ -d "$HOME/.phpenv" ]
then
  export PHPENV_ROOT="$HOME/.phpenv"
  path+=("$PHPENV_ROOT/bin")
  # Load phpenv
  eval "$(phpenv init -)"

  [ -d "$PHPENV_ROOT/plugins/php-build/bin" ] && {
    path+=("$PHPENV_ROOT/plugins/php-build/bin")
  }
fi

# Use Python 3 by default
[ -f "$HOME/.virtualenvs/python-3/bin/activate" ] && {
  # source "$HOME/.virtualenvs/python-3/bin/activate"
}

# vim:ft=zsh:ts=2:sw=2:sts=2:tw=78:fenc=utf-8:et
