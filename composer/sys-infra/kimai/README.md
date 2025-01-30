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
  - [FAQ](#faq)
    - [login](#login)
    - [oauth](#oauth)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
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
DOMAIN=kimai.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8001
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=0.5
RESOURCES_LIMITS_MEMORY=500m
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_KIMAI=apache-2.28.0
VERSION_MARIADB=11.6.2

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
DB_PASS=$(cat config/secrets/mariadb_user_password.txt)

# https://www.kimai.org/documentation/emails.html
MAILER_FROM=changeme@example.com
MAILER_URL=smtps://{username}:{password}@{smtp-host}:465
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=kimai.home.local

DB_PASS=$(cat config/secrets/mariadb_user_password.txt)
```

---

## FAQ

### login

On initial setup you need to assign the first user manually an admin roles:

```sh
$docker exec -it "$(docker ps -q -f name=kimai_kimai)" /opt/kimai/bin/console kimai:user:create admin 'admin@home.local' ROLE_SUPER_ADMIN
```

### oauth

- [goauthentik setup](https://github.com/MVladislav/vm-docker-collection/tree/main/composer/helper/goauthentik)
- [config example](https://www.kimai.org/documentation/saml-authentik.html)
- [config example](https://goauthentik.io/integrations/services/kimai/)

---

## References

- <https://hub.docker.com/r/kimai/kimai2>
- <https://github.com/kimai/kimai>
- <https://www.kimai.org/documentation/docker-compose.html>
