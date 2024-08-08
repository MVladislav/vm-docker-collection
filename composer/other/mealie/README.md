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
$pwgen -s 18 1 > config/secrets/postgres_password_file.txt

# tmp solution as _FILE secret not current available
# current db secret implementation makes no sense...
# https://github.com/mealie-recipes/mealie/pull/3781
$grep -q '^POSTGRES_PASSWORD_TMP=' .env && \
sed -i "s/^POSTGRES_PASSWORD_TMP=.*/POSTGRES_PASSWORD_TMP=$(cat config/secrets/postgres_password_file.txt)/" .env || \
echo "POSTGRES_PASSWORD_TMP=$(cat config/secrets/postgres_password_file.txt)" >> .env
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
DOMAIN=food.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=9925
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
VERSION_MEALIE=v1.11.0
VERSION_POSTGRESQL=16.3-alpine3.20

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
# ...
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=food.home.local
```

---

## References

- <https://github.com/mealie-recipes/mealie>
- <https://github.com/mealie-recipes/mealie/blob/mealie-next/docker/docker-compose.yml>
- <https://docs.mealie.io/documentation/getting-started/installation/installation-checklist/>
- <https://docs.mealie.io/documentation/getting-started/installation/backend-config/#general>
