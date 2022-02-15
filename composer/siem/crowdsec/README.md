# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [commands for verify](#commands-for-verify)
  - [References](#references)

---

## basic

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=latest

DOMAIN=crowdsec.home.local
PORT=80
```

---

## commands for verify

show metrics:

```sh
$docker exec <container> cscli metrics
```

check if decisions listed:

```sh
$docker exec <container> cscli decisions list
```

install collection:

> some default are always in docker-composer defined

```sh
$docker exec <container> cscli collections install crowdsecurity/<collection name>
```

perform updates:

```sh
$docker exec <container> cscli hub update
$docker exec <container> cscli hub upgrade
```

get api key for bouncer (traefik):

```sh
$docker exec <container> cscli bouncers add bouncer-traefik
```

---

## References

- <https://crowdsec.net/blog/secure-docker-compose-stacks-with-crowdsec/>
- <https://github.com/fbonalair/traefik-crowdsec-bouncer>
