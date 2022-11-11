# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [info](#info)
  - [References](#references)

---

## basic

> defined to work with treafik

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=22.4.03

LB_SWARM=true
DOMAIN=openvas.home.local
PROTOCOL=http
PORT=9392
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

GMP=9390
ADMIN_PASSWORD=admin
ADMIN_USERNAME=admin
RELAYHOST=172.17.0.1
SMTPPORT=25
REDISDBS=512
QUIET=false
NEWDB=false
SKIPSYNC=true
RESTORE=false
DEBUG=false
HTTPS=false
```

## info

default credentials:

- username: **admin**
- password: **admin**

change password:

```sh
$docker-compose exec openvas gvmd --user=admin --new-password=<PASSWORD>
```

---

## References

- <https://hub.docker.com/r/immauss/openvas>
- <https://github.com/immauss/openvas>
