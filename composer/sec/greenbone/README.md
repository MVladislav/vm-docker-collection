# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [info](#info)
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
DOMAIN=greenbone.home.local
PROTOCOL=http
PORT=9392
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file
```

## info

default credentials:

- username: **admin**
- password: **admin**

change password:

```sh
$docker-compose exec -u gvmd gvmd gvmd --user=admin --new-password=<PASSWORD>
```

---

## References

- <https://greenbone.github.io/docs/latest/22.4/container/index.html>
- <https://hub.docker.com/r/greenbone/openvas-scanner>
