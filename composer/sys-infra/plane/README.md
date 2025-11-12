# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [FAQ](#faq)
    - [Create additional `god-mode` admins](#create-additional-god-mode-admins)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$echo "SECRET_KEY=$(pwgen -s 32 1)" >> .env
$echo "LIVE_SERVER_SECRET_KEY=$(pwgen -s 32 1)" >> .env
$echo "AWS_SECRET_ACCESS_KEY=$(pwgen -s 32 1)" >> .env
$echo "RABBITMQ_DEFAULT_PASS=$(pwgen -s 12 1)" >> .env
$echo "POSTGRES_PASSWORD=$(pwgen -s 12 1)" >> .env
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=plane.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=https
PORT=443
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_PLANE=v1.1.0
VERSION_POSTGRESQL=17.6-alpine
VERSION_RABBITMQ=4.2.0-management-alpine
VERSION_VALKEY=9.0.0-alpine
VERSION_MINIO=RELEASE.2025-09-07T16-13-09Z-cpuv1

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
...
```

#### example short .env

```env
DOMAIN=plane.home.local
```

## FAQ

### Create additional `god-mode` admins

> Replace `<E-MAIL>`

```sh
$docker exec -it "$(docker ps -q -f name=plane_worker)" /bin/bash -c "python manage.py create_instance_admin <E-MAIL>"
```

---

## References

- <https://github.com/makeplane/plane>
- <https://developers.plane.so/self-hosting/methods/docker-swarm>
- <https://github.com/orgs/makeplane/discussions/3432>
- <https://github.com/makeplane/plane/issues/7310>
- files
  - <https://prime.plane.so/releases/v1.8.3/swarm-compose.yml>
  - <https://prime.plane.so/releases/v1.8.3/variables.env>
  - <https://github.com/makeplane/plane/releases/latest/download/setup.sh>
  - <https://github.com/makeplane/plane/releases/download/v0.27.1/docker-compose.yml>
  - <https://github.com/makeplane/plane/releases/download/v0.27.1/swarm.sh>
  - <https://github.com/makeplane/plane/releases/download/v0.27.1/variables.env>
