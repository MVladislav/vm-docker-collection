# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [Note](#note)
    - [credentials](#credentials)
  - [References](#references)

---

## basic

> defined to work with treafik

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION_FARADAY=4.4.0
VERSION_POSTGRES=15.3-alpine
VERSION_REDIS=7.0.11-alpine

LB_SWARM=true
DOMAIN=faraday.home.local
PROTOCOL=http
PORT=5985
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

RESOURCES_LIMITS_CPUS="1"
# 500m | 1g | ...
RESOURCES_LIMITS_MEMORY=500m
RESOURCES_RESERVATIONS_CPUS="0.001"
RESOURCES_RESERVATIONS_MEMORY=32m

POSTGRES_DB=faraday
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
```

## Note

### credentials

**username**: faraday

**password** is print in the logs

---

## References

- <https://github.com/infobyte/faraday>
- <https://github.com/infobyte/faraday/blob/master/docker-compose.yaml>
- <https://hub.docker.com/r/faradaysec/faraday>
- <https://faradaysec.com>
