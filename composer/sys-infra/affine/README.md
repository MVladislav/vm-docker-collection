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

> defined to work with traefik

### create your `secrets`:

```sh
$pwgen -s 18 1 > config/secrets/postgres_password_file.txt
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
DOMAIN=affine.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=3010
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=2
RESOURCES_LIMITS_MEMORY=2g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_AFFINE=stable-129ccea
VERSION_VALKEY=8.0.1-alpine
VERSION_POSTGRESQL=17.1-alpine3.20

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
AFFINE_ADMIN_EMAIL=<ADMIN_EMAIL>
AFFINE_ADMIN_PASSWORD=<ADMIN_PASSWORD>
POSTGRES_PASSWORD_TMP=<PASSWORD - cat config/secrets/postgres_password_file.txt>
```

#### example short .env

```env
DOMAIN=affine.home.local

AFFINE_ADMIN_EMAIL=<ADMIN_EMAIL>
AFFINE_ADMIN_PASSWORD=<ADMIN_PASSWORD>
POSTGRES_PASSWORD_TMP=<PASSWORD - cat config/secrets/postgres_password_file.txt>
```

---

## References

- <https://affine.pro/>
- <https://github.com/toeverything/AFFiNE/tree/canary>
- <https://github.com/toeverything/AFFiNE/blob/canary/.github/deployment/self-host/compose.yaml>
- <https://docs.affine.pro/docs/self-host-affine>
- <https://docs.affine.pro/docs/self-host-affine/run-affine-with-custom-options>
