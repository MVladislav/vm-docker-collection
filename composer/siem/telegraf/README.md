# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [References](#references)

---

## basic

> defined to work with traefik

### create `.env` file following:

```env
NETWORK_MODE=overlay

VERSION=latest

LB_SWARM=true
DOMAIN=telegraf.home.local
PROTOCOL=http
PORT=8125
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

INFLUXDB_ORG=<ORG>
INFLUXDB_BUCKET=<BUCKET>
INFLUXDB_TOKEN=<TOKEN>
```

---

## References

- <https://github.com/influxdata/telegraf>
- <https://hub.docker.com/_/telegraf>
