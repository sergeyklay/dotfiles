#!/usr/bin/env zsh

# Zsh startup file.
#
# This file is sourced on all interactive shells.
#   .zshenv -> .zprofile -> .zshrc -> .zlogin
#
# Used for setting user's interactive shell configuration and
# executing commands, will be read when starting as an interactive
# shell.
#
# For $OSSHORT, $ZSHDDIR and other variables see .zshenv.

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# OS specific configuration.
# This comes first as it tends to mess up things.
if [ -r $ZSHDDIR/conf.d/OS/$OSSHORT/zshrc ]; then
  source $ZSHDDIR/conf.d/OS/$OSSHORT/zshrc
fi

configs=(
  history        # Setting up history
  aliases        # The Common aliases
  prompt         # The definition of the prompts
)

for c in "$configs[@]" ;  do
  [ -r $ZSHDDIR/conf.d/$c ] && source $ZSHDDIR/conf.d/$c
done

# kubectl completion
[ ! -z "$(command -v kubectl 2>/dev/null || true)" ] && {
  source <(kubectl completion zsh | sed s/kubectl/k/g)
}

# The next line updates PATH for the Google Cloud SDK.
[ -f "$HOME/gcp/path.zsh.inc" ] && source "$HOME/gcp/path.zsh.inc"

# The next line enables shell command completion for gcloud.
[ -f "$HOME/gcp/completion.zsh.inc" ] && {
  source "$HOME/gcp/completion.zsh.inc"
}

# Local Variables:
# mode: sh
# End:
