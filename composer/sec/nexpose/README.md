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
DOMAIN=nexpose.home.local
PROTOCOL=https
PORT=3780
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file
```

---

## References

- <https://www.rapid7.com/products/nexpose/request-download/thank-you/>
- <https://download2.rapid7.com/download/InsightVM/Rapid7Setup-Linux64.bin>
  - <https://download2.rapid7.com/download/InsightVM/Rapid7Setup-Linux64.bin.sha512sum>
- <https://docs.rapid7.com/nexpose/install>
