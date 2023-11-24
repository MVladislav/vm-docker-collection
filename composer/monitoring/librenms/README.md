# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
  - [client setup](#client-setup)
    - [snmpv3](#snmpv3)
  - [References](#references)

---

## basic

> defined to work with treafik

### create your `secrets`:

```sh
$echo "swordfish" > config/secrets/librenms_db_pass.txt
$echo "swordfish" > config/secrets/mariadb_root_password.txt
```

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION_LIBRENMS=23.2.0
VERSION_MARIADB=10.7.8
VERSION_REDIS=7.0.7

LB_SWARM=true
DOMAIN=monitoring.home.local
PROTOCOL=http
PORT=8000
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

TZ=Europe/Berlin
PUID=1000
PGID=1000

MEMORY_LIMIT=256M
MAX_INPUT_VARS=1000
UPLOAD_MAX_SIZE=16M
OPCACHE_MEM_SIZE=128
REAL_IP_FROM=0.0.0.0/32
REAL_IP_HEADER=X-Forwarded-For
LOG_IP_VAR=http_x_forwarded_for

CACHE_DRIVER=redis
SESSION_DRIVER=redis
REDIS_HOST=librenms-redis

LIBRENMS_WEATHERMAP=false
LIBRENMS_WEATHERMAP_SCHEDULE=*/5 * * * *

DB_HOST=librenms-mariadb
DB_PORT=3306
DB_NAME=librenms
DB_USER=librenms

DB_TIMEOUT=60
```

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
$sudo ufw allow in on <INTERFACE> to any port 161 proto udp comment "allow incoming connection on default snmp port"
```

---

## References

- <https://docs.librenms.org/Installation/Docker/>
- <https://github.com/librenms/librenms/>
- <https://hub.docker.com/r/librenms/librenms>
