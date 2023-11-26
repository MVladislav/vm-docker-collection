# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
  - [Other](#other)
  - [References](#references)

---

## basic

> defined to work with treafik

### create your `secrets`:

```sh
$openssl rand -base64 18 > config/secrets/me_config_basicauth_password.txt
$openssl rand -base64 18 > config/secrets/mongo_initdb_root_password.txt
```

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION_MONGODB=6.0.6
VERSION_EXPRESS=0.54.0

LB_SWARM=true
DOMAIN=mongodb.home.local
PROTOCOL=http
PORT=8081
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

TZ=Europe/Berlin
ME_CONFIG_BASICAUTH_USERNAME=admin
MONGO_INITDB_ROOT_USERNAME=root
```

## Other

create user with database access:

```sh
$docker exec -it "$(docker ps -q -f name=mongodb_mongodb)" mongosh --port 27017 --authenticationDatabase "admin" -u "root" -p
```

```mongodb
use graylog
db.createUser(
  {
    user: "graylog",
    pwd:  passwordPrompt(),   // or cleartext password
    roles: [ { role: "readWrite", db: "graylog" } ]
  }
)
```

---

## References

- <https://hub.docker.com/_/mongo/>
