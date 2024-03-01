#!/usr/bin/env bash

count=0
rc=1

while [ $rc -ne 0 ]; do
  let count++
  echo "[$count] Verifying coonection to observium database."
  MYSQL_PWD="$OBSERVIUM_DB_PASS" mysql -h "${OBSERVIUM_DB_HOST}" -u "${OBSERVIUM_DB_USER}" -e "select 1" "${OBSERVIUM_DB_NAME}" >/dev/null
  rc=$?
  [ $rc -ne 0 ] && sleep 5
done

echo "Connected to observium database successfully."

tables=$(MYSQL_PWD="$OBSERVIUM_DB_PASS" mysql -h "${OBSERVIUM_DB_HOST}" -u "${OBSERVIUM_DB_USER}" -e "show tables" "${OBSERVIUM_DB_NAME}" 2>/dev/null)

if [ -z "$tables" ]; then
  echo "Setting /opt/observium/rrd directory to www-data:www-data."
  chown -v www-data:www-data /opt/observium/rrd
  chown -v www-data:www-data /opt/observium/logs
  echo "Initializing database schema in first time running for observium."
  /opt/observium/discovery.php -u
  /opt/observium/adduser.php "${OBSERVIUM_ADMIN_USER}" "${OBSERVIUM_ADMIN_PASS}" 10
else
  echo "Database schema initialization has been done already."
  sleep 5
fi

if [ -z "$TZ" ] || [ "$TZ" = "Etc/UTC" ]; then
  echo "Keep system timezone as the default of $(cat /etc/timezone)."
else
  if [ -f "/usr/share/zoneinfo/$TZ" ]; then
    echo "Setting system timezone to specific $TZ."
    echo "$TZ" >/etc/timezone
    ln -sfv "/usr/share/zoneinfo/$TZ" /etc/localtime
  else
    echo "Invalid specific $TZ timezone and use the default of $(cat /etc/timezone) instead."
  fi
fi

echo "Check Database, and update if version changed"
/opt/observium/discovery.php -u
# /opt/observium/discovery.php -h all

{
  echo "export OBSERVIUM_ADMIN_USER='${OBSERVIUM_ADMIN_USER}'"
  echo "export OBSERVIUM_ADMIN_PASS='${OBSERVIUM_ADMIN_PASS}'"
  echo "export OBSERVIUM_DB_HOST='${OBSERVIUM_DB_HOST}'"
  echo "export OBSERVIUM_DB_USER='${OBSERVIUM_DB_USER}'"
  echo "export OBSERVIUM_DB_PASS='${OBSERVIUM_DB_PASS}'"
  echo "export OBSERVIUM_DB_NAME='${OBSERVIUM_DB_NAME}'"
} >>/opt/observium/observium-setenv.sh
chmod u+x /opt/observium/observium-setenv.sh

exit 0
