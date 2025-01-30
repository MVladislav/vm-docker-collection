# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$pwgen -s 24 1 > config/secrets/postgres_password_file.txt
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=images.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=2283
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS_IMMICH=2
RESOURCES_LIMITS_MEMORY_IMMICH=2G
RESOURCES_RESERVATIONS_CPUS_IMMICH=0.001
RESOURCES_RESERVATIONS_MEMORY_IMMICH=32m

RESOURCES_LIMITS_CPUS_IMMICH_ML=4
RESOURCES_LIMITS_MEMORY_IMMICH_ML=4G
RESOURCES_RESERVATIONS_CPUS_IMMICH_ML=0.001
RESOURCES_RESERVATIONS_MEMORY_IMMICH_ML=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_IMMICH=v1.120.1
VERSION_VALKEY=7.2.5-alpine
VERSION_POSTGRESQL=pg16-v0.3.0

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
# NOTE: extend additional info here ...
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=images.home.local
```

---

## References

- <https://immich.app/>
- <https://github.com/immich-app/immich>
- <https://github.com/immich-app/immich/blob/main/docker/docker-compose.yml>
- <https://immich.app/docs/install/environment-variables>
