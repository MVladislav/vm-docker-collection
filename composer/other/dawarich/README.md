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
  - [Helper](#helper)
    - [Default Credentials](#default-credentials)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$pwgen -s 32 1 > config/secrets/postgres_password_file.txt
$echo "DATABASE_PASSWORD=$(cat config/secrets/postgres_password_file.txt)" >> .env
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
DOMAIN=dawarich.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=3000
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=0.50
RESOURCES_LIMITS_MEMORY=4g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_DAWARICH=0.23.5
VERSION_POSTGRESQL=17.2-alpine
VERSION_VALKEY=8.0.2-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
POSTGRES_DB=postgresql
POSTGRES_USER=postgresql

MIN_MINUTES_SPENT_IN_CITY=60

BACKGROUND_PROCESSING_CONCURRENCY=10

RAILS_ENV=production
# TIME_ZONE=Europe/Berlin
DOMAIN?domain variable not set
APPLICATION_PROTOCOL=http
DISTANCE_UNIT=km
PROMETHEUS_EXPORTER_ENABLED=false
PROMETHEUS_EXPORTER_PORT=9394
ENABLE_TELEMETRY=false
SECRET_KEY_BASE=1234567890
RAILS_LOG_TO_STDOUT=true
```

#### example short .env

```env
DOMAIN=dawarich.home.local
```

---

## Helper

### Default Credentials

- Username: `demo@dawarich.app`
- Password: `password` # pragma: allowlist secret

---

## References

- <https://github.com/Freika/dawarich>
- <https://github.com/Freika/dawarich/blob/master/docker/docker-compose.yml>
- <https://github.com/AlbinLind/dawarich-home-assistant>
- <https://www.youtube.com/watch?v=0f7Qi_aybhQ>
