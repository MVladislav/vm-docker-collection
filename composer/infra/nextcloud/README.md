# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
  - [References](#references)

---

## basic

> defined to work with treafik

### create your `secrets`:

```sh
$echo "swordfish" > config/secrets/nextcloud_admin_password.txt
$echo "swordfish" > config/secrets/mysql_password.txt
```

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=25.0.0-apache

LB_SWARM=true
DOMAIN=nextcloud.home.local
PROTOCOL=http
PORT=80
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file
```

---

## References

- <https://hub.docker.com/_/nextcloud>
