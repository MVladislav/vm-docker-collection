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
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=latest

LB_SWARM=true
DOMAIN=spider.home.local
PROTOCOL=http
PORT=5001
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file
```

---

## References

- <https://github.com/smicallef/spiderfoot>
- <https://serverfault.com/questions/1056213/run-nmap-in-a-docker-container-as-a-non-admin-user>
