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
$echo "swordfish" > config/secrets/papermerge__main__secret_key.txt
$echo "swordfish" > config/secrets/papermerge__database__password.txt
$echo "swordfish" > config/secrets/django_superuser_password.txt
```

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION_PAPERMERGE=2.1.0a38
VERSION_PAPERMERGE_JS=2.1.0a39

LB_SWARM=true
DOMAIN=papermerge.home.local
PROTOCOL_BACKEND=http
PORT_BACKEND=8000
PROTOCOL_FRONTEND=http
PORT_FRONTEND=80
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file
```

---

## References

- <https://docs.papermerge.io/Installation/docker-compose.html>
- <https://github.com/papermerge/papermerge-core>
- <https://github.com/papermerge/papermerge-core/blob/master/docker/docker-compose.yml>
