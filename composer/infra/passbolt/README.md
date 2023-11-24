# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
  - [on first start](#on-first-start)
  - [References](#references)

---

## basic

> defined to work with treafik

### create your `secrets`:

```sh
$echo "swordfish" > config/secrets/db_password_file_secret.txt
```

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=3.9.0-2-ce
# VERSION=3.9.0-2-ce-non-root

LB_SWARM=true
DOMAIN=passbolt.home.local
PROTOCOL=http
PORT=80
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

DB_HOST=mysql
DB_DATABASE=passbolt
DB_USERNAME=passbolt

EMAIL_DEFAULT_FROM=
EMAIL_TRANSPORT_DEFAULT_HOST=
EMAIL_TRANSPORT_DEFAULT_PORT=587
EMAIL_TRANSPORT_DEFAULT_USERNAME=
EMAIL_TRANSPORT_DEFAULT_PASSWORD=
EMAIL_TRANSPORT_DEFAULT_TLS=true
```

---

## on first start

create admin user:

> registration command will return a single use url required to continue the web browser setup

```sh
$docker exec -it $(docker container ls -f=name=passbolt -q) su -m -c \
'DATASOURCES_DEFAULT_PASSWORD=$(cat $DATASOURCES_DEFAULT_PASSWORD_FILE) \
/usr/share/php/passbolt/bin/cake \
passbolt register_user \
-u <your@email.com> \
-f <yourname> \
-l <surname> \
-r admin' -s /bin/sh www-data
```

---

## References

- <https://www.passbolt.com/>
- <https://www.passbolt.com/ce/docker>
- <https://help.passbolt.com/hosting/install/ce/docker.html>
- <https://hub.docker.com/r/passbolt/passbolt>
