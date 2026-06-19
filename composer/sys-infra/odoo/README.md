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
    - [Report fixing](#report-fixing)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

> instead of openssl for password you can also use `pwgen -s 50 1`

```sh
$pwgen -s 32 1 > config/secrets/postgres_password_file.txt
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
DOMAIN=odoo.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8069
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=2
RESOURCES_LIMITS_MEMORY=2g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_POSTGRESQL=1
RESOURCES_LIMITS_MEMORY_POSTGRESQL=1G
RESOURCES_RESERVATIONS_CPUS_POSTGRESQL=0.001
RESOURCES_RESERVATIONS_MEMORY_POSTGRESQL=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_ODOO=18.0
VERSION_POSTGRESQL=18.4-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates
```

#### example short .env

```env
DOMAIN=odoo.home.local
```

---

## FAQ

### Report fixing

Go to: `settings > Technical > System Parameters` and create the below entries or update existing

```sh
web.base.url = "https://<DOMAIN>"
report.url = "http://0.0.0.0:8069"
report.url.freeze = True
```

### PostgreSQL Major Version Upgrade Guide

_Example: Upgrading from PostgreSQL 17 to 18_
_NOTE: Naming assumes you started your stack with `docker-swarm-compose odoo`_

**1. Create a Backup of the Existing Database**

Run this command while the old container is still running:

```sh
docker exec -it --env-file .env "$(docker ps -q -f name=odoo_postgresql)" \
  bash -c \
  'PGPASSWORD=$(cat /run/secrets/postgres_password_file) pg_dump -U ${POSTGRES_USER:-odoo} -d ${POSTGRES_DB:-postgresql}' \
  > upgrade_backup.sql
```

- `-Fc`: Uses the custom format for the dump, which is more reliable for large databases.
- The backup is saved to `upgrade_backup.sql` in your current directory.

**2. Stop All `odoo` Services**

```sh
docker stack rm odoo
```

**3. Spin Up a Temporary PostgreSQL Container**

```sh
source .env && docker run --rm \
  --name pg_upgrade_temp \
  -v odoo_postgresql_v18:/var/lib/postgresql/18/data \
  -e PGDATA=/var/lib/postgresql/18/data \
  -e POSTGRES_DB=${POSTGRES_DB:-postgresql} \
  -e POSTGRES_USER=${POSTGRES_USER:-odoo} \
  -e PGPASSWORD=$(cat ./config/secrets/postgres_password_file.txt) \
  -e POSTGRES_PASSWORD=$(cat ./config/secrets/postgres_password_file.txt) \
  --env-file .env \
  postgres:${VERSION_POSTGRESQL:-18.4-alpine}
```

- Runs interactively in the terminal. Open a new terminal and proceed with step 4.
- `--rm`: Automatically removes the container when it exits.
- `-v odoo_postgresql_v18`: Persists the upgraded data in the new volume, as referenced in the updated `docker-compose.yml`.

**4. Restore the Backup into the Temporary Container**

```sh
cat ./upgrade_backup.sql | docker exec -i pg_upgrade_temp \
  bash -c 'psql -U ${POSTGRES_USER:-odoo} -d ${POSTGRES_DB:-postgresql}'
```

**5. Clean Up and Restart `odoo` Services**

Stop the temporary container with:

```sh
Ctrl+C
```

Restart your stack with the updated `docker-compose.yml`:

```sh
docker-swarm-compose odoo
```

---

## References

- <https://www.odoo.com/app/project>
- <https://github.com/odoo/odoo>
- <https://hub.docker.com/_/odoo/>
- FAQ
  - <https://www.odoo.com/forum/help-1/custom-report-236164>
