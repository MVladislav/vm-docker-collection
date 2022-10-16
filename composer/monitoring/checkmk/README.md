# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [enterprise free from checkmk-page](#enterprise-free-from-checkmk-page)
    - [change `.env` file following:](#change-env-file-following)
  - [info](#info)
  - [References](#references)

---

A tool for Infrastructure & Application Monitoring. It is a software developed for IT Infrastructure monitoring. It is used for the monitoring of servers, applications, networks, cloud infrastructures, containers, storage, databases and environment sensors.

## basic

> defined to work with treafik

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=2.1.0
TYPE=check-mk-raw

LB_SWARM=true
DOMAIN=checkmk.home.local
PROTOCOL=http
PORT=5000
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file
```

## enterprise free from checkmk-page

download **tar.gz** from site as choosed for docker download:

```sh
$wget https://download.checkmk.com/checkmk/2.0.0p12/check-mk-free-docker-2.0.0p12.tar.gz
```

and run:

```sh
$docker load -i check-mk-free-docker-2.0.0p12.tar.gz
```

### change `.env` file following:

> HINT: **check `VERSION` from your downloaded version**

```env
VERSION=2.0.0p12
TYPE=check-mk-free
```

## info

user credentials can be found in the logs:

```sh
$docker service logs --raw -f checkmk_checkmk
```

---

## References

- <https://checkmk.com/de>
- <https://github.com/tribe29/checkmk/>
- <https://hub.docker.com/r/checkmk/check-mk-raw/>
- <https://docs.checkmk.com/latest/de/agent_linux.html#security>
- <https://github.com/filipnet/checkmk-telegram-notify>
