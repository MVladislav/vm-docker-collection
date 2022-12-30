# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [database setup](#database-setup)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
  - [Hint](#hint)
  - [client setup](#client-setup)
    - [snmpv3](#snmpv3)
  - [References](#references)

---

**find source and docker-compose on [github](https://github.com/MVladislav/vm-docker-collection/tree/develop/composer/monitoring/observium)**

---

## basic

> defined to work with treafik

### database setup

setup mysql from [here](https://github.com/MVladislav/vm-docker-collection/tree/main/composer/db/mysql)

and add new space for observium in mysql, see `OBSERVIUM_DB_*` below for namings.

### create your `secrets`:

> do not use hard passwort with special chars like "$", they not work current

```sh
$echo "swordfish" > config/secrets/observium_admin_pass.txt
$echo "swordfish" > config/secrets/observium_db_pass.txt
```

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=ce-22.5.12042

LB_SWARM=true
DOMAIN=observium.home.local
PROTOCOL=http
PORT=80
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

TZ=Europe/Berlin

OBSERVIUM_ADMIN_USER=groot

OBSERVIUM_DB_HOST=mysql
OBSERVIUM_DB_PORT=3306

OBSERVIUM_DB_NAME=observium
OBSERVIUM_DB_USER=observium
```

## Hint

- Mail alert send, works with `Mail backend = SMTP`
- Rename hostname/IP of an existing device
  - `./rename_device.php <old hostname> <new hostname>`

## client setup

### snmpv3

install snmp:

```sh
$sudo apt install snmp snmpd
$sudo mkdir /usr/local/lib/snmpd/
```

load extend scripts:

```sh
$sudo curl https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/distro -o /usr/local/lib/snmpd/distro
#$sudo curl https://www.observium.org/files/distro -o /usr/local/lib/snmpd/distro
$sudo curl https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/osupdate -o /usr/local/lib/snmpd/osupdate
$sudo apt install libsnmp-extension-passpersist-perl

: 'for proxmox'
$sudo curl https://raw.githubusercontent.com/librenms/librenms-agent/master/agent-local/proxmox -o /usr/local/lib/snmpd/proxmox
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

includeDir /etc/snmp/snmpd.conf.d

## This line allows Observium to detect the host OS if the distro script is installed
## sudo curl https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/distro -o /usr/local/lib/snmpd/distro
## or sudo curl https://www.observium.org/files/distro -o /usr/local/lib/snmpd/distro
extend .1.3.6.1.4.1.2021.7890.1 distro /usr/local/lib/snmpd/distro

## This line allows Observium to detect the host OSUPDATE if the osupdate script is installed
## sudo curl https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/osupdate -o /usr/local/lib/snmpd/osupdate
extend osupdate /usr/local/lib/snmpd/osupdate

## Disk Monitoring
includeAllDisks  10%

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
pass_persist .1.3.6.1.2.1.31.1.1.1.18 /usr/local/bin/ifAlias_persist

## proxmox
## wget https://raw.githubusercontent.com/librenms/librenms-agent/master/agent-local/proxmox
#extend proxmox /usr/bin/sudo /usr/local/lib/snmpd/proxmox
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
