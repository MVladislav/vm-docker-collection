# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$openssl rand -base64 18 > config/secrets/mariadb_root_password.txt
$openssl rand -base64 18 > config/secrets/mariadb_user_password.txt
```

### create `.env` file following:

```env
NODE_ROLE=manager

VERSION_BITWARDEN=latest
VERSION_MARIADB=10.7.8

LB_SWARM=true
DOMAIN=bitwarden.home.local
PROTOCOL=http
PORT=8080
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# same as defined in 'config/secrets/mariadb_user_password.txt'
BW_DB_PASSWORD=<PASSWORD>

# Installation information
# Get your ID and key from https://bitwarden.com/host/
BW_INSTALLATION_ID=00000000-0000-0000-0000-000000000000
BW_INSTALLATION_KEY=xxxxxxxxxxxx

TZ=Europe/Berlin
MARIADB_DATABASE=bitwarden_vault
MARIADB_USER=bitwarden

# Mail
globalSettings__mail__replyToEmail=test@example.io
globalSettings__mail__smtp__host=smtphost.example.io
globalSettings__mail__smtp__port=465
globalSettings__mail__smtp__ssl=true
globalSettings__mail__smtp__username=test@example.io
globalSettings__mail__smtp__password=smtppassword

# Services
# Some services, namely for enterprise use cases, are disabled by default. Defaults shown below.
BW_ENABLE_ADMIN=true
BW_ENABLE_API=true
BW_ENABLE_EVENTS=true
BW_ENABLE_ICONS=true
BW_ENABLE_IDENTITY=false
BW_ENABLE_NOTIFICATIONS=true
BW_ENABLE_SCIM=false
BW_ENABLE_SSO=false
```

---

## References

- <https://bitwarden.com/help/install-on-premise-manual/>
- <https://github.com/bitwarden/server/blob/master/docker-unified/docker-compose.yml>
- <https://hub.docker.com/_/mariadb>
- <https://github.com/MariaDB/mariadb-docker/issues/94>
