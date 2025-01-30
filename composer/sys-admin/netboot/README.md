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
DOMAIN=netboot.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=3000
DOMAIN_ASSETS=netboot-img.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL_ASSETS=http
PORT_ASSETS=80
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
VERSION=0.7.3-nbxyz3

# (optional) NFS to store data on a NFS-Storage (commented in compose)
# ______________________________________________________________________________
NFS_HOST=<ADD>
NFS_PATH_CONFIG=<ADD>
NFS_PATH_ASSETS=<ADD>
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=netboot.home.local
DOMAIN_ASSETS=netboot-img.home.local
```

---

## References

- <https://netboot.xyz/docs/quick-start>
- <https://netboot.xyz>
- <https://netboot.xyz/docs/docker/>
- <https://github.com/netbootxyz/docker-netbootxyz>
- dhcp
  - <https://docs.linuxserver.io/images/docker-netbootxyz/?h=netboo#router-setup-examples>
  - <https://netboot.xyz/docs/docker/#dhcp-configurations>
