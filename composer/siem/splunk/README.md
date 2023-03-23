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
$echo "swordfish" | docker secret create my_external_secret -
$echo "swordfish" > config/secrets/my_file_secret.txt
```

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=8.2

LB_SWARM=true
DOMAIN=splunk.home.local
PROTOCOL=http
PORT=8000
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file
```

---

## References

- <https://hub.docker.com/r/splunk/splunk/>
- <https://splunk.github.io/docker-splunk/SETUP.html#install>
