# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [enterprise free](#enterprise-free)
    - [create `.env` file following:](#create-env-file-following-1)
  - [References](#references)

---

A tool for Infrastructure & Application Monitoring. It is a software developed for IT Infrastructure monitoring. It is used for the monitoring of servers, applications, networks, cloud infrastructures, containers, storage, databases and environment sensors.

## basic

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

PORT=8080

VERSION=2.0.0-latest
TYPE=check-mk-raw
```

## enterprise free

download **tar.gz** from site as choosed for docker download:

```sh
$wget https://download.checkmk.com/checkmk/2.0.0p12/check-mk-free-docker-2.0.0p12.tar.gz
```

and run:

```sh
$docker load -i check-mk-free-docker-2.0.0p12.tar.gz
```

### create `.env` file following:

HINT: **check `VERSION` from your downloaded version**

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

PORT=8080

VERSION=2.0.0p12
TYPE=check-mk-free
```

---

## References

- <https://checkmk.com/de>
- <https://github.com/tribe29/checkmk/>
- <https://hub.docker.com/r/checkmk/check-mk-raw/>
- <https://docs.checkmk.com/latest/de/agent_linux.html#security>
