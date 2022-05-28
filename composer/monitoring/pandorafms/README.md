# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [References](#references)

---

## basic

> defined to work with treafik

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=latest

LB_SWARM=true
DOMAIN=pandora.home.local
PROTOCOL=http
PORT=80
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

DBHOST = mysql
DBPORT = 3306

DBNAME = pandora
DBUSER = pandora
DBPASS = pandora

INSTANCE_NAME = pandora01
PUBLICURL = ""
SLEEP = 5
RETRIES = 10
```

---

## References

- <https://hub.docker.com/r/pandorafms/pandorafms-open-stack-el8>
