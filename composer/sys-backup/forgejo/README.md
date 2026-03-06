# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env (swarm)](#example-short-env-swarm)
      - [example short .env (bridge)](#example-short-env-bridge)
  - [Guides \& Insights](#guides--insights)
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
DOMAIN=forgejo.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=3000
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

MIDDLEWARE_SECURED_SSH=default-whitelist
PORT_SSH=22

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=14

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates

USER_UID=1000
USER_GID=1000

NFS_HOST=<NFS_HOST>
NFS_PATH=<NFS_PATH>
```

#### example short .env (swarm)

```env
DOMAIN=forgejo.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=forgejo.home.local
```

## Guides & Insights

If self hosted cert use `GIT_SSL_NO_VERIFY=true git ...`.

---

## References

- <https://codeberg.org/forgejo/forgejo>
- <https://forgejo.org/docs/latest/admin/installation/docker/#docker>
- <https://forgejo.org/docs/latest/admin/config-cheat-sheet/#server-server>
