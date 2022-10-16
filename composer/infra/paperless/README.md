# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
  - [create user](#create-user)
  - [References](#references)

---

## basic

> defined to work with treafik

### create your `secrets`:

```sh
$echo "paperless" > config/secrets/postgres_password.txt
```

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
