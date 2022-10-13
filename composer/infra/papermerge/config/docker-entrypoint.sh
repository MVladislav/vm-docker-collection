#!/bin/bash
set -eo pipefail
shopt -s nullglob

# logging functions
docker_log() {
  local type="$1"
  shift
  # accept argument string or stdin
  local text="$*"
  if [ "$#" -eq 0 ]; then text="$(cat)"; fi
  local dt
  dt="$(date --rfc-3339=seconds)"
  printf '%s [%s] [Entrypoint]: %s\n' "$dt" "$type" "$text"
}

docker_note() {
  docker_log Note "$@"
}
docker_warn() {
  docker_log Warn "$@" >&2
}
docker_error() {
  docker_log ERROR "$@" >&2
  exit 1
}

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
  local var="$1"
  local fileVar="${var}_FILE"
  local def="${2:-}"
  if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
    docker_error "Both $var and $fileVar are set (but are exclusive)"
  fi
  local val="$def"
  if [ "${!var:-}" ]; then
    val="${!var}"
  elif [ "${!fileVar:-}" ]; then
    val="$(<"${!fileVar}")"
  fi
  export "$var"="$val"
  unset "$fileVar"
}

file_env 'PAPERMERGE__MAIN__SECRET_KEY'
file_env 'PAPERMERGE__DATABASE__PASSWORD'
file_env 'DJANGO_SUPERUSER_PASSWORD'

file_env 'PAPERMERGE_SECRET_KEY'
file_env 'PAPERMERGE_DATABASE_PASSWORD'

exec /run.bash "$@"

exit 0
