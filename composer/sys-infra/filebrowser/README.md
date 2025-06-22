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

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=share.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=80
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=256M
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=v2.33.2

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
GID=0
UID=0

NFS_HOST=<ADD-NFS-HOST>
NFS_PATH=<ADD-NFS-PATH>
```

#### example short .env

```env
DOMAIN=share.home.local

NFS_HOST=<ADD-NFS-HOST>
NFS_PATH=<ADD-NFS-PATH>
```

---

## References

- <https://github.com/filebrowser/filebrowser>
- <https://filebrowser.org/installation>
