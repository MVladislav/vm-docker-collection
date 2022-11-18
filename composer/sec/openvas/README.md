# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [info](#info)
  - [FAQ](#faq)
  - [References](#references)

---

## basic

> defined to work with treafik

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION_LATEST=latest

# or stable
VERSION_PG_GVM=22.4.0
VERSION_GVMD=22.4.0
VERSION_GSA=22.4.0
VERSION_OSPD_OPENVAS=22.4.0
VERSION_NOTUS_SCANNER=22.4.0

LB_SWARM=true
DOMAIN=openvas.home.local
PROTOCOL=http
PORT=9392
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file
```

## info

default credentials:

- username: **admin**
- password: **admin**

change password:

```sh
$docker-compose exec -u gvmd gvmd gvmd --user=admin --new-password=<PASSWORD>
```

---

## FAQ

- failure when show `0% interrupted`
  - this was happen to me, because my host has disabled IPv6
  - openvas needs the functionality for IPv6, also without connection
  - else it will always fail

---

## References

- <https://greenbone.github.io/docs/latest/22.4/container/index.html>
- <https://hub.docker.com/r/greenbone/openvas-scanner>
- info
  - <https://greenbone.github.io/docs/latest/architecture.html>
  - <https://www.greenbone.net/en/roadmap-lifecycle/>
  - <https://www.greenbone.net/en/open-source-vulnerability-management/>
  - <https://forum.greenbone.net/t/greenbone-community-edition-22-4-stable-initial-release-2022-07-25/12638>
  - <https://secinfo.greenbone.net>
  - <https://forum.greenbone.net/t/about-greenbone-community-feed-gcf/1224>
