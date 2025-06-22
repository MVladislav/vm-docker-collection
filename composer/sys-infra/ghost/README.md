# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$pwgen -s 18 1 > config/secrets/mariadb_user_password.txt
$echo "MARIADB_PASSWORD_TMP=$(cat config/secrets/mariadb_user_password.txt)" >> .env
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
DOMAIN=ghost.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=2368
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_GHOST:-5-alpine
VERSION_MARIADB:-11.3.2

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
MARIADB_PASSWORD_TMP=$(cat config/secrets/mariadb_user_password.txt)
```

#### example short .env

```env
DOMAIN=ghost.home.local
```

---

## References

- <https://hub.docker.com/_/ghost>
