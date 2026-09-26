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

> defined to work with traefik

### database setup

This stack ships **no database**; it joins the external `mysql` network. Deploy
a MariaDB stack separately (see the `mariadb` service in
[`__template/docker-compose-example-services.yaml`](../../__template/docker-compose-example-services.yaml)),
attach it to that network, and create the `pandora` database and user there:

```sh
docker network create --driver overlay --attachable mysql
```

`DBHOST = mysql` below is the MariaDB service name on that network.

### create `.env` file following:

```env
NODE_ROLE=manager

VERSION=latest

LB_SWARM=true
DOMAIN=pandora.home.local
PROTOCOL=http
PORT=80
# default-secured@file | public-whitelist@file | authentik@file
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
