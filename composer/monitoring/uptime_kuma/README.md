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
NODE_ROLE=manager

VERSION=1.21.1-alpine

LB_SWARM=true
DOMAIN=uptime-kuma.home.local
PROTOCOL=http
PORT=3001
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file
```

---

## References

- <https://github.com/louislam/uptime-kuma>
- <https://hub.docker.com/r/louislam/uptime-kuma>
