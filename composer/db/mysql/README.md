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

VERSION=5.7

LB_SWARM=true
DOMAIN=mysql.home.local
PROTOCOL=http
PORT=80
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

TZ = Europe/Berlin
MYSQL_ROOT_USER = root
MYSQL_ROOT_PASSWORD = <PASSWORD>
```

---

## References

- <https://hub.docker.com/_/mysql>
- <https://hub.docker.com/_/phpmyadmin>
