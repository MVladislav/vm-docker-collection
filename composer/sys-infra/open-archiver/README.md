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
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$pwgen -s 32 1 > config/secrets/postgres_password_file.txt

$echo "DB_PASSWORD=$(cat config/secrets/postgres_password_file.txt)" >> .env
$echo "JWT_SECRET=$(pwgen -s 32 1)" >> .env
$echo "ENCRYPTION_KEY=$(pwgen -s 32 1)" >> .env
$echo "MEILI_MASTER_KEY=$(pwgen -s 32 1)" >> .env
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
DOMAIN=archiver.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=3000
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_OPEN_ARCHIVER=latest
VERSION_MEILISEARCH=latest
VERSION_POSTGRESQL=17.5-alpine
VERSION_VALKEY=8.1.0-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
# NOTE: extend additional info here ...
```

#### example short .env (swarm)

```env
DOMAIN=archiver.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=archiver.home.local
```

---

## References

- <https://openarchiver.com/>
- <https://github.com/LogicLabs-OU/OpenArchiver>
  - <https://github.com/LogicLabs-OU/OpenArchiver/blob/main/docker-compose.yml>
  - <https://github.com/LogicLabs-OU/OpenArchiver/blob/main/.env.example>
- <https://www.meilisearch.com/>
- <https://github.com/meilisearch/meilisearch>
  - <https://www.meilisearch.com/docs/learn/self_hosted/configure_meilisearch_at_launch#environment-variable>
