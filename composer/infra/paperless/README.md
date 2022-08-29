# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [create user](#create-user)
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
DOMAIN=paper.home.local
PROTOCOL=http
PORT=8000
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

PAPERLESS_REDIS=redis://broker:6379
PAPERLESS_TIKA_ENABLED=1
PAPERLESS_TIKA_GOTENBERG_ENDPOINT=http://gotenberg:3000
PAPERLESS_TIKA_ENDPOINT=http://tika:9998

USERMAP_UID=1000
USERMAP_GID=1000

PAPERLESS_SECRET_KEY=<LONG-SECRET>
PAPERLESS_TIME_ZONE=Europe/Berlin
PAPERLESS_OCR_LANGUAGE=ger
```

## create user

on first startup we need generate an user:

```sh
$docker exec -it "$(docker ps -q -f name=paperless)" python3 manage.py createsuperuser
```

---

## References

- <https://github.com/jonaswinkler/paperless-ng>
- <https://github.com/jonaswinkler/paperless-ng/blob/master/docker/compose/docker-compose.sqlite-tika.yml>
- <https://blog.armbruster-it.de/2019/01/running-paperless-on-freenas/>
