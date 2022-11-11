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
$echo "swordfish" > config/secrets/me_config_basicauth_password.txt
$echo "swordfish" > config/secrets/mongo_initdb_root_password.txt
```

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION_MONGODB=4.2
VERSION_EXPRESS=latest

LB_SWARM=true
DOMAIN=mongodb.home.local
PROTOCOL=http
PORT=8081
# default-secured@file | protected-secured@file | admin-secured@file
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
