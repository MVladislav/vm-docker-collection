# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
  - [Helper](#helper)
    - [verify healthcheck](#verify-healthcheck)
  - [References](#references)

---

## basic

> defined to work with treafik

### create your `secrets`:

```sh
$echo "swordfish" > config/secrets/fireflyiii_password.txt
$echo "swordfish" > config/secrets/mariadb_root_password.txt
$echo "swordfish" > config/secrets/mariadb_user_password.txt
```

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION_FIREFLY=version-6.0.26
VERSION_DB=11.1.2
VERSION_ALPINE=3.18.3

LB_SWARM=true
DOMAIN=firefly.home.local
PROTOCOL=https
PORT=443
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

RESOURCES_LIMITS_CPUS="1"
# 500m | 1g | ...
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS="0.001"
RESOURCES_RESERVATIONS_MEMORY=32m

APP_KEY=SomeRandomStringOf32CharsExactly
SITE_OWNER=mail@example.com

# ______________________________________________________________________________
# OPTIONAL
# https://docs.firefly-iii.org/firefly-iii/advanced-installation/email/#email
MAIL_MAILER=log
MAIL_HOST=null
MAIL_PORT=2525
MAIL_FROM=changeme@example.com
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_SENDMAIL_COMMAND=

# ______________________________________________________________________________
# OPTIONAL set by default
APP_ENV=local # local | production
APP_DEBUG=false

# https://github.com/firefly-iii/firefly-iii/tree/main/resources/lang
DEFAULT_LANGUAGE=de_DE
DEFAULT_LOCALE=equal
# https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
TZ=Europe/Berlin

TRUSTED_PROXIES=**
LOG_CHANNEL=stack
# debug, info, notice, warning, error, critical, alert, emergency
APP_LOG_LEVEL=notice
# info, emergency
AUDIT_LOG_LEVEL=emergency
AUDIT_LOG_CHANNEL=

DB_CONNECTION=mysql
DB_HOST=fireflyiii_db
DB_PORT=3306
DB_DATABASE=firefly
DB_USERNAME=firefly

CACHE_DRIVER=file
SESSION_DRIVER=file
COOKIE_PATH="/"
COOKIE_DOMAIN=
COOKIE_SECURE=false
COOKIE_SAMESITE=lax

SEND_ERROR_MESSAGE=true
SEND_REPORT_JOURNALS=true

ENABLE_EXTERNAL_MAP=false
ENABLE_EXTERNAL_RATES=false

# The map will default to this location:
MAP_DEFAULT_LAT=51.983333
MAP_DEFAULT_LONG=5.916667
MAP_DEFAULT_ZOOM=6

# https://docs.firefly-iii.org/firefly-iii/advanced-installation/authentication
AUTHENTICATION_GUARD=web
AUTHENTICATION_GUARD_HEADER=REMOTE_USER
AUTHENTICATION_GUARD_EMAIL=
PASSPORT_PRIVATE_KEY=
PASSPORT_PUBLIC_KEY=
DISABLE_FRAME_HEADER=false
DISABLE_CSP_HEADER=false
ALLOW_WEBHOOKS=false

# Leave the following configuration vars as is.
# Unless you like to tinker and know what you're doing.
APP_NAME=FireflyIII
BROADCAST_DRIVER=log
QUEUE_DRIVER=sync
CACHE_PREFIX=firefly
PUSHER_KEY=
IPINFO_TOKEN=
PUSHER_SECRET=
PUSHER_ID=
DEMO_USERNAME=
DEMO_PASSWORD=
FIREFLY_III_LAYOUT=v1

APP_URL=http://localhost
```

---

## References

- <https://www.firefly-iii.org/>
- <https://github.com/firefly-iii/firefly-iii>
