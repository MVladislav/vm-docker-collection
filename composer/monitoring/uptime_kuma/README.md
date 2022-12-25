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

> defined to work with treafik

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=1.18.5

LB_SWARM=true
DOMAIN=uptime-kuma.home.local
PROTOCOL=http
PORT=3001
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file
```

---

## References

- <https://github.com/louislam/uptime-kuma>
- <https://hub.docker.com/r/louislam/uptime-kuma>
