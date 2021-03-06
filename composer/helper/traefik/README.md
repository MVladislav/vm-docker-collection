# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [label setup](#label-setup)
  - [config setup](#config-setup)
  - [References](#references)

---

## basic

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=latest

LB_SWARM=true
DOMAIN=traefik.home.local
PROTOCOL=http
PORT=8080
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=admin-secured@file

USERNAME=traefik
# $(openssl passwd -apr1 $PASSWORD) or $(openssl passwd -apr1)
HASHED_PASSWORD=
```

## label setup

> defined label which needs to be setup per docker-composer,
> also not forget to add network

```yml
labels:
  - traefik.enable=true
  - traefik.docker.lbswarm=true
  - traefik.docker.network=proxy
  - traefik.http.routers.<router_name>.entrypoints=https
  - traefik.http.routers.<router_name>.rule=Host(`${DOMAIN?domain variable not set}`)
  - traefik.http.routers.<router_name>.tls=true
  - traefik.http.routers.<router_name>.service=<router_name>
  - traefik.http.services.<router_name>.loadbalancer.server.scheme=${PROTOCOL:-https}
  - traefik.http.services.<router_name>.loadbalancer.server.port=<port>
  - traefik.http.routers.<router_name>.middlewares=<default-secured@file | protected-secured@file | admin-secured@file>
```

```yml
# ...
networks:
  proxy: {}
# ...
networks:
  proxy:
    external: true
```

## traefik setup

> copy and update the general traefik setup

```sh
$cp ./config/traefik_template.yml ./config/traefik.yml
```

## config setup

> instead or byside to labels you can also define a config.yml

```sh
$cp ./config/config_template.yml ./config/config.yml
```

---

## References

- <https://doc.traefik.io/traefik/user-guides/docker-compose/basic-example/>
- <https://github.com/xcad2k/boilerplates/tree/main/docker-compose/traefik>
- <https://doc.traefik.io/traefik/routing/providers/docker/#tcp-services>
- <https://doc.traefik.io/traefik/reference/dynamic-configuration/file/>
