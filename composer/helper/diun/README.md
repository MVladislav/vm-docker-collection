# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [References](#references)

---

## basic

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=0.5
RESOURCES_LIMITS_MEMORY=250m
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=4.29

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
TZ=Europe/Berlin

LOG_LEVEL=info
LOG_JSON=false

DIUN_WATCH_WORKERS=20
DIUN_WATCH_SCHEDULE=0 */6 * * *
DIUN_WATCH_JITTER=30s

DIUN_PROVIDERS_DOCKER=false
DIUN_PROVIDERS_DOCKER_WATCHBYDEFAULT=false
DIUN_PROVIDERS_SWARM=true
DIUN_PROVIDERS_SWARM_WATCHBYDEFAULT=true

DIUN_NOTIF_WEBHOOK_ENDPOINT=https://...
DIUN_NOTIF_WEBHOOK_METHOD=POST
DIUN_NOTIF_WEBHOOK_HEADERS_content-type=application/json
DIUN_NOTIF_WEBHOOK_TIMEOUT=10s
```

---

## References

- <https://github.com/crazy-max/diun>
- <https://crazymax.dev/diun/>
- <https://crazymax.dev/diun/usage/basic-example/>
