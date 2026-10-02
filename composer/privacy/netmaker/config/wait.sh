#!/bin/bash

encrypt_password() {
  echo "${MQ_USERNAME}:${MQ_PASSWORD}" >/mosquitto/password.txt
  mosquitto_passwd -U /mosquitto/password.txt
}

wait_for_netmaker() {
  echo "SERVER: ${NETMAKER_SERVER_HOST}"
  until curl --output /dev/null --silent --fail --head \
    --location "${NETMAKER_SERVER_HOST}/api/server/health"; do
    echo "Waiting for netmaker server to startup"
    sleep 1
  done
}

main() {
  apk add curl
  # wait for netmaker to startup
  wait_for_netmaker
  echo "Starting MQ..."
  encrypt_password
  # Run the main container command.
  /docker-entrypoint.sh
  /usr/sbin/mosquitto -c /mosquitto/config/mosquitto.conf

}

main "${@}"
