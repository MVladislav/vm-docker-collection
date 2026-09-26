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
VERSION_RABBITMQ=3.13.7-management-alpine
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

### RabbitMQ version

> Pinned to the **3.13.x** series, same as upstream's `swarm-compose.yml`.
> Do **not** move this to 4.x yet.

RabbitMQ 4.1.0 raised the protocol minimum `frame_max` from 4096 to 8192
(`FRAME_MIN_SIZE` in `rabbit_common/include/rabbit_framing.hrl` - a compile-time
constant, not a `rabbitmq.conf` setting). Plane's Node services connect with
`amqplib`, whose default is `frameMax: 0x1000` (4096), so every connection is
refused during parameter negotiation:

```
User 'plane' authenticated successfully
closing AMQP connection: failed to negotiate connection parameters:
negotiated frame_max = 4096 is lower than the minimum allowed value (8192)
```

Neither side is fixable from this compose file - the server minimum cannot be
lowered, and Plane does not expose a `frameMax` env var. Re-check when upstream
Plane ships a newer `amqplib`.

### RabbitMQ upgrade

RabbitMQ only moves **one minor series at a time** - a node refuses to boot when
its data dir is more than one series behind. Coming from `3.13.x` you must pass
through `4.2.x`, or simply recreate the volume:

```sh
# Stop service first
docker volume rm plane_rabbitmq_data
```

Only the in-flight Celery tasks are lost - all data lives in PostgreSQL, Redis
and RustFS. The user/vhost are re-seeded from `RABBITMQ_USER` /
`RABBITMQ_DEFAULT_PASS` / `RABBITMQ_VHOST`.

> Upstream's compose interpolates the password straight into `AMQP_URL`.
> `/ @ : # %` in `RABBITMQ_DEFAULT_PASS` silently produce a broken broker URL -
> `pwgen -s 12 1` (above) is alnum-only and safe, `openssl rand -base64 18` is
> not.

### Upgrade Minio to Rustfs

> RustFS reads a MinIO data directory in place and converts it on first start
> (`.minio.sys` -> `.rustfs.sys`, plus `xl.meta` objects, bucket metadata and
> IAM config). The conversion is **one-way**: once RustFS has written
> `.rustfs.sys`, a MinIO binary cannot read the volume again. Snapshot the
> `uploads` volume before the first RustFS start.

**MinIO stores files as uid 1000, RustFS runs as uid 10001 - fix ownership first:**

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
