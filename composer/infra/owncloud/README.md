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
$echo "swordfish" > config/secrets/owncloud_db_password.txt
```

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION_OWNCLOUD=10
VERSION_REDIS=7.0.7

LB_SWARM=true
DOMAIN=owncloud.home.local
PROTOCOL=http
PORT=8080
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

OWNCLOUD_TRUSTED_DOMAINS=owncloud.home.local
OWNCLOUD_DOMAIN=owncloud.home.local:8080
ADMIN_USERNAME=groot
ADMIN_PASSWORD=swordfish

OWNCLOUD_DB_TYPE=mysql
OWNCLOUD_MYSQL_UTF8MB4=true
OWNCLOUD_DB_HOST=mysql
OWNCLOUD_DB_PORT=3306
OWNCLOUD_DB_NAME=owncloud
OWNCLOUD_DB_USERNAME=owncloud
OWNCLOUD_DB_PASSWORD=owncloud
```

---

## References

- <https://hub.docker.com/r/owncloud/server>
- <https://doc.owncloud.com/server/10.11/admin_manual/installation/docker/>
