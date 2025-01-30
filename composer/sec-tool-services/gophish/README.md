# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [login credentials](#login-credentials)
  - [References](#references)

---

## basic

> defined to work with traefik

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=0.12.1

LB_SWARM=true

DOMAIN_ADMIN=gophish.home.local
PROTOCOL_ADMIN=http
PORT_ADMIN=3333
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED_ADMIN=default-secured@file

DOMAINS_PHISH=Host(`phish.home.local`) || Host(`phish2.home.local`) || ...
PROTOCOL_PHISH=http
PORT_PHISH=80
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED_PHISH=default-secured@file
```

## login credentials

default credentials are printed in log, get it with:

```sh
$docker logs "$(docker ps -q -f name=gophish)" | grep "Please login with"
```

---

## References

- <https://github.com/gophish/gophish>
- <https://github.com/gophish/gophish/pull/2301>
- <https://gist.github.com/ismailyenigul/867132f298664156068b6e85847c0dfe>
- <https://github.com/traefik/traefik/issues/7605>
