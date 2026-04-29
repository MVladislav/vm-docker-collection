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
  - [References](#references)

---

## basic

> defined to work with traefik

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
# NETWORK_MODE=overlay # overlay | bridge

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true

DOMAIN=draw.home.local # not set in docker-compose, needs to be copied to .env
# DOMAIN_STORAGE=draw-storage.home.local  # not set in docker-compose, needs to be copied to .env
DOMAIN_ROOM=draw-room.home.local # not set in docker-compose, needs to be copied to .env

PROTOCOL=http
PORT=80
PROTOCOL_STORAGE=http
PORT_STORAGE=8081
PROTOCOL_ROOM=http
PORT_ROOM=80

# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=500m
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# RESOURCES_LIMITS_CPUS_VALKEY=1
# RESOURCES_LIMITS_MEMORY_VALKEY=128m
# RESOURCES_RESERVATIONS_CPUS_VALKEY=0.001
# RESOURCES_RESERVATIONS_MEMORY_VALKEY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_EXCALIDRAW=v0.18.1
VERSION_EXCALIDRAW_ROOM=v0.18.1
# VERSION_EXCALIDRAW_STORAGE=v2023.11.11
# VERSION_VALKEY=8.1.0-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates
```

#### example short .env (swarm)

```env
DOMAIN=draw.home.local
DOMAIN_ROOM=draw-room.home.local
# DOMAIN_STORAGE=draw-storage.home.local
```

#### example short .env (bridge)

```env
LB_SWARM=false

DOMAIN=draw.home.local
DOMAIN_ROOM=draw-room.home.local
# DOMAIN_STORAGE=draw-storage.home.local
```

---

## References

- <https://github.com/excalidraw/excalidraw>
- <https://github.com/excalidraw/excalidraw-room>
- ext:
  - <https://github.com/alswl/excalidraw>
  - <https://github.com/alswl/excalidraw-collaboration>
  - <https://github.com/alswl/excalidraw-storage-backend>
  - <https://github.com/Someone0nEarth/excalidraw-self-hosted>
