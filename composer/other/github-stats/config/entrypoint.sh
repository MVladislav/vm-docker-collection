#!/usr/bin/env bash
set -euo pipefail

# If a secret path is provided (via docker-compose as env var), read it.
# Expect path like /run/secrets/token_secret
if [ -n "${GITHUB_TOKEN_FILE:-}" ] && [ -f "${GITHUB_TOKEN_FILE}" ]; then
  # trim whitespace/newlines
  secret=$(tr -d '\r\n' < "${GITHUB_TOKEN_FILE}")
  export TOKEN="$secret"
  export PAT_1="$secret"
  export GITHUB_TOKEN1="$secret"
fi

# Useful defaults (ensure services bind properly)
export PORT_STATS=${PORT_STATS:-3001}
export PORT_TROPHY=${PORT_TROPHY:-3002}
export NODE_ENV=${NODE_ENV:-production}

# exec supervisord as PID 1 so signals flow correctly
exec "$@"
