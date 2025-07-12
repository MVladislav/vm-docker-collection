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
$cp config/secrets.yaml.tmpl config/secrets.yaml
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
DOMAIN=kestra.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8080
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
VERSION_KESTRA=v0.23.5
VERSION_POSTGRESQL=17.5-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
KESTRA_AUTH_ENABLED=false
KESTRA_USERNAME=groot@home.local
KESTRA_PASSWORD=kestra
```

#### example short .env (swarm)

```env
DOMAIN=kestra.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=kestra.home.local
```

---

## References

- <https://kestra.io/>
- <https://kestra.io/docs/installation/docker-compose>
- <https://github.com/kestra-io/kestra/blob/develop/docker-compose.yml>
