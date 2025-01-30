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

**find source and docker-compose on [github](https://github.com/MVladislav/vm-docker-collection/tree/develop/composer/sec/nexpose)**

---

## basic

> defined to work with traefik

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=latest

LB_SWARM=true
DOMAIN=nexpose.home.local
PROTOCOL=https
PORT=3780
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file
```

---

## References

- <https://www.rapid7.com/products/nexpose/request-download/thank-you/>
- <https://download2.rapid7.com/download/InsightVM/Rapid7Setup-Linux64.bin>
  - <https://download2.rapid7.com/download/InsightVM/Rapid7Setup-Linux64.bin.sha512sum>
- <https://docs.rapid7.com/nexpose/install>
