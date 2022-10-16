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

DISABLE_LOCAL_API=false
AGENT_USERNAME=<USERNAME>
AGENT_PASSWORD=<PASSWORD>
LOCAL_API_URL=http://<HOST>:8080

CROWDSEC_BOUNCER_API_KEY_TRAEFIK=<API_KEY>
CROWDSEC_AGENT_HOST=crowdsec:8080
```

---

## commands for verify

show metrics:

```sh
$docker exec "$(docker ps -q -f name=crowdsec)" cscli metrics
```

check if decisions listed:

```sh
$docker exec "$(docker ps -q -f name=crowdsec)" cscli decisions list
```

install collection:

> some default are always in docker-composer defined

```sh
$docker exec "$(docker ps -q -f name=crowdsec)" cscli collections install crowdsecurity/<collection name>
```

perform updates:

```sh
$docker exec "$(docker ps -q -f name=crowdsec)" cscli hub update
$docker exec "$(docker ps -q -f name=crowdsec)" cscli hub upgrade
```

get api key for bouncer (traefik):

```sh
$docker exec "$(docker ps -q -f name=crowdsec)" cscli bouncers add bouncer-traefik
```

---

## References

- <https://crowdsec.net/blog/secure-docker-compose-stacks-with-crowdsec/>
- <https://github.com/fbonalair/traefik-crowdsec-bouncer>
