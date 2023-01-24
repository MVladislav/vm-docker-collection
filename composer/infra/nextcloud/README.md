# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [database setup](#database-setup)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
  - [FAQ](#faq)
  - [References](#references)

---

## basic

> defined to work with treafik

### database setup

setup mysql from [here](https://github.com/MVladislav/vm-docker-collection/tree/main/composer/db/mysql)

and add new space for nextcloud in mysql, see `MYSQL_*` below for namings.

### create your `secrets`:

```sh
$echo "swordfish" > config/secrets/nextcloud_admin_password.txt
$echo "swordfish" > config/secrets/mysql_password.txt
```

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION_NEXTCLOUD=25.0.2-apache
VERSION_NEXTCLOUD_CRON=25.0.2-fpm
VERSION_REDIS=7.0.7

LB_SWARM=true
DOMAIN=nextcloud.home.local
PROTOCOL=http
PORT=80
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

NEXTCLOUD_ADMIN_USER=admin

MYSQL_HOST=mysql
MYSQL_DATABASE=nextcloud
MYSQL_USER=nextcloud
```

---

## FAQ

- redis
  - redis needs to have ipv6 turned on, check grub for entry with `ipv6.disable=1`

---

## References

- <https://hub.docker.com/_/nextcloud>
- <https://github.com/nextcloud/all-in-one#how-to-use-this>
- <https://github.com/nextcloud/docker/issues/1028>
- <https://github.com/nextcloud/docker/issues/1740>
