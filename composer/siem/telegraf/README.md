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

### create `.env` file following:

```env
NETWORK_MODE=overlay

VERSION=latest

LB_SWARM=true
DOMAIN=telegraf.home.local
PROTOCOL=http
PORT=8125
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

INFLUXDB_ORG=
INFLUXDB_BUCKET=
INFLUXDB_TOKEN=<TOKEN>
```

---

## References

- <https://github.com/influxdata/telegraf>
- <https://hub.docker.com/_/telegraf>
