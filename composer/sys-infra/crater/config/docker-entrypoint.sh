#!/bin/bash
set -eo pipefail
shopt -s nullglob

echo "update owner into '$uid:$uid' for '/var/www'"
chown -R $uid:$uid /var/www

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

file_env 'APP_KEY'
file_env 'DB_PASSWORD'
file_env 'REDIS_PASSWORD'
file_env 'MAIL_PASSWORD'

{
  echo "APP_ENV=${APP_ENV:-production}"
  echo "APP_KEY=${APP_KEY}"
  echo "APP_DEBUG=${APP_DEBUG:-true}"
  echo "APP_LOG_LEVEL=${APP_LOG_LEVEL:-debug}"
  echo "APP_URL=${APP_URL}"

  echo "DB_CONNECTION=${DB_CONNECTION:-mysql}"
  echo "DB_HOST=${DB_HOST:-db}"
  echo "DB_PORT=${DB_PORT:-3306}"
  echo "DB_DATABASE=${DB_DATABASE:-crater}"
  echo "DB_USERNAME=${DB_USERNAME:-crater}"
  echo "DB_PASSWORD=${DB_PASSWORD:-crater}"

  echo "BROADCAST_DRIVER=${BROADCAST_DRIVER:-log}"
  echo "CACHE_DRIVER=${CACHE_DRIVER:-file}"
  echo "QUEUE_DRIVER=${QUEUE_DRIVER:-sync}"
  echo "SESSION_DRIVER=${SESSION_DRIVER:-cookie}"
  echo "SESSION_LIFETIME=${SESSION_LIFETIME:-1440}"

  echo "REDIS_HOST=${REDIS_HOST:-127.0.0.1}"
  echo "REDIS_PASSWORD=${REDIS_PASSWORD:-null}"
  echo "REDIS_PORT=${REDIS_PORT:-6379}"

  echo "MAIL_DRIVER=${MAIL_DRIVER:-smtp}"
  echo "MAIL_HOST=${MAIL_HOST}"
  echo "MAIL_PORT=${MAIL_PORT}"
  echo "MAIL_USERNAME=${MAIL_USERNAME}"
  echo "MAIL_PASSWORD=${MAIL_PASSWORD}"
  echo "MAIL_ENCRYPTION=${MAIL_ENCRYPTION}"

  echo "PUSHER_APP_ID=${PUSHER_APP_ID}"
  echo "PUSHER_KEY=${PUSHER_KEY}"
  echo "PUSHER_SECRET=${PUSHER_SECRET}"

  echo "SANCTUM_STATEFUL_DOMAINS=${SANCTUM_STATEFUL_DOMAINS}"
  echo "SESSION_DOMAIN=${SESSION_DOMAIN}"

  echo "TRUSTED_PROXIES='${TRUSTED_PROXIES:-*}'"

  echo "CRON_JOB_AUTH_TOKEN='${CRON_JOB_AUTH_TOKEN:-}'"
} >.env
chmod 777 .env

exec "$@"
