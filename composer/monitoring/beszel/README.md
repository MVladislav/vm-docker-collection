# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [References](#references)

---

## basic

> defined to work with traefik

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=beszel.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8090
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
VERSION=0.14.0

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________

# Agent
AGENT_TYPE= # -nvidia | -intel
```

#### example short .env

```env
DOMAIN=beszel.home.local
```

---

## References

- <https://github.com/henrygd/beszel>
- <https://github.com/henrygd/beszel/blob/main/supplemental/docker/same-system/docker-compose.yml>
