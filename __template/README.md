# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

> instead of openssl for password you can also use `pwgen -s 50 1`

```sh
openssl rand -base64 18 | docker secret create my_external_secret -
openssl rand -base64 18 > config/secrets/my_file_secret.txt
openssl rand -hex 18 | docker secret create my_external_secret -
openssl rand -hex 18 > config/secrets/my_file_secret.txt
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=<HOST>.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=https
PORT=443
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
# 500m | 1g | ...
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=latest

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
# NOTE: extend additional info here ...
CERT_RESOLVER=certificates
```

#### example short .env (swarm)

```env
DOMAIN=<HOST>.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=<HOST>.home.local
```

---

## Guides & Insights

### verify healthcheck

```sh
docker inspect --format "{{json .State.Health }}" <CONTAINER_NAME> | jq
```

### access docker in swarm mode

```sh
docker exec -it "$(docker ps -q -f name=^<SERVICE_NAME>\\.)" <COMMAND>
```

### some more useful commands

```sh
# all non-running containers (exited + created)
docker ps -a -f "status=exited" -f "status=created"
# only stopped/exited containers
docker ps -a -f "status=exited"
# only never-started containers
docker ps -a -f "status=created"

# stop all containers
docker stop $(docker ps -a -q)
# remove all containers
docker rm $(docker ps -a -q)
# remove all stopped/exited containers
docker rm $(docker ps -a -q -f "status=exited")

# for debugs and faster cleanups also
# remove all containers
docker volume rm $(docker volume ls -qf dangling=true)
```

### PostgreSQL Major Version Upgrade Guide

_Example: Upgrading from PostgreSQL 17 to 18_
_NOTE: Naming assumes you started your stack with `docker-swarm-compose <NAME>`_

**1. Create a Backup of the Existing Database**

Run this command while the old container is still running:

```sh
docker exec -it --env-file .env "$(docker ps -q -f name=<NAME>_postgresql)" \
  bash -c \
  'PGPASSWORD=$POSTGRES_PASSWORD pg_dump -U ${POSTGRES_USER:-postgresql} -d ${POSTGRES_DB:-postgresql}' \
  > upgrade_backup.sql

# or

docker exec -it --env-file .env "$(docker ps -q -f name=odoo_postgresql)" \
  bash -c \
  'PGPASSWORD=$(cat /run/secrets/postgres_password_file) pg_dump -U ${POSTGRES_USER:-postgresql} -d ${POSTGRES_DB:-postgresql}' \
  > upgrade_backup.sql
```

- `-Fc`: Uses the custom format for the dump, which is more reliable for large databases.
  - TODO: add `-Fc` to command and below use `pg_restore` instead of `psql`
- The backup is saved to `upgrade_backup.sql` in your current directory.

**2. Stop All `<NAME>` Services**

```sh
docker stack rm <NAME>
```

**3. Spin Up a Temporary PostgreSQL Container**

```sh
source .env && docker run --rm \
  --name pg_upgrade_temp \
  -v <NAME>_postgresql_v18:/var/lib/postgresql/18/data \
  -e PGDATA=/var/lib/postgresql/18/data \
  -e POSTGRES_DB=${POSTGRES_DB:-postgresql} \
  -e POSTGRES_USER=${POSTGRES_USER:-postgresql} \
  # -e PGPASSWORD=$(cat ./config/secrets/postgres_password_file.txt) \
  # -e POSTGRES_PASSWORD=$(cat ./config/secrets/postgres_password_file.txt) \
  --env-file .env \
  postgres:${VERSION_POSTGRESQL:-18.4-alpine}
```

- Runs interactively in the terminal. Open a new terminal and proceed with step 4.
- `--rm`: Automatically removes the container when it exits.
- `-v <NAME>_postgresql_v18`: Persists the upgraded data in the new volume, as referenced in the updated `docker-compose.yml`.

**4. Restore the Backup into the Temporary Container**

```sh
cat ./upgrade_backup.sql | docker exec -i pg_upgrade_temp \
  bash -c 'psql -U ${POSTGRES_USER:-postgresql} -d ${POSTGRES_DB:-postgresql}'
```

**5. Clean Up and Restart `<NAME>` Services**

Stop the temporary container with:

```sh
Ctrl+C
```

Restart your stack with the updated `docker-compose.yml`:

```sh
docker-swarm-compose <NAME>
```

---

## References

- <https://docs.docker.com/compose/compose-file/compose-file-v3/#configs>
- <https://docs.docker.com/engine/swarm/secrets/>
- <https://docs.docker.com/compose/use-secrets/>
- <https://...>
