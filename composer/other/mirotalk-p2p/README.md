# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [config files](#config-files)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env (swarm)](#example-short-env-swarm)
      - [example short .env (bridge)](#example-short-env-bridge)
  - [References](#references)

---

## basic

> defined to work with traefik

### config files

```sh
cp config/config.js.tmpl config/config.js
# Replace <DOMAIN>
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
DOMAIN=meet.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=3000
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=2
RESOURCES_LIMITS_MEMORY=2g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=latest

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
API_KEY_SECRET=`openssl rand -base64 32 | tr -d '\n'`
JWT_KEY=`openssl rand -base64 64 | tr -d '\n'`
```

#### example short .env (swarm)

```env
DOMAIN=meet.home.local
API_KEY_SECRET=<API_KEY_SECRET>
JWT_KEY=<JWT_KEY>
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=meet.home.local
API_KEY_SECRET=<API_KEY_SECRET>
JWT_KEY=<JWT_KEY>
```

---

## References

- <https://github.com/miroslavpejic85/mirotalk>
- <https://www.reddit.com/r/selfhosted/comments/11kt8zi/free_selfhosted_webrtc_alternative_to_zoom_teams>
