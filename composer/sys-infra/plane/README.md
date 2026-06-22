# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

```sh
echo "SECRET_KEY=$(pwgen -s 32 1)" >> .env
echo "AWS_ACCESS_KEY_ID=$(pwgen -s 12 1)" >> .env
echo "AWS_SECRET_ACCESS_KEY=$(pwgen -s 32 1)" >> .env
echo "RABBITMQ_DEFAULT_PASS=$(pwgen -s 12 1)" >> .env
echo "POSTGRES_PASSWORD=$(pwgen -s 12 1)" >> .env
echo "LIVE_SERVER_SECRET_KEY=$(pwgen -s 32 1)" >> .env
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
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1 # migrator
RESOURCES_LIMITS_MEMORY=1g # migrator
RESOURCES_LIMITS_CPUS_PLANE_WEB=2
RESOURCES_LIMITS_MEMORY_PLANE_WEB=500m
RESOURCES_LIMITS_CPUS_PLANE_API=1
RESOURCES_LIMITS_MEMORY_PLANE_API=500m
RESOURCES_LIMITS_CPUS_PLANE_ADMIN=1
RESOURCES_LIMITS_MEMORY_PLANE_ADMIN=256m
RESOURCES_LIMITS_CPUS_PLANE_SPACE=1
RESOURCES_LIMITS_MEMORY_PLANE_SPACE=256m
RESOURCES_LIMITS_CPUS_PLANE_LIVE=1
RESOURCES_LIMITS_MEMORY_PLANE_LIVE=256m
RESOURCES_LIMITS_CPUS_PLANE_WORKER=1
RESOURCES_LIMITS_MEMORY_PLANE_WORKER=2g
RESOURCES_LIMITS_CPUS_PLANE_BEAT=1
RESOURCES_LIMITS_MEMORY_PLANE_BEAT=500m
RESOURCES_LIMITS_CPUS_POSTGRESQL=1
RESOURCES_LIMITS_MEMORY_POSTGRESQL=1g
RESOURCES_LIMITS_CPUS_RABBITMQ=1
RESOURCES_LIMITS_MEMORY_RABBITMQ=500m
RESOURCES_LIMITS_CPUS_VALKEY=1
RESOURCES_LIMITS_MEMORY_VALKEY=256m
RESOURCES_LIMITS_CPUS_RUSTFS=1
RESOURCES_LIMITS_MEMORY_RUSTFS=1g

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_PLANE=v1.3.1
VERSION_POSTGRESQL=18.4-alpine
VERSION_RABBITMQ=4.3.1-management-alpine
VERSION_VALKEY=9.1.0-alpine
VERSION_RUSTFS=1.0.0-beta.8

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates
```

#### example short .env

```env
DOMAIN=plane.home.local
```

## FAQ

### Create additional `god-mode` admins

> Replace `<E-MAIL>`

```sh
docker exec -it "$(docker ps -q -f name=plane_worker)" /bin/bash -c "python manage.py create_instance_admin <E-MAIL>"
```

### Postgresql Upgrade

> Example for major upgrade from 17 to 18

**While still running old container version, perform manual backup dump:**

```sh
docker exec -it --env-file .env "$(docker ps -q -f name=plane_plane-db)" bash -c 'PGPASSWORD=$POSTGRES_PASSWORD pg_dump -U ${POSTGRES_USER:-plane}' > upgrade_backup.sql
```

**Stop all plane container/services.**

**Run now a temp postgres container and upload the dump into new version:**

```sh
docker run --rm \
  --name pg_upgrade_temp \
  -v plane_postgresql_v18:/var/lib/postgresql/18/data \
  -e PGDATA=/var/lib/postgresql/18/data \
  -e POSTGRES_USER=${POSTGRES_USER:-plane} \
  --env-file .env \
  postgres:18.4-alpine

cat ./upgrade_backup.sql | docker exec -i "$(docker ps -q -f name=pg_upgrade_temp)" bash -c 'PGPASSWORD=$POSTGRES_PASSWORD psql -U ${POSTGRES_USER:-plane}'
```

**Stop the temp postgres container, and start plane as normal.**

### Upgrade Minio to Rustfs

```sh
sudo chown -R 10001:10001 /var/lib/docker/volumes/plane_uploads/_data
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
