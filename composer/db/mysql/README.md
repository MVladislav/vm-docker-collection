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
$openssl rand -base64 18 > config/secrets/mysql_root_password.txt
```

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION_MYSQL=8.0.31
VERSION_PHPMYADMIN=5.2.0-apache
VERSION_ADMINER=4.8.1-standalone

LB_SWARM=true
DOMAIN=mysql.home.local
PROTOCOL=http
PORT=8080 # 8080 (adminer) | 80 (phpmyadmin)
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

TZ = Europe/Berlin
MYSQL_ROOT_USER = root
```

---

## References

- <https://hub.docker.com/_/mysql>
- <https://hub.docker.com/_/phpmyadmin>
