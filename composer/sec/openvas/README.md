# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [info](#info)
  - [useful log checks](#useful-log-checks)
  - [Performing a Manual Feed Sync (TODO)](#performing-a-manual-feed-sync-todo)
  - [gvm-tools](#gvm-tools)
  - [FAQ](#faq)
  - [References](#references)

---

## basic

> defined to work with traefik

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=openvas.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=80
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_LATEST=latest

VERSION_PG_GVM=stable        # 22.4.0
VERSION_GVMD=stable          # 22.4.0
VERSION_GSA=stable           # 22.4.0
VERSION_OSPD_OPENVAS=stable  # 22.4.0
VERSION_NOTUS_SCANNER=stable # 22.4.0

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
FEED_RELEASE=24.10
```

#### example short .env

> NOTE: swarm mode seams not to be work.

```env
NETWORK_MODE=overlay
DOMAIN=openvas.home.local
LB_SWARM=false
```

## info

default credentials:

- username: **admin**
- password: **admin**

change password:

```sh
$docker-compose exec -u gvmd gvmd gvmd --user=admin --new-password=<PASSWORD>
#$docker exec -it -u gvmd "$(docker ps -q -f name=openvas_gvmd)" gvmd --user=admin --new-password=<PASSWORD>
```

## useful log checks

```sh
: 'see service status update process'
$docker logs -f "$(docker ps -q -f name=gvmd)"

$docker logs -f "$(docker ps -q -f name=gsa)"
$docker logs -f "$(docker ps -q -f name=openvasd)"
$docker logs -f "$(docker ps -q -f name=ospd-openvas)"
$docker logs -f "$(docker ps -q -f name=openvas-openvas)"
$docker logs -f "$(docker ps -q -f name=pg-gvm)"
$docker logs -f "$(docker ps -q -f name=redis-server)"

$docker logs -f "$(docker ps -q -f name=openvas)"
$docker logs -f "$(docker ps -q -f name=vulnerability-tests)"
```

## Performing a Manual Feed Sync (TODO)

```sh
$docker-compose exec greenbone-feed-sync greenbone-feed-sync greenbone-feed-sync --type nasl
$docker-compose exec greenbone-feed-sync greenbone-feed-sync greenbone-feed-sync --type notus
$docker-compose exec greenbone-feed-sync greenbone-feed-sync greenbone-feed-sync --type scap
$docker-compose exec greenbone-feed-sync greenbone-feed-sync greenbone-feed-sync --type cert
$docker-compose exec greenbone-feed-sync greenbone-feed-sync greenbone-feed-sync --type gvmd-data

# $docker exec -it "$(docker ps -q -f name=greenbone-feed-sync)" greenbone-feed-sync greenbone-feed-sync --type nasl
# $docker exec -it "$(docker ps -q -f name=greenbone-feed-sync)" greenbone-feed-sync greenbone-feed-sync --type notus
# $docker exec -it "$(docker ps -q -f name=greenbone-feed-sync)" greenbone-feed-sync greenbone-feed-sync --type scap
# $docker exec -it "$(docker ps -q -f name=greenbone-feed-sync)" greenbone-feed-sync greenbone-feed-sync --type cert
# $docker exec -it "$(docker ps -q -f name=greenbone-feed-sync)" greenbone-feed-sync greenbone-feed-sync --type gvmd-data
```

## gvm-tools

```sh
$docker-compose exec -it gvm-tools bash
#$docker exec -it "$(docker ps -q -f name=gvm-tools)" bash
```

---

## FAQ

- IPv6:: failure when show `0% interrupted`
  - this was happen to me, because my host has disabled IPv6
  - openvas needs the functionality for IPv6, also without connection
  - else it will always fail
- Boreas:: failure when show `0% interrupted`
  - <https://forum.greenbone.net/t/failed-to-open-icmpv4-socket-operation-not-permitted/13791/9>
  - `$docker exec -it  "$(docker ps -q -f name=openvas_ospd-openvas)" bash`
    - `# $echo "test_alive_hosts_only = no" >> /etc/openvas/openvas.conf`

---

## References

- <https://greenbone.github.io/docs/latest/22.4/container/index.html>
- <https://hub.docker.com/r/greenbone/openvas-scanner>
- <https://greenbone.github.io/docs/latest/22.4/container/workflows.html#loading-the-feed-changes>
- <https://greenbone.github.io/docs/latest/22.4/container/workflows.html#performing-a-manual-feed-sync>
  - <https://github.com/greenbone/greenbone-feed-sync/>
- info
  - <https://greenbone.github.io/docs/latest/architecture.html>
  - <https://www.greenbone.net/en/roadmap-lifecycle/>
  - <https://www.greenbone.net/en/open-source-vulnerability-management/>
  - <https://forum.greenbone.net/t/greenbone-community-edition-22-4-stable-initial-release-2022-07-25/12638>
  - <https://secinfo.greenbone.net>
  - <https://forum.greenbone.net/t/about-greenbone-community-feed-gcf/1224>
  - <https://forum.greenbone.net/t/scan-config-cant-be-created-failed-to-find-config-daba56c8-73ec-11df-a475-002264764cea/8938/18>
