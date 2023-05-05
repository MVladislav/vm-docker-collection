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

> defined to work with treafik

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=0.12.1

LB_SWARM=true
DOMAIN=gophish.home.local
PROTOCOL=http
PORT=3333
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file
```

## login credentials

default credentials are printed in log, get it with:

```sh
$docker logs "$(docker ps -q -f name=gophish)"| grep "Please login with"
```

---

## References

- <https://github.com/gophish/gophish>
