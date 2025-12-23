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
  - [Notes](#notes)
    - [Default credentials](#default-credentials)
    - [Get a list of nearby servers](#get-a-list-of-nearby-servers)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$echo "APP_KEY=$(pwgen -s 32 1)" >> .env
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
DOMAIN=net.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=80
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=2
RESOURCES_LIMITS_MEMORY=512m
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=1.13.3

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
ADMIN_NAME=groot
ADMIN_EMAIL=groot@home.local
ADMIN_PASSWORD=swordfish
APP_LOCALE=en
TIMEZONE=Europe/Berlin

SPEEDTEST_SCHEDULE=*/30 * * * *
SPEEDTEST_SERVERS=72996,10291,28818,69359,18613,64247,61058,55133
```

#### example short .env (swarm)

```env
DOMAIN=net.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=net.home.local
```

---

## Notes

### Default credentials

- username: `groot@home.local`
- password: `swordfish` # pragma: allowlist secret

### Get a list of nearby servers

```sh
$docker compose run --rm -it --entrypoint /bin/bash speedtest-tracker list-servers
```

---

## References

- <https://github.com/alexjustesen/speedtest-tracker>
  - <https://docs.speedtest-tracker.dev/getting-started/installation/using-docker-compose>
  - <https://docs.speedtest-tracker.dev/getting-started/environment-variables>
- <https://docs.linuxserver.io/images/docker-speedtest-tracker/#usage>
  - <https://github.com/linuxserver/docker-speedtest-tracker>
  - <https://github.com/linuxserver/docker-speedtest-tracker/pkgs/container/speedtest-tracker>
