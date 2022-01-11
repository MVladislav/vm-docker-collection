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

## References

- <https://www.influxdata.com/>
- <https://hub.docker.com/_/influxdb>
