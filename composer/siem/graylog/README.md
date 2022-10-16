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

TODO: define source to start elasticsearch and mongodb

### create your `secrets`:

```sh
#: 'must be at least 16 characters!'
#$echo "swordfishswordfish" > config/secrets/graylog_password_secret.txt
$echo -n 'swordfish' | sha256sum | awk '{ print $1 }' > config/secrets/graylog_root_password_sha2.txt
```

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=4.3

LB_SWARM=true
DOMAIN=graylog.home.local
PROTOCOL=http
PORT=9000
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

GRAYLOG_PASSWORD_SECRET=swordfishswordfish

GRAYLOG_HTTP_EXTERNAL_URI=http://127.0.0.1:9000/
GRAYLOG_TRANSPORT_EMAIL_ENABLED=true
GRAYLOG_TRANSPORT_EMAIL_HOSTNAME=smtp
GRAYLOG_TRANSPORT_EMAIL_PORT=465
GRAYLOG_TRANSPORT_EMAIL_USE_AUTH=true
GRAYLOG_TRANSPORT_EMAIL_USE_TLS=true
GRAYLOG_TRANSPORT_EMAIL_USE_SSL=false
```

---

## References

- <https://www.graylog.org/>
- <https://hub.docker.com/r/graylog/graylog>
- <https://docs.graylog.org/docs/docker>
- <https://www.youtube.com/watch?v=rtfj6W5X0YA>
