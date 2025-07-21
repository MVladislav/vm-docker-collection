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

> **⚠️ NOT WORKING!**

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$echo "JWT_SECRET=$(openssl rand -base64 64 | tr -d '\n')" >> .env
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
DOMAIN=check.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=80
PROTOCOL_SERVER=http
PORT_SERVER=52345
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_VALKEY=1
RESOURCES_LIMITS_MEMORY_VALKEY=512M
RESOURCES_RESERVATIONS_CPUS_VALKEY=0.001
RESOURCES_RESERVATIONS_MEMORY_VALKEY=32m

RESOURCES_LIMITS_CPUS_MONGODB=1
RESOURCES_LIMITS_MEMORY_MONGODB=512M
RESOURCES_RESERVATIONS_CPUS_MONGODB=0.001
RESOURCES_RESERVATIONS_MEMORY_MONGODB=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_CHECKMATE=v2.3.1
VERSION_VALKEY=8.1.0-alpine
VERSION_MONGODB=8.0.8

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
JWT_SECRET=<SECRET>
PAGESPEED_API_KEY=<https://developers.google.com/speed/docs/insights/v5/get-started>
```

#### example short .env

```env
DOMAIN=check.home.local
```

---

## References

- <https://checkmate.so/>
- <https://github.com/bluewave-labs/Checkmate>
  - <https://github.com/bluewave-labs/Checkmate/tree/develop/docker/dist>
- <https://docs.checkmate.so/users-guide/quickstart>
  - <https://docs.checkmate.so/users-guide/quickstart#env-vars-server>
