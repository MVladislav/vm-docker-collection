# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [generate api token for web-ui usage](#generate-api-token-for-web-ui-usage)
  - [References](#references)

---

## basic

> defined to work with traefik

### create `.env` file following:

```env
NODE_ROLE=manager
VERSION=latest

LB_SWARM=true
DOMAIN=short.home.local
DOMAIN_SHORT=s.home.local
PROTOCOL=http
PORT=80
PORT_SHORT=8080
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

TZ=Europe/Berlin
IS_HTTPS_ENABLED=true
```

## generate api token for web-ui usage

```sh
$docker exec -it "$(docker ps -q -f name=shlink-short)" shlink api-key:generate
```

---

## References

- <https://hub.docker.com/r/shlinkio/shlink/>
