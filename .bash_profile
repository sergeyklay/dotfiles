# use ~/.bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# load RVM into a shell session *as a function*
[[ -s ~/.rvm/scripts/rvm ]] && . ~/.rvm/scripts/rvm

# add RVM comletion
[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion

# vim:filetype=sh:ts=8:sw=2:sts=2:tw=80:et
