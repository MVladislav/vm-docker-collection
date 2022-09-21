# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [client setup](#client-setup)
    - [snmpv3](#snmpv3)
  - [References](#references)

---

## basic

> defined to work with treafik

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=latest

LB_SWARM=true
DOMAIN=observium.home.local
PROTOCOL=http
PORT=80
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=protected-secured@file

TZ=Europe/Berlin

OBSERVIUM_ADMIN_USER=admin
OBSERVIUM_ADMIN_PASS=swordfish

MYSQL_ROOT_PASSWORD = <PASSWORD>
DBHOST = mysql
DBPORT = 3306

DBNAME = observium
DBUSER = observium
DBPASS = <PASSWORD>
```

## client setup

### snmpv3

```sh
$sudo apt install snmp snmpd
$sudo mkdir /usr/local/lib/snmpd/
$sudo curl https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/distro -o /usr/local/lib/snmpd/distro
$sudo curl https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/osupdate -o /usr/local/lib/snmpd/osupdate
$sudo nano /etc/snmp/snmpd.conf
```

```conf
createUser snmp SHA '<PASSWORD>' AES '<ENCRYPT>'

rouser snmp authpriv
master  agentx
agentAddress  udp:161

sysLocation <LOCATION>
sysContact <NAME> <MAIL>
sysName <FQDN>
sysServices    72

includeDir /etc/snmp/snmpd.conf.d

extend .1.3.6.1.4.1.2021.7890.1 distro /usr/local/lib/snmpd/distro
extend osupdate /usr/local/lib/snmpd/osupdate
```

```sh
$sudo systemctl enable snmpd
$sudo systemctl restart snmpd
```

firewall: `$sudo ufw allow in on ens18 to any port 161 proto udp comment "allow incoming connection on standard snmp port"`

---

## References

- <https://observium.org/>
- <https://github.com/somsakc/docker-observium>
- <https://github.com/Yelp/docker-observium>
- <https://github.com/charlescng/docker-containers/tree/master/observium>
- <https://github.com/phusion/baseimage-docker>
- <https://github.com/outstand/docker-syslog-ng-stdout>
