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
  - [Helper](#helper)
    - [verify healthcheck](#verify-healthcheck)
    - [access docker in swarm mode](#access-docker-in-swarm-mode)
    - [some more useful commands](#some-more-useful-commands)
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
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=<HOST>.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=https
PORT=443
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
# 500m | 1g | ...
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=latest

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
# NOTE: extend additional info here ...
```

#### example short .env (swarm)

```env
DOMAIN=<HOST>.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=<HOST>.home.local
```

---

## Helper

### verify healthcheck

```sh
$docker inspect --format "{{json .State.Health }}" <CONTAINER_NAME> | jq
```

### access docker in swarm mode

```sh
$docker exec -it "$(docker ps -q -f name=<SERVICE_NAME>)" <COMMAND>
```

### some more useful commands

```sh
# stop all containers
$docker stop $(docker ps -a -q)
# remove all containers
$docker rm $(docker ps -a -q)

# for debugs and faster cleanups also
# remove all containers
$docker volume rm $(docker volume ls -qf dangling=true)
```

---

## References

- <https://docs.docker.com/compose/compose-file/compose-file-v3/#configs>
- <https://docs.docker.com/engine/swarm/secrets/>
- <https://docs.docker.com/compose/use-secrets/>
- <https://...>
