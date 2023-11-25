# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [FAQ](#faq)
  - [References](#references)

---

## basic

> defined to work with treafik

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=kimai.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8001
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=0.5
RESOURCES_LIMITS_MEMORY=500m
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_KIMAI=apache-2.4.1-prod
VERSION_MYSQL=8.2.0

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
MYSQL_PASSWORD=
MYSQL_ROOT_PASSWORD=
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=kimai.home.local

VERSION_KIMAI=apache-2.4.1-prod
VERSION_MYSQL=8.2.0

MYSQL_PASSWORD=
MYSQL_ROOT_PASSWORD=
```

---

## FAQ

On intial setup you need to assigne the first user manually a admin roles:

```sh
$docker exec -it "$(docker ps -q -f name=kimai_kimai)" /opt/kimai/bin/console kimai:user:create admin admin@home.local ROLE_SUPER_ADMIN
```

---

## References

- <https://hub.docker.com/r/kimai/kimai2>
- <https://github.com/kimai/kimai>
- <https://www.kimai.org/documentation/docker-compose.html>