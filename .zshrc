export ZSH=/Users/sergheiiakovlev/.oh-my-zsh

ZSH_THEME="powerlevel9k/powerlevel9k"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rbenv vcs)
POWERLEVEL9K_DIR_HOME_BACKGROUND='014'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='014'
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='014'

plugins=(
  git
  git-extras
  osx
  bundler
  gem
  rake
  ruby
  docker
  vagrant
  cask
  cabal
  brew
)

source $ZSH/oh-my-zsh.sh
source $HOME/.zshenv

alias dps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'"
