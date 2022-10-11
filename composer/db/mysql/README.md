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
$echo "swordfish" > config/secrets/mysql_root_password.txt
```

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION_MYSQL=8.0.30
VERSION_PHPMYADMIN=5.2.0-apache
VERSION_ADMINER=4.8.1-standalone

LB_SWARM=true
DOMAIN=mysql.home.local
PROTOCOL=http
PORT=8080
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

TZ = Europe/Berlin
MYSQL_ROOT_USER = root
```

---

## References

- <https://hub.docker.com/_/mysql>
- <https://hub.docker.com/_/phpmyadmin>
