# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env (swarm)](#example-short-env-swarm)
      - [example short .env (bridge)](#example-short-env-bridge)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$pwgen -s 18 1 > config/secrets/postgres_password_file.txt
$echo "POSTGRES_PW=$(cat config/secrets/postgres_password_file.txt)" >> .env

$echo "AUTH_SECRET=$(pwgen -s 32 1)" >> .env
$echo "S3_SECRET_ACCESS_KEY=$(pwgen -s 32 1)" >> .env
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
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=512m
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_POSTGRESQL=1
RESOURCES_LIMITS_MEMORY_POSTGRESQL=512m
RESOURCES_RESERVATIONS_CPUS_POSTGRESQL=0.001
RESOURCES_RESERVATIONS_MEMORY_POSTGRESQL=32m

RESOURCES_LIMITS_CPUS_SEAWEEDFS=1
RESOURCES_LIMITS_MEMORY_SEAWEEDFS=512m
RESOURCES_RESERVATIONS_CPUS_SEAWEEDFS=0.001
RESOURCES_RESERVATIONS_MEMORY_SEAWEEDFS=32m

RESOURCES_LIMITS_CPUS_MINIO_MC=1
RESOURCES_LIMITS_MEMORY_MINIO_MC=512m
RESOURCES_RESERVATIONS_CPUS_MINIO_MC=0.001
RESOURCES_RESERVATIONS_MEMORY_MINIO_MC=32m

RESOURCES_LIMITS_CPUS_GOTENBERG=1
RESOURCES_LIMITS_MEMORY_GOTENBERG=512m
RESOURCES_RESERVATIONS_CPUS_GOTENBERG=0.001
RESOURCES_RESERVATIONS_MEMORY_GOTENBERG=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_RESUME=v5.0.0
VERSION_POSTGRESQL=18.1-alpine
VERSION_SEAWEEDFS=4.07
VERSION_MC=RELEASE.2025-08-13T08-35-41Z-cpuv1
VERSION_GOTENBERG=8.25.1

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates
```

#### example short .env (swarm)

```env
DOMAIN=resume.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=resume.home.local
```

---

## References

- <https://rxresu.me/>
- <https://github.com/AmruthPillai/Reactive-Resume>
  - <https://github.com/AmruthPillai/Reactive-Resume/blob/main/tools/compose/swarm.yml>
- <https://docs.rxresu.me/product-guides/self-hosting-reactive-resume-using-docker>
