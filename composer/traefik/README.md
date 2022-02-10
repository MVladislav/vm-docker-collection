# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [label setup](#label-setup)
  - [References](#references)

---

## basic

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=v2.6
PORT_HTTP=80
PORT_HTTPS=443
PORT_GUI=8080
```

## label setup

```yml
labels:
  - traefik.enable=true
  - traefik.docker.lbswarm=true
  - traefik.docker.network=proxy
  - traefik.http.routers.<router_name>.entrypoints=https
  - traefik.http.routers.<router_name>.rule=Host(`<router_name>.home.local`)
  - traefik.http.routers.<router_name>.tls=true
  - traefik.http.routers.<router_name>.service=<router_name>
  - traefik.http.services.<router_name>.loadbalancer.server.port=<port>
```

---

## References

- <https://doc.traefik.io/traefik/user-guides/docker-compose/basic-example/>
- <https://github.com/xcad2k/boilerplates/tree/main/docker-compose/traefik>
