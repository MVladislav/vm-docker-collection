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
    - [oauth](#oauth)
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
DOMAIN=news.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8080
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=0.5
RESOURCES_LIMITS_MEMORY=500m
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=1.28.0

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates
TZ=Europe/Berlin
CRON_MIN=3,33
```

#### example short .env (swarm)

```env
DOMAIN=news.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=news.home.local
```

---

## FAQ

### oauth

- [goauthentik setup](https://github.com/MVladislav/vm-docker-collection/tree/main/composer/helper/goauthentik)
- [config example](https://freshrss.github.io/FreshRSS/en/admins/16_OpenID-Connect-Authentik.html)
- [config example](https://goauthentik.io/integrations/services/freshrss/)

---

## References

- <https://freshrss.org/>
- <https://github.com/FreshRSS/FreshRSS>
- <https://github.com/FreshRSS/FreshRSS/tree/edge/Docker>
