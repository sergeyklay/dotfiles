#!/usr/bin/env zsh

# rbenv
[ -d "$HOME/.rbenv/bin" ] && {
  path+=("$HOME/.rbenv/bin")
  # Load rbenv
  eval "$(rbenv init -)"

  # Vim setup
  RUBY_BIN=$(rbenv which ruby 2> /dev/null || true | sed 's/ruby$//')
  [ ! -z "$RUBY_BIN" ] && export RUBY_BIN
}

# php-build
PHP_BUILD_EXTRA_MAKE_ARGUMENTS=-j"$(getconf _NPROCESSORS_ONLN)"

[ -d "$HOME/src" ] && {
  [ -d "$HOME/src/php" ] || mkdir -p "$HOME/src/php"
  export PHP_BUILD_TMPDIR="$HOME/src/php"
}

# phpenv
[ -d "$HOME/.phpenv" ] && {
  export PHPENV_ROOT="$HOME/.phpenv"
  path+=("$PHPENV_ROOT/bin")
  # Load phpenv
  eval "$(phpenv init -)"

  [ -d "$PHPENV_ROOT/plugins/php-build/bin" ] && {
    path+=("$PHPENV_ROOT/plugins/php-build/bin")
  }
}

# virtualenv
[ -z "$VIRTUAL_ENV" ] && {
  # Use Python 3.7 by default
  [ -f "$HOME/.venv/python3.7/bin/activate" ] && {
    source "$HOME/.venv/python3.7/bin/activate"
  }
}

# vim:ft=zsh:ts=2:sw=2:sts=2:tw=78:fenc=utf-8:et
