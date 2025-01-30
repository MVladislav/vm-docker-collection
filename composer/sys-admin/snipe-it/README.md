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
    - [How-To](#how-to)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$pwgen -s 18 1 > config/secrets/mariadb_user_password.txt
$docker-compose run snipeit php artisan key:generate --show > config/secrets/app_key_password.txt
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
DOMAIN=snipeit.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=80
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
VERSION=v6.3.4
VERSION_MARIADB=11.3.2

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
#...
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=snipeit.home.local
```

---

## References

- <https://snipeitapp.com/>
- <https://github.com/snipe/snipe-it>
- <https://github.com/comoser/snipe-it-docker-compose>
- <https://hub.docker.com/r/linuxserver/snipe-it>

### How-To

- <https://www.youtube.com/watch?v=AmKc0GuQbAU>
