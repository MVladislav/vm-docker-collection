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
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$pwgen -s 18 1 > config/secrets/postgres_password_file.txt
$echo "POSTGRES_PW=$(cat config/secrets/postgres_password_file.txt)" >> .env

$pwgen -s 18 1 > config/secrets/minio_root_password_file.txt
$echo "MINIO_ROOT_SECRET=$(cat config/secrets/minio_root_password_file.txt)" >> .env

$echo "ACCESS_TOKEN_SECRET=$(pwgen -s 18 1)" >> .env
$echo "REFRESH_TOKEN_SECRET=$(pwgen -s 18 1)" >> .env
$echo "CHROME_TOKEN=$(pwgen -s 18 1)" >> .env
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true

DOMAIN=resume.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=3000

DOMAIN_MINIO=storage.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL_MINIO=http
PORT_MINIO=9000

# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=512m
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_CHROMIUM=1
RESOURCES_LIMITS_MEMORY_CHROMIUM=512m
RESOURCES_RESERVATIONS_CPUS_CHROMIUM=0.001
RESOURCES_RESERVATIONS_MEMORY_CHROMIUM=32m

RESOURCES_LIMITS_CPUS_POSTGRESQL=1
RESOURCES_LIMITS_MEMORY_POSTGRESQL=512m
RESOURCES_RESERVATIONS_CPUS_POSTGRESQL=0.001
RESOURCES_RESERVATIONS_MEMORY_POSTGRESQL=32m

RESOURCES_LIMITS_CPUS_MINIO=1
RESOURCES_LIMITS_MEMORY_MINIO=512m
RESOURCES_RESERVATIONS_CPUS_MINIO=0.001
RESOURCES_RESERVATIONS_MEMORY_MINIO=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=v4.5.5
VERSION_CHROMIUM=v2.38.2
VERSION_POSTGRESQL=17.7-alpine
VERSION_MINIO=RELEASE.2025-09-07T16-13-09Z-cpuv1

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates

ACCESS_TOKEN_SECRET=<ACCESS_TOKEN_SECRET>
REFRESH_TOKEN_SECRET=<REFRESH_TOKEN_SECRET>

CHROME_TOKEN=<TOKEN> # https://docs.browserless.io/enterprise/docker/config

MAIL_FROM=<MAIL>
SMTP_URL: smtp://user:pass@smtp:587 # Optional # pragma: allowlist secret
```

#### example short .env

```env
DOMAIN=resume.home.local
DOMAIN_MINIO=storage.home.local

MAIL_FROM=<MAIL>
```

---

## References

- <https://rxresu.me/>
- <https://github.com/AmruthPillai/Reactive-Resume>
  - <https://github.com/AmruthPillai/Reactive-Resume/blob/main/tools/compose/swarm.yml>
- <https://docs.rxresu.me/product-guides/self-hosting-reactive-resume-using-docker>
