# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
    - [create self signed tls cert](#create-self-signed-tls-cert)
  - [References](#references)

---

## basic

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=latest
PORT=8086

DOCKER_INFLUXDB_INIT_MODE=setup
DOCKER_INFLUXDB_INIT_USERNAME=root
DOCKER_INFLUXDB_INIT_PASSWORD=swordfish
DOCKER_INFLUXDB_INIT_ORG=my_orga
DOCKER_INFLUXDB_INIT_BUCKET=db0
```

### create self signed tls cert

```sh
$openssl req -x509 -nodes -newkey rsa:2048 \
-keyout $PWD/config/ssl/influxdb-selfsigned.key \
-out $PWD/config/ssl/influxdb-selfsigned.crt \
-days 999 \
-subj "/C=DE/ST=BW/L=A/O=VM/OU=VM/CN=home.local"
```

## References

- <https://www.influxdata.com/>
- <https://hub.docker.com/_/influxdb>
