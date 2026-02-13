# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env (swarm)](#example-short-env-swarm)
      - [example short .env (bridge)](#example-short-env-bridge)
  - [FAQ](#faq)
    - [Reset SuperUser password](#reset-superuser-password)
  - [References](#references)

---

## basic

> defined to work with traefik

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=beszel.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8090
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
VERSION=0.18.3
VERSION_AGENT=0.18.3-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates
MFA_OTP=true # you need first setup SMTP inside PocketBase

# Agent
AGENT_TYPE= # -nvidia | -intel
```

#### example short .env (swarm)

```env
DOMAIN=beszel.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=beszel.home.local
```

## FAQ

### Reset SuperUser password

```
$docker exec -it "$(docker ps -q -f name=^beszel_beszel\\.)" /beszel superuser upsert <MAIL> <PASSWORD>
```

---

## References

- <https://github.com/henrygd/beszel>
- <https://github.com/henrygd/beszel/blob/main/supplemental/docker/same-system/docker-compose.yml>
