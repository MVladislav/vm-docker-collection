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

> defined to work with treafik

### create your `secrets`:

```sh
$echo "swordfish" > config/secrets/secret_key_secret.txt
$echo "swordfish" > config/secrets/postgres_password_secret.txt
$echo "swordfish" > config/secrets/redis_password_secret.txt
$echo "swordfish" > config/secrets/superuser_password_secret.txt
```

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=v3.4
VERSION_POSTGRES=15.2-alpine
VERSION_REDIS=7-alpine

LB_SWARM=true
DOMAIN=netbox.home.local
PROTOCOL=http
PORT=8080
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

SECRET_KEY=
POSTGRES_PASSWORD=
REDIS_PASSWORD=

SKIP_SUPERUSER=false
#SUPERUSER_API_TOKEN=
#SUPERUSER_EMAIL=
SUPERUSER_NAME=groot
SUPERUSER_PASSWORD=
```

---

## References

- <https://hub.docker.com/r/netboxcommunity/netbox>
- <https://github.com/netbox-community/netbox-docker>
