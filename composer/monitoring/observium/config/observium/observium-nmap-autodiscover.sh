#!/bin/bash

# Exit if there is an error
set -e

# If script is executed as an unprivileged user
# Execute it as superuser, preserving environment variables
if [ $EUID != 0 ]; then
  echo "Executing as superuser"
  sudo -E "$0" "$@"
  exit $?
fi

# If required variables are not set, set sensible defaults
OBSERVIUM_INSTALL_DIR=${OBSERVIUM_INSTALL_DIR:-/opt/observium}

# Get the network to scan from this computer's IP address
# SUBNET=$(ip -o -f inet addr show | awk '/scope global/ {print $4}')
SUBNET=$(echo "127.0.0.0/8 192.168.0.0/16 10.0.0.0/8 172.16.0.0/12")

echo "Scanning subnet $SUBNET for devices running SNMP..."

# Scan the network and grep to get just FQDNs
# GET_SNMP_HOSTS=$(nmap -PE -sU -p161 --open $SUBNET -oG - | awk '/Up$/{print $3}' | tr -d '()' | sed '/^$/d')
GET_SNMP_HOSTS=$(nmap -PE -sU -p161 --open $SUBNET -oG - | awk '/Up$/{print $2}' | tr -d '()' | sed '/^$/d')

# Put the device FQDNs into an array
readarray -t SNMP_HOSTS <<<"$GET_SNMP_HOSTS"

echo "Scan complete"
echo "Found devices:"
printf '%s\n' "${SNMP_HOSTS[@]}"

echo "Attempting to add devices to Observium..."

# Attempt to add each device by FQDN
# without specifying any auth, so that
# Observium uses the options set in
# /opt/observium/config.php
for i in "${SNMP_HOSTS[@]}"; do
  cd $OBSERVIUM_INSTALL_DIR && $OBSERVIUM_INSTALL_DIR/add_device.php $i -p
done
