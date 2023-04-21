# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets` (optional when mysql is needed):](#create-your-secrets-optional-when-mysql-is-needed)
    - [create `.env` file following:](#create-env-file-following)
  - [References](#references)

---

## basic

> defined to work with treafik

### create your `secrets` (optional when mysql is needed):

```sh
$echo "swordfish" > config/secrets/freshrss_db_pass.txt
$echo "swordfish" > config/secrets/mariadb_root_password.txt
```

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=1.21.0
VERSION_MARIADB=10.7.8

LB_SWARM=true
DOMAIN=freshrss.home.local
PROTOCOL=http
PORT=8080
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file


TZ=Europe/Berlin
CRON_MIN=3,33

# OPTIONAL

ADMIN_EMAIL=root@home.local

FRESHRSS_DB_HOST=freshrss-mariadb
FRESHRSS_DB_NAME=freshrss
FRESHRSS_DB_USER=freshrss

ADMIN_PASSWORD=freshrss
ADMIN_API_PASSWORD=freshrss
DB_PASSWORD=freshrss
```

---

## References

- <https://freshrss.org/>
- <https://github.com/FreshRSS/FreshRSS>
- <https://github.com/FreshRSS/FreshRSS/tree/edge/Docker>
