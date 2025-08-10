# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env (swarm)](#example-short-env-swarm)
      - [example short .env (bridge)](#example-short-env-bridge)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$pwgen -s 32 1 > config/secrets/mariadb_user_password.txt
$echo "OWNCLOUD_DB_PASSWORD=$(cat config/secrets/mariadb_user_password.txt)" >> .env
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=owncloud.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8080
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_MARIADB=1
RESOURCES_LIMITS_MEMORY_MARIADB=512m
RESOURCES_RESERVATIONS_CPUS_MARIADB=0.001
RESOURCES_RESERVATIONS_MEMORY_MARIADB=32m

RESOURCES_LIMITS_CPUS_VALKEY=1
RESOURCES_LIMITS_MEMORY_VALKEY=128m
RESOURCES_RESERVATIONS_CPUS_VALKEY=0.001
RESOURCES_RESERVATIONS_MEMORY_VALKEY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_OWNCLOUD=10.15
VERSION_MARIADB=11.7.2
VERSION_VALKEY=8.1.0-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
OWNCLOUD_ADMIN_USERNAME=root
OWNCLOUD_ADMIN_PASSWORD=<PASSWORD>
```

#### example short .env (swarm)

```env
DOMAIN=owncloud.home.local
OWNCLOUD_ADMIN_PASSWORD=<PASSWORD>
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=owncloud.home.local
OWNCLOUD_ADMIN_PASSWORD=<PASSWORD>
```

---

## References

- <https://hub.docker.com/r/owncloud/server>
- <https://doc.owncloud.com/server/10.11/admin_manual/installation/docker/>
