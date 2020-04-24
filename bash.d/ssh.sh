# Setup ssh-agent

# Path to ssh-agent config.
SSH_ENV="$HOME/.ssh/env"

function ssh/start-agent () {
  if command -v ssh-agent >/dev/null 2>&1; then
    ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    # To add ECDSA keys see https://stackoverflow.com/a/45370592/1661465
    grep -slR "PRIVATE" "$HOME/.ssh/" | xargs ssh-add >/dev/null 2>&1
  fi
}

# Source SSH settings, if applicable
if [ -n "$SSH_ENV" ] && [ -f "$SSH_ENV" ]; then
  . "${SSH_ENV}" > /dev/null
  ps -p "${SSH_AGENT_PID}" > /dev/null || {
    ssh/start-agent
  }
else
  ssh/start-agent
fi

if [ -n "$INSIDE_EMACS" ] && [ -n "$SSH_AUTH_SOCK" ] && [ -n "$SSH_AGENT_PID" ]
then
  type -t esetenv > /dev/null 2>&1 && \
  esetenv SSH_AUTH_SOCK SSH_AGENT_PID
fi

# Local Variables:
# mode: sh
# flycheck-shellcheck-excluded-warnings: ("SC1090")
# flycheck-disabled-checkers: (sh-posix-dash sh-shellcheck)
# End:
