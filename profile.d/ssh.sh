# Setup ssh-agent

export SSH_ENV=~/.ssh/env

function ssh/start-agent () {
  if command -v ssh-agent >/dev/null 2>&1; then
    ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    # To add ECDSA keys see https://stackoverflow.com/a/45370592/1661465
    grep -slR "PRIVATE" ~/.ssh/ | xargs ssh-add >/dev/null 2>&1
  fi
}

# Local Variables:
# mode: sh
# End:
