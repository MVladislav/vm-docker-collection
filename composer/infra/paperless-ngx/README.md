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
$openssl rand -base64 18 > config/secrets/mariadb_password_file.txt
$openssl rand -base64 18 > config/secrets/mariadb_root_password_file.txt
$openssl rand -base64 18 > config/secrets/paperless_admin_password_file.txt
$openssl rand -base64 18 > config/secrets/paperless_secret_key.txt
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
DOMAIN=paperless.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8000
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
VERSION_PAPERLESS=1.17.4
VERSION_MARIADB=11.2.2
VERSION_REDIS=7.2.3-alpine
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=paperless.home.local

VERSION_PAPERLESS=1.17.4
VERSION_MARIADB=11.2.2
VERSION_REDIS=7.2.3-alpine
```

---

## References

- <https://hub.docker.com/r/paperlessngx/paperless-ngx>
- <https://github.com/paperless-ngx/paperless-ngx>
- <https://github.com/paperless-ngx/paperless-ngx/tree/main/docker/compose>
