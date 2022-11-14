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
SKIPSYNC=false
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
$docker exec $(docker container ls -f=name=openvas -q) gvmd --user=admin --new-password=<PASSWORD>
```

update feeds manual:

```sh
$docker exec $(docker container ls -f=name=openvas -q) runuser -l gvm -c "greenbone-nvt-sync"
$docker exec $(docker container ls -f=name=openvas -q) greenbone-feed-sync --type SCAP
$docker exec $(docker container ls -f=name=openvas -q) greenbone-feed-sync --type CERT
$docker exec $(docker container ls -f=name=openvas -q) greenbone-feed-sync --type GVMD_DATA
```

---

## References

- <https://hub.docker.com/r/immauss/openvas>
- <https://github.com/immauss/openvas>
- info
  - <https://greenbone.github.io/docs/latest/architecture.html>
  - <https://www.greenbone.net/en/roadmap-lifecycle/>
  - <https://www.greenbone.net/en/open-source-vulnerability-management/>
