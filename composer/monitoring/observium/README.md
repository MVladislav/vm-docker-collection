# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [Hint](#hint)
  - [client setup](#client-setup)
    - [snmpv3](#snmpv3)
  - [References](#references)

---

**find source and docker-compose on [github](https://github.com/MVladislav/vm-docker-collection/tree/develop/composer/monitoring/observium)**

---

## basic

> defined to work with traefik

### create your `secrets`:

> do not use hard passwort with special chars like "$", they not work current

```sh
$openssl rand -base64 18 > config/secrets/observium_admin_pass.txt
$openssl rand -base64 18 > config/secrets/mariadb_user_password.txt
$openssl rand -base64 18 > config/secrets/mariadb_root_password.txt
```

### create `.env` file following:

```env

# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=observium.home.local
PROTOCOL=http
PORT=80
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=2
RESOURCES_LIMITS_MEMORY=2g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=ce-23.9
VERSION_MARIADB:-11.3.2

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
TZ=Europe/Berlin

OBSERVIUM_ADMIN_USER=admin

MARIADB_DATABASE=observium
MARIADB_USER=observium

MARIADB_HOST=mariadb
MARIADB_PORT=3306

# BUILD
# ______________________________________________________________________________
VERSION_DEBIAN=12.5-slim
BUILD_DATE=2024

# PHPMYADMIN
# ______________________________________________________________________________
VERSION_PHPMYADMIN=5.2.0-apache
DOMAIN_PHPMYADMIN=phpmyadmin.home.local
PROTOCOL_PHPMYADMIN=http
PORT_PHPMYADMIN=8080
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=observium.home.local
VERSION=ce-23.9

TZ=Europe/Berlin
```

---

## Hint

- Mail alert send, works with `Mail backend = SMTP`
- Rename hostname/IP of an existing device
  - `./rename_device.php <old hostname> <new hostname>`

## client setup

### snmpv3

install snmp:

```sh
$sudo apt install snmp snmpd
$sudo mkdir -p /usr/local/lib/snmpd/
$sudo mkdir -p /etc/snmp/snmpd.conf.d/
```

load extend scripts:

```sh
$sudo curl https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/distro -o /usr/local/lib/snmpd/distro
#$sudo curl https://www.observium.org/files/distro -o /usr/local/lib/snmpd/distro
$sudo curl https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/osupdate -o /usr/local/lib/snmpd/osupdate
$sudo apt install libsnmp-extension-passpersist-perl

: 'for proxmox'
$sudo curl https://raw.githubusercontent.com/librenms/librenms-agent/master/agent-local/proxmox -o /usr/local/lib/snmpd/proxmox
$sudo sed -i "s/TIMEZONE => 'Europe\/Amsterdam'/TIMEZONE => 'Europe\/Berlin'/g" /usr/local/lib/snmpd/proxmox

: 'for debian'
$chmod o+r \
  /usr/local/lib/snmpd/distro \
  /usr/local/lib/snmpd/osupdate \
  /sys/devices/virtual/dmi/id/product_name \
  /sys/devices/virtual/dmi/id/sys_vendor \
  /sys/devices/virtual/dmi/id/product_serial \
  /proc/device-tree/model \
  /proc/device-tree/serial \
  /proc/uptime

$chgrp Debian-snmp \
  /usr/local/lib/snmpd/proxmox
$chmod g+rx \
  /usr/local/lib/snmpd/proxmox
```

configure `sudo nano /etc/snmp/snmpd.conf`:

```conf
createUser snmp SHA '<PASSWORD>' AES '<ENCRYPTION>'

#rouser snmp priv
rouser snmp authpriv
master  agentx
agentAddress  udp:161

sysLocation home
sysContact  <NAME> <MAIL>
sysName     <FQDN>.home.local
sysServices 72

# dont log connection from UDP:
dontLogTCPWrappersConnects yes

# fix for disks larger then 2TB
realStorageUnits 0

## Disk Monitoring
includeAllDisks  10%

includeDir /etc/snmp/snmpd.conf.d

## This line allows Observium to detect the host OS if the distro script is installed
## sudo curl https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/distro -o /usr/local/lib/snmpd/distro
## or sudo curl https://www.observium.org/files/distro -o /usr/local/lib/snmpd/distro
extend .1.3.6.1.4.1.2021.7890.1 distro /usr/local/lib/snmpd/distro

## This line allows Observium to detect the host OSUPDATE if the osupdate script is installed
## sudo curl https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/osupdate -o /usr/local/lib/snmpd/osupdate
extend osupdate /usr/local/lib/snmpd/osupdate

# This lines allows Observium to detect hardware, vendor and serial
# Common Linux:
extend .1.3.6.1.4.1.2021.7890.2 hardware /bin/cat /sys/devices/virtual/dmi/id/product_name
extend .1.3.6.1.4.1.2021.7890.3 vendor   /bin/cat /sys/devices/virtual/dmi/id/sys_vendor
extend .1.3.6.1.4.1.2021.7890.4 serial   /bin/cat /sys/devices/virtual/dmi/id/product_serial

## Raspberry Pi:
#extend .1.3.6.1.4.1.2021.7890.2 hardware /bin/cat /proc/device-tree/model
#extend .1.3.6.1.4.1.2021.7890.4 serial   /bin/cat /proc/device-tree/serial

## This line allows Observium to collect an accurate uptime
extend uptime /bin/cat /proc/uptime

## This line enables Observium's ifAlias description injection
## sudo apt install libsnmp-extension-passpersist-perl
pass_persist .1.3.6.1.2.1.31.1.1.1.18 /usr/bin/ifAlias_persist

## proxmox
## sudo curl https://raw.githubusercontent.com/librenms/librenms-agent/master/agent-local/proxmox -o /usr/local/lib/snmpd/proxmox
#extend proxmox /usr/bin/perl /usr/local/lib/snmpd/proxmox
```

enable and restart:

```sh
$sudo systemctl enable snmpd
$sudo systemctl restart snmpd
```

firewall:

```sh
$sudo ufw allow in on <INTERFACE> to any port 161 proto udp comment "allow incoming connection on standard snmp port"
```

---

## References

- <https://observium.org/>
- <https://github.com/somsakc/docker-observium>
- <https://github.com/Yelp/docker-observium>
- <https://github.com/charlescng/docker-containers/tree/master/observium>
- <https://github.com/phusion/baseimage-docker>
- <https://github.com/outstand/docker-syslog-ng-stdout>
- <https://docs.observium.org/alerting_examples/>
