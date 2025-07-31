# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [traefik setup](#traefik-setup)
    - [traefik_dynamic setup](#traefik_dynamic-setup)
    - [config setup](#config-setup)
    - [cert setup](#cert-setup)
      - [example quick create](#example-quick-create)
    - [optional - create your `secrets`:](#optional---create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [label setup](#label-setup)
  - [References](#references)

---

## basic

### create your `secrets`:

```sh
$echo $(htpasswd -nB traefik) > config/secrets/traefik_basicauth_secret.txt
```

### traefik setup

> copy and update the general traefik setup

```sh
$cp ./config/traefik_template.yml ./config/traefik.yml
```

- In most cases no changes are necessary, when setup with swarm
  - if not used swarm, uncomment for non swarm section needed
  - if specific TLS usage needed, section for 'certificatesResolvers' should be checked

### traefik_dynamic setup

> copy and update the traefik_dynamic setup

```sh
$cp ./config/traefik_dynamic_template.yml ./config/traefik_dynamic.yml
```

- In most cases no changes are necessary

### config setup

> instead or on side to labels you can also define a config.yml

```sh
$cp ./config/config_template.yml ./config/config.yml
```

- In most cases no changes are necessary
  - possible, update section for needed headers
  - possible, update section for ip white list
  - activate authentic middleware

### cert setup

create following files inside `config/ssl`:

- config/ssl/ca.pem
- config/ssl/cert.pem
- config/ssl/cert-key.pem

#### example quick create

```sh
$openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-521 -quiet -out config/ssl/ca-key.pem
$openssl req -new -x509 -key config/ssl/ca-key.pem -out config/ssl/ca.pem -subj "/CN=*.test.local"

$openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-521 -quiet -out config/ssl/cert-key.pem
$openssl req -new -key config/ssl/cert-key.pem -out config/ssl/cert.csr -subj "/CN=*.test.local" -addext "subjectAltName=DNS:*.test.local"

$openssl x509 -req -in config/ssl/cert.csr -CA config/ssl/ca.pem -CAkey config/ssl/ca-key.pem -CAcreateserial -out config/ssl/cert.pem -days 365 -extfile <(printf "subjectAltName=DNS:*.test.local")
$rm config/ssl/cert.csr config/ssl/ca.srl
```

### optional - create your `secrets`:

Create a file as `config/secrets/cf_api_token_secret.txt`
and add your Cloudflare api token if you use certificates resolvers.

> _do not forget to uncomment the secret parts in `docker-compose.yaml`_

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

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
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=256m
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=v3.5.0
```

#### example short .env

```env
DOMAIN=traefik.home.local
```

## label setup

> defined label which needs to be setup per docker-composer,
> also not forget to add network

```yml
labels:
  - traefik.enable=true
  - traefik.swarm.lbswarm=true
  - traefik.swarm.network=proxy
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
