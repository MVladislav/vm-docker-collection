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
$pwgen -s 50 1 > config/secrets/postgres_password_file.txt
$echo "DATABASE_PASSWORD=$(cat config/secrets/postgres_password_file.txt)" >> .env

$echo "N8N_ENCRYPTION_KEY=$(pwgen -s 50 1)" >> .env
$echo "N8N_RUNNERS_AUTH_TOKEN=$(pwgen -s 50 1)" >> .env
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
DOMAIN=n8n.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=5678
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=2
RESOURCES_LIMITS_MEMORY=2g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_N8N_WORKER=1
RESOURCES_LIMITS_MEMORY_N8N_WORKER=1g
RESOURCES_RESERVATIONS_CPUS_N8N_WORKER=0.001
RESOURCES_RESERVATIONS_MEMORY_N8N_WORKER=32m

RESOURCES_LIMITS_CPUS_N8N_RUNNER=1
RESOURCES_LIMITS_MEMORY_N8N_RUNNER=1g
RESOURCES_RESERVATIONS_CPUS_N8N_RUNNER=0.001
RESOURCES_RESERVATIONS_MEMORY_N8N_RUNNER=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_N8N=2.3.2
VERSION_VALKEY=9.0.1-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates
```

#### example short .env (swarm)

```env
DOMAIN=n8n.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=n8n.home.local
```

---

## References

- <https://n8n.io>
- <https://github.com/n8n-io/n8n>
- <https://docs.n8n.io/hosting/installation/server-setups/docker-compose>
