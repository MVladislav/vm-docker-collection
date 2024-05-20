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
$pwgen -s 32 1 > config/secrets/mariadb_user_password.txt
$pwgen -s 32 1 > config/secrets/app_key_file_password.txt
$echo "mail@example.com" > config/secrets/site_owner_conf.txt
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
DOMAIN=firefly.home.local
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

RESOURCES_LIMITS_CPUS_MARIADB=1
RESOURCES_LIMITS_MEMORY_MARIADB=512M
RESOURCES_RESERVATIONS_CPUS_MARIADB=0.001
RESOURCES_RESERVATIONS_MEMORY_MARIADB=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_FIREFLY=version-6.1.13
VERSION_MARIADB=11.3.2
VERSION_ALPINE=3.19.1

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
STATIC_CRON_TOKEN=$(pwgen -s 32 1)

# OPTIONAL
# https://github.com/firefly-iii/firefly-iii/tree/main/resources/lang
DEFAULT_LANGUAGE=de_DE
DEFAULT_LOCALE=equal
# https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
TZ=Europe/Berlin

# OPTIONAL
# https://docs.firefly-iii.org/how-to/data-importer/advanced/notifications/
MAIL_MAILER=smtp
MAIL_HOST=null
MAIL_PORT=2525
MAIL_FROM=changeme@example.com
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=tls
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=firefly.home.local

VERSION_FIREFLY=version-6.1.13
VERSION_MARIADB=11.3.2
VERSION_ALPINE=3.19.1

STATIC_CRON_TOKEN=$(pwgen -s 32 1)

FIREFLY_III_LAYOUT=v2
```

---

## References

- <https://www.firefly-iii.org/>
- <https://github.com/firefly-iii/firefly-iii>
- <https://github.com/firefly-iii/docker>
