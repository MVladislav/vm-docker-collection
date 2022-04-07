# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [conf](#conf)
  - [References](#references)

---

## basic

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=9

LB_SWARM=true
DOMAIN=teleport.home.local
PROTOCOL=https
PORT=443
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file
```

## conf

create a user for login:

```sh
$docker exec <CONTAINER> tctl users add teleuser --roles=editor,access --logins=root,ubuntu,ansible-admin
```

---

## References

- <https://...>
