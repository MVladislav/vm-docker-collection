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
DOMAIN=nessus.home.local
PROTOCOL=https
PORT=8834
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file
```

---

## References

- <https://hub.docker.com/r/tenableofficial/nessus>
- <https://docs.tenable.com/nessus/Content/DeployNessusDocker.htm>
- <https://www.tenable.com/downloads/nessus?loginAttempted=true>
