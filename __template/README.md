# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
  - [Helper](#helper)
    - [verify healthcheck](#verify-healthcheck)
  - [References](#references)

---

## basic

> defined to work with treafik

### create your `secrets`:

```sh
$echo "swordfish" | docker secret create my_external_secret -
$echo "swordfish" > config/secrets/my_file_secret.txt
```

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=latest

LB_SWARM=true
DOMAIN=<HOST>.home.local
PROTOCOL=https
PORT=443
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

RESOURCES_LIMITS_CPUS=1
# 500m | 1g | ...
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m
```

---

## Helper

### verify healthcheck

```sh
$docker inspect --format "{{json .State.Health }}" <CONTAINER_NAME> | jq
```

---

## References

- <https://docs.docker.com/compose/compose-file/compose-file-v3/#configs>
- <https://docs.docker.com/engine/swarm/secrets/>
- <https://...>
