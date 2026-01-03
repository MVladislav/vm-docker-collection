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
$echo "PENPOT_DATABASE_PASSWORD=$(cat config/secrets/postgres_password_file.txt)" >> .env
$echo "PENPOT_SECRET_KEY=$(pwgen -s 64 1)" >> .env
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
DOMAIN=penpot.home.local # not set in docker-compose, needs to be copied to .env
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
VERSION_PENPOT=2.12.1
VERSION_POSTGRESQL=18.1-alpine
VERSION_VALKEY=9.0.0-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
PENPOT_SECRET_KEY=<randomly generated 512 bits base64 encoded string>
```

#### example short .env (swarm)

```env
DOMAIN=penpot.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=penpot.home.local
```

---

## References

- <https://penpot.app/>
- <https://github.com/penpot/penpot>
  - <https://github.com/penpot/penpot/tree/develop/docker/images>
- <https://help.penpot.app/technical-guide/getting-started/#install-with-docker>
  - <https://help.penpot.app/technical-guide/getting-started/docker/>
