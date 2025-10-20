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

> instead of openssl for password you can also use `pwgen -s 50 1`

```sh
$openssl rand -base64 18 | docker secret create my_external_secret -
$openssl rand -base64 18 > config/secrets/my_file_secret.txt
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
DOMAIN=uptime.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=3001
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=500m
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=2.0.1-slim

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
# NOTE: extend additional info here ...
```

#### example short .env (swarm)

```env
DOMAIN=uptime.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=uptime.home.local
```

---

## References

- <https://github.com/louislam/uptime-kuma>
- <https://hub.docker.com/r/louislam/uptime-kuma>
