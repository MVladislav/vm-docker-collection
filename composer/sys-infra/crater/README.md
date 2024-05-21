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
  - [References](#references)

---

## basic

> defined to work with treafik

### create your `secrets`:

```sh
$pwgen -s 32 1 > config/secrets/app_key_password.txt
$pwgen -s 32 1 > config/secrets/mariadb_user_password.txt
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
DOMAIN=crater.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8080
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
VERSION_CRATER=latest
VERSION_MARIADB=11.3
VERSION_NGNIX=1.25-alpine-slim

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
# NOTE: extend additional info here ...
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=crater.home.local
```

## Helper

after run application, you need create a key as follow:

```sh
$docker exec -it "$(docker ps -q -f name=crater_crater)" composer install --no-interaction --prefer-dist --optimize-autoloader
$docker exec -it "$(docker ps -q -f name=crater_crater)" php artisan storage:link || true
$docker exec -it "$(docker ps -q -f name=crater_crater)" php artisan key:generate
```

---

## References

- <https://crater.financial/>
- <https://github.com/crater-invoice/crater>
- <https://docs.craterapp.com/installation.html#docker-installation>
  - <https://github.com/crater-invoice/crater/blob/master/docker-compose.yml>
