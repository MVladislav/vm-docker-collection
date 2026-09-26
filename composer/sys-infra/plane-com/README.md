# SETUP

> Plane **Commercial Edition** for Docker Swarm with Traefik and RustFS.
> Upstream's bundled `proxy` is replaced by Traefik.
> Plane needs a licence key, activate it in God Mode → General Settings.

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

echo "MACHINE_SIGNATURE=$(uuidgen)" >> .env
echo "SILO_HMAC_SECRET_KEY=$(pwgen -s 32 1)" >> .env
echo "AES_SECRET_KEY=$(pwgen -s 32 1)" >> .env
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
# NOTE: multiple resources, see docker-compose
#RESOURCES_LIMITS_CPUS_*=...
#RESOURCES_LIMITS_MEMORY_*=...

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_PLANE=v3.3.0
VERSION_POSTGRESQL=18.6-alpine
VERSION_RABBITMQ=3.13.6-management-alpine
VERSION_VALKEY=9.1.2-alpine
VERSION_RUSTFS=1.0.0
VERSION_IFRAMELY=v2.5.4

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates

GUNICORN_WORKERS=1
```

#### example short .env (swarm)

```env
DOMAIN=plane.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=plane.home.local
```

---

## FAQ

### Create additional `god-mode` admins

> Replace `<E-MAIL>`

```sh
docker exec -it "$(docker ps -q -f name=plane_worker)" /bin/bash -c "python manage.py create_instance_admin <E-MAIL>"
```

### Disable telemetry

There is no env var for this. God Mode → General Settings → **Telemetry** off.

### Switch the uploads bucket to private storage

Since Commercial v1.4.0 Plane uses **private** buckets and presigned URLs. For an
existing public bucket:

```sh
docker exec -it "$(docker ps -q -f name=plane_api)" python manage.py update_bucket
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
  postgres:18.6-alpine

cat ./upgrade_backup.sql | docker exec -i "$(docker ps -q -f name=pg_upgrade_temp)" bash -c 'PGPASSWORD=$POSTGRES_PASSWORD psql -U ${POSTGRES_USER:-plane}'
```

**Stop the temp postgres container, and start plane as normal.**

### Upgrade Minio to Rustfs

> RustFS reads a MinIO data directory in place and converts it on first start
> (`.minio.sys` -> `.rustfs.sys`, plus `xl.meta` objects, bucket metadata and
> IAM config). The conversion is **one-way**: once RustFS has written
> `.rustfs.sys`, a MinIO binary cannot read the volume again. Snapshot the
> `uploads` volume before the first RustFS start.

**MinIO stores files as uid 1000, RustFS runs as uid 10001 — fix ownership first:**

```sh
sudo chown -R 10001:10001 /var/lib/docker/volumes/plane_uploads/_data
```

> Only unencrypted objects migrate in the released container images. If MinIO
> was configured with SSE / a KMS plugin, decrypt on the MinIO side first; those
> objects fail closed on the default build.

---

## References

- <https://github.com/makeplane/plane>
- <https://developers.plane.so/self-hosting/methods/docker-swarm>
- <https://developers.plane.so/self-hosting/govern/environment-variables>
- <https://developers.plane.so/self-hosting/manage/health-checks>
- <https://developers.plane.so/self-hosting/govern/reverse-proxy>
- <https://prime.plane.so/releases/v3.3.0/swarm-compose.yml>
- <https://prime.plane.so/releases/v3.3.0/variables.env>
- <https://github.com/makeplane/commercial-deployments>
