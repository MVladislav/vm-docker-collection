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
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=latest

LB_SWARM=true
DOMAIN=openvas.home.local
PROTOCOL=https
PORT=443
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file
```

---

## References

- <https://github.com/mikesplain/openvas-docker>
- <https://hub.docker.com/r/mikesplain/openvas/dockerfile>
