# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [additional changes](#additional-changes)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [References](#references)

---

## basic

> defined to work with treafik

### additional changes

When you will run this in **swarm mode** you need to proof if under
`/etc/docker/daemon.json` the property `no-new-privileges` is set to **false**

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
PORT=8080
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=2
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=4.17.1-ubuntu

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
GID=1000
UID=1000
DOCKER_USER=$USER
CONFIG=$PWD/config/config
LOCAL=$PWD/config/local
PROJECT=$PWD/config/project
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=code.home.local

DOCKER_USER=$USER
CONFIG=$PWD/config/config
LOCAL=$PWD/config/local
PROJECT=$PWD/config/project
```

---

## References

- <https://coder.com/>
- <https://github.com/coder/code-server/blob/main/docs/install.md#docker>
- <https://hub.docker.com/r/codercom/code-server>
