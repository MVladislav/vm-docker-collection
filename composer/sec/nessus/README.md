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
NETWORK_MODE=overlay # by default "bridge"

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=nessus.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=https
PORT=8834
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
VERSION=10.7.1-ubuntu
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=nessus.home.local
```

---

## References

- <https://hub.docker.com/r/tenableofficial/nessus>
- <https://docs.tenable.com/nessus/Content/DeployNessusDocker.htm>
- <https://www.tenable.com/downloads/nessus?loginAttempted=true>
