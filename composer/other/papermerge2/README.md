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

VERSION=2.0.1

LB_SWARM=true
DOMAIN=papermerge.home.local
PROTOCOL_BACKEND=http
PORT_BACKEND=8000
PROTOCOL_FRONTEND=http
PORT_FRONTEND=80
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file
```

---

## References

- <https://hub.docker.com/r/linuxserver/papermerge>
