# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [traefik setup](#traefik-setup)
    - [traefik_dynamic setup](#traefik_dynamic-setup)
    - [config setup](#config-setup)
    - [cert setup](#cert-setup)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [label setup](#label-setup)
  - [References](#references)

---

## basic

### traefik setup

> copy and update the general traefik setup

```sh
$cp ./config/traefik_template.yml ./config/traefik.yml
```

### traefik_dynamic setup

> copy and update the traefik_dynamic setup

```sh
$cp ./config/traefik_dynamic_template.yml ./config/traefik_dynamic.yml
```

### config setup

> instead or byside to labels you can also define a config.yml

```sh
$cp ./config/config_template.yml ./config/config.yml
```

### cert setup

create following files inside `config/ssl`:

- config/ssl/ca.pem
- config/ssl/cert.pem
- config/ssl/cert-key.pem

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=traefik.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8080
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=0.5
RESOURCES_LIMITS_MEMORY=100M
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=v3.0

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
ADMIN_USERNAME=traefik
# old: echo $(openssl passwd -apr1 $PASSWORD) or echo $(openssl passwd -apr1)
# new: echo $(htpasswd -nB traefik)
# replace: make "$" doubled to "$$"
HASHED_PASSWORD=
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=traefik.home.local

ADMIN_USERNAME=traefik
# old: echo $(openssl passwd -apr1 $PASSWORD) or echo $(openssl passwd -apr1)
# new: echo $(htpasswd -nB traefik)
# replace: make "$" doubled to "$$"
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
  - traefik.http.routers.<router_name>.middlewares=<default-secured@file | public-secured@file>
  - traefik.http.routers.<router_name>.service=<router_name>
  - traefik.http.services.<router_name>.loadbalancer.server.scheme=${PROTOCOL:-http}
  - traefik.http.services.<router_name>.loadbalancer.server.port=${PORT:-80}
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

---

## References

- <https://doc.traefik.io/traefik/user-guides/docker-compose/basic-example/>
- <https://github.com/xcad2k/boilerplates/tree/main/docker-compose/traefik>
- <https://doc.traefik.io/traefik/routing/providers/docker/#tcp-services>
- <https://doc.traefik.io/traefik/reference/dynamic-configuration/file/>
- <https://traefik.io/blog/traefik-2-tls-101-23b4fbee81f1/>
