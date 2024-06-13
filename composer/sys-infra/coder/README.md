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

> defined to work with treafik

### create your `secrets`:

```sh
$pwgen -s 18 1 > config/secrets/postgres_password_file.txt
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=code.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=7080
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=4
RESOURCES_LIMITS_MEMORY=8g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_CODER=v2.12.1
VERSION_POSTGRESQL=16.2-alpine3.19

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
POSTGRES_PASSWORD_TMP=$(cat config/secrets/postgres_password_file.txt)
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=code.home.local

POSTGRES_PASSWORD_TMP=$(cat config/secrets/postgres_password_file.txt)
```

---

## References

- <https://coder.com/docs/install/docker>
