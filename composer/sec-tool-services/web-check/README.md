# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [References](#references)

---

## basic

> defined to work with traefik

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=web-check.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=3000
# default-secured@file | public-whitelist@file | authentik@file
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
GOOGLE_CLOUD_API_KEY=<CHANGEME>
REACT_APP_SHODAN_API_KEY=<CHANGEME>
REACT_APP_WHO_API_KEY=<CHANGEME>
SECURITY_TRAILS_API_KEY=<CHANGEME>
CLOUDMERSIVE_API_KEY=<CHANGEME>
TRANCO_USERNAME=<CHANGEME>
TRANCO_API_KEY=<CHANGEME>
URL_SCAN_API_KEY=<CHANGEME>
BUILT_WITH_API_KEY=<CHANGEME>
TORRENT_IP_API_KEY=<CHANGEME>
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=web-check.home.local
VERSION=latest

PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
```

---

## References

- <https://github.com/Lissy93/web-check>
