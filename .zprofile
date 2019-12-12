#!/usr/bin/env zsh

# Add .NET Core SDK tools
export DOTNET_CLI_TELEMETRY_OPTOUT=1
[ -d "$HOME/.dotnet/tools" ] && {
  path+=("$HOME/.dotnet/tools")
}

# rbenv
if [ -d "$HOME/.rbenv/bin" ] || [ ! -z "$(command -v rbenv 2>/dev/null)" ]
then
  [ -d "$HOME/.rbenv/bin" ] && path+=("$HOME/.rbenv/bin")

  # Load rbenv
  eval "$(rbenv init -)"

  # Vim setup
  RUBY_BIN=$(rbenv which ruby 2> /dev/null || true | sed 's/ruby$//')
  [ ! -z "$RUBY_BIN" ] && export RUBY_BIN
fi

# php-build
export PHP_BUILD_EXTRA_MAKE_ARGUMENTS=-j"$(getconf _NPROCESSORS_ONLN)"

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
  # Use local Python by default
  [ -f "$HOME/.venv/local/bin/activate" ] && {
    source "$HOME/.venv/local/bin/activate"
    path+=("$HOME/.venv/local/bin")
  }
}

# https://gnunn1.github.io/tilix-web/manual/vteconfig
if [ $TILIX_ID ] || [ $VTE_VERSION ]
then
  if [ -f /etc/profile.d/vte-2.91.sh ]
  then
    source /etc/profile.d/vte-2.91.sh
  elif [ -f /etc/profile.d/vte.sh ]
  then
    source /etc/profile.d/vte.sh
  fi
fi

# vim:ft=zsh:ts=2:sw=2:sts=2:tw=78:fenc=utf-8:et
