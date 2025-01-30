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
      - [example short .env](#example-short-env)
  - [FAQ](#faq)
  - [References](#references)

---

## basic

> defined to work with traefik

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
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=nextcloud.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=80
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
# 500m | 1g | ...
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_NEXTCLOUD=27.1.3-apache
VERSION_NEXTCLOUD_CRON=27.1.3-fpm
VERSION_REDIS=7.2.2-alpine3.18

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
NEXTCLOUD_ADMIN_USER=admin

MYSQL_HOST=mysql
MYSQL_DATABASE=nextcloud
MYSQL_USER=nextcloud
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=nextcloud.home.local

VERSION_NEXTCLOUD=27.1.3-apache
VERSION_NEXTCLOUD_CRON=27.1.3-fpm
VERSION_REDIS=7.2.2-alpine3.18
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
