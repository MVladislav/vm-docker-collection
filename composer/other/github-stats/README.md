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
  - [FAQ](#faq)
    - [github-readme-stats](#github-readme-stats)
    - [github-readme-streak-stats](#github-readme-streak-stats)
    - [github-profile-trophy](#github-profile-trophy)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$pwgen -s 32 1 > config/secrets/token_secret.txt
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
DOMAIN=github-stats.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=80
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
VERSION=latest

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
# NOTE: extend additional info here ...
```

#### example short .env (swarm)

```env
DOMAIN=github-stats.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=github-stats.home.local
```

---

## FAQ

### github-readme-stats

```plain
$DOMAIN/stats/api?username=mvladislav
```

### github-readme-streak-stats

```plain
$DOMAIN/streak/?user=mvladislav
```

### github-profile-trophy

```plain
$DOMAIN/trophy/?username=mvladislav
```

---

## References

- <https://github.com/anuraghazra/github-readme-stats>
- <https://github.com/DenverCoder1/github-readme-streak-stats>
- <https://github.com/ryo-ma/github-profile-trophy>
