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
DOMAIN=observium.home.local
PROTOCOL=http
PORT=80
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=protected-secured@file

TZ=Europe/Berlin

MYSQL_RANDOM_ROOT_PASSWORD=yes
MYSQL_ROOT_USER=root
MYSQL_ROOT_PASSWORD=swordfish

OBSERVIUM_DB_HOST=db
OBSERVIUM_DB_NAME=observium
OBSERVIUM_DB_USER=observium 
OBSERVIUM_DB_PASS=swordfish

OBSERVIUM_ADMIN_USER=admin
OBSERVIUM_ADMIN_PASS=swordfish
```

---

## References

- <https://observium.org/>
- <https://github.com/somsakc/docker-observium>
