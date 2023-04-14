# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
  - [References](#references)

---

## basic

> defined to work with treafik

### create your `secrets`:

```sh
$echo "swordfish" > config/secrets/mariadb_root_password.txt
```

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION_MARIADB=8.0.31
VERSION_PHPMYADMIN=5.2.0-apache

LB_SWARM=true
DOMAIN=mariadb.home.local
PROTOCOL=http
PORT=8080
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

TZ = Europe/Berlin
```

---

## References

- <https://hub.docker.com/_/mariadb>
- <https://hub.docker.com/_/phpmyadmin>
