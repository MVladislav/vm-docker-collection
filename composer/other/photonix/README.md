# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
  - [create credentials](#create-credentials)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$openssl rand -base64 18 > config/secrets/postgres_secret.txt
```

### create `.env` file following:

```env
NODE_ROLE=manager

VERSION=latest

LB_SWARM=true
DOMAIN=photonix.home.local
PROTOCOL=http
PORT=80
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file
```

## create credentials

```sh
$docker-compose run photonix python photonix/manage.py createsuperuser --username admin --email root@home.local
$docker-compose run photonix python photonix/manage.py create_library admin "My Library"
```

---

## References

- <https://github.com/photonixapp/photonix>
