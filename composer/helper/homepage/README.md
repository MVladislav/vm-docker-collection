# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [Edit configs](#edit-configs)
  - [References](#references)

---

## basic

> defined to work with treafik

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=homepage.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=3000
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=0.2
RESOURCES_LIMITS_MEMORY=250m
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=v0.8.2

# APPLICATION general variable to adjust the apps (optional set by default)
# ______________________________________________________________________________
PUID=1000
PGID=1000
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=homepage.home.local
VERSION=v0.8.2
```

---

## Edit configs

open different files direct in container, for example with:

```sh
$docker exec -u node -it "$(docker ps -q -f name=homepage_homepage)" vi config/bookmarks.yaml
$docker exec -u node -it "$(docker ps -q -f name=homepage_homepage)" vi config/services.yaml
$docker exec -u node -it "$(docker ps -q -f name=homepage_homepage)" vi config/docker.yaml
$docker exec -u node -it "$(docker ps -q -f name=homepage_homepage)" vi config/settings.yaml
$docker exec -u node -it "$(docker ps -q -f name=homepage_homepage)" vi config/widgets.yaml
```

---

## References

- <https://gethomepage.dev/en/installation/docker/>
- <https://github.com/gethomepage/homepage>
