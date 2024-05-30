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

## basic

> defined to work with treafik

### create your `secrets`:

```sh
$pwgen -s 32 1 > config/secrets/postgres_password_file.txt
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=openproject.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=https
PORT=443
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=4
RESOURCES_LIMITS_MEMORY=2g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_OPENPROJECT=14-slim
VERSION_MEMCACHED=1.6.27-alpine
VERSION_POSTGRESQL=16.2-alpine3.19

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________

POSTGRES_PASSWORD_TMP=$(cat config/secrets/postgres_password_file.txt)

EMAIL_DELIVERY_METHOD=smtp
SMTP_ADDRESS=<ADD_HERE>
SMTP_PORT=587
SMTP_DOMAIN=<ADD_HERE>
SMTP_AUTHENTICATION=plain
SMTP_USER_NAME=<ADD_HERE>
SMTP_PASSWORD=<ADD_HERE>
SMTP_ENABLE_STARTTLS_AUTO=true
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=openproject.home.local

POSTGRES_PASSWORD_TMP=$(cat config/secrets/postgres_password_file.txt)
```

---

## References

- <https://www.openproject.org/>
- <https://www.openproject.org/docs/installation-and-operations/installation/docker/>
- <https://github.com/opf/openproject-deploy>
  - <https://github.com/opf/openproject-deploy/tree/stable/14/compose>
