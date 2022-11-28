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
DOMAIN=wireguard.home.local
PROTOCOL=http
PORT=51821
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

WG_PORT=51820

PASSWORD=swordfish

WG_DEFAULT_ADDRESS=10.6.6.x
WG_DEFAULT_DNS=1.1.1.1
WG_ALLOWED_IPS=0.0.0.0/0,::/0
```

---

## References

- <https://github.com/WeeJeWel/wg-easy>
- <https://github.com/WeeJeWel/wg-easy/blob/master/docker-compose.yml>
- <https://hub.docker.com/r/weejewel/wg-easy>
