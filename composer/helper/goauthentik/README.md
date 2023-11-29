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
    - [Create first account](#create-first-account)
  - [References](#references)

---

## basic

> defined to work with treafik

### create your `secrets`:

> instead of openssl for password you can also use `pwgen -s 50 1`

```sh
$openssl rand -base64 18 > config/secrets/postgres_password_file.txt
$openssl rand -base64 18 > config/secrets/authentik_secret_key.txt
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
DOMAIN=authentik.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=9000
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
VERSION_GOAUTHENTIK=2023.10.4
VERSION_REDIS=7.2.3-alpine
VERSION_POSTGRESQL=16.1-alpine

# APPLICATION general variable to adjust the apps (OPTIONAL)
# ______________________________________________________________________________
# SMTP Host Emails are sent to
AUTHENTIK_EMAIL__HOST=localhost
AUTHENTIK_EMAIL__PORT=25
# Optionally authenticate (don't add quotation marks to your password)
AUTHENTIK_EMAIL__USERNAME=
AUTHENTIK_EMAIL__PASSWORD=
# Use StartTLS
AUTHENTIK_EMAIL__USE_TLS=false
# Use SSL
AUTHENTIK_EMAIL__USE_SSL=false
AUTHENTIK_EMAIL__TIMEOUT=10
# Email address authentik will send from, should have a correct @domain
AUTHENTIK_EMAIL__FROM=authentik@localhost
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=authentik.home.local
```

---

## FAQ

### Create first account

on initial setup open page under `https://authentik.home.local/if/flow/initial-setup/`

> or what every domain you setup

---

## References

- <https://goauthentik.io/>
- <https://github.com/goauthentik/authentik>
- [passwordless authentication setup example](https://www.youtube.com/watch?v=aEpT2fYGwLw)
- [ldap example setup](https://www.youtube.com/watch?v=RtPKMMKRT_E)
  - <https://goauthentik.io/docs/providers/ldap/generic_setup>
