# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

```sh
pwgen -s 18 1 > config/secrets/mariadb_user_password.txt
pwgen -s 32 1 > config/secrets/mariadb_root_password.txt
pwgen -s 18 1 > config/secrets/paperless_admin_password.txt
pwgen -s 18 1 > config/secrets/paperless_secret_key.txt
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
DOMAIN=paperless.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8000
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=4
RESOURCES_LIMITS_MEMORY=4g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_MARIADB=2
RESOURCES_LIMITS_MEMORY_MARIADB=512m
RESOURCES_RESERVATIONS_CPUS_MARIADB=0.001
RESOURCES_RESERVATIONS_MEMORY_MARIADB=32m

RESOURCES_LIMITS_CPUS_VALKEY=2
RESOURCES_LIMITS_MEMORY_VALKEY=1G
RESOURCES_RESERVATIONS_CPUS_VALKEY=0.001
RESOURCES_RESERVATIONS_MEMORY_VALKEY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_PAPERLESS=2.14
#VERSION_GOTENBERG=8.17
#VERSION_TIKA=3.1.0.0
VERSION_MARIADB=13.0.2
VERSION_VALKEY=9.1.2-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
PAPERLESS_OCR_LANGUAGES=eng+deu

NAS_HOST=<NAS_HOST>
NAS_USERNAME=<NAS_USERNAME>
NAS_PASSWORD=<NAS_PASSWORD>

```

#### example short .env

```env
DOMAIN=paperless.home.local

NAS_HOST=<NAS_HOST>
NAS_USERNAME=<NAS_USERNAME>
NAS_PASSWORD=<NAS_PASSWORD>
```

---

## References

- <https://github.com/paperless-ngx/paperless-ngx>
- <https://github.com/paperless-ngx/paperless-ngx/tree/main/docker/compose>
