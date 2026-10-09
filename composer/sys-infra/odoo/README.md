# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

```sh
pwgen -s 32 1 > config/secrets/postgres_password_file.txt
pwgen -s 32 1 > config/secrets/admin_passwd.txt
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
RESOURCES_LIMITS_MEMORY=3g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_POSTGRESQL=1
RESOURCES_LIMITS_MEMORY_POSTGRESQL=1g
RESOURCES_RESERVATIONS_CPUS_POSTGRESQL=0.001
RESOURCES_RESERVATIONS_MEMORY_POSTGRESQL=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_ODOO=19.0
VERSION_POSTGRESQL=18.6-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates
```

#### example short `.env` (swarm)

```env
DOMAIN=odoo.home.local
```

#### example short `.env` (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=odoo.home.local
```

### render `config/odoo.conf`

`docker stack deploy` fails outright when the file is missing, so render it
before deploying:

```sh
set -a && . ./.env && set +a
sed -e "s|@@ODOO_ADMIN_PASSWD@@|$(cat config/secrets/admin_passwd.txt)|" \
  config/odoo.conf.tmpl > config/odoo.conf
chmod 644 config/odoo.conf # docker compose bind-mounts it and ignores `mode`
```

`@@ODOO_ADMIN_PASSWD@@` is the only token in the template - the database
password deliberately is not, see the header comment in the template.

### first boot: create the database

The postgres bootstrap database is fixed to `postgres` in `docker-compose.yaml`,
so on a fresh volume Odoo sees **no** user database and its database manager
stays reachable. Open `https://<DOMAIN>` and create the application database
there (master password: `config/secrets/admin_passwd.txt`). # pragma: allowlist secret

It is deliberately **not** `.env`-configurable: pointing it at the application
database name makes postgres pre-create that db **empty**, and because it is
then the only user database Odoo auto-selects it (the "monodb" branch in
`odoo/http.py`) and 500s on every request - including `/web/database/manager` -
with `KeyError: 'ir.http'`, so the setup UI becomes unreachable.

---

## Guides & Insights

### Migrate an existing database (OpenUpgrade)

```sh
./migration.sh              # migrate (the export keeps the source credentials)
./migration.sh anonymize    # migrate + scrub the export for a test instance
```

`anonymize` deletes the mail infrastructure, removes every 2FA secret / trusted
device / API key, rewrites e-mails and personal names, nulls phone / address /
bank / tax fields, and resets **all** passwords to `test` with a single known
login `admin`.

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
  'PGPASSWORD=$(cat /run/secrets/postgres_password_file) pg_dump -U ${POSTGRES_USER:-odoo} -d ${POSTGRES_DB:-odoo}' \
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
  -e POSTGRES_DB=${POSTGRES_DB:-odoo} \
  -e POSTGRES_USER=${POSTGRES_USER:-odoo} \
  -e PGPASSWORD=$(cat ./config/secrets/postgres_password_file.txt) \
  -e POSTGRES_PASSWORD=$(cat ./config/secrets/postgres_password_file.txt) \
  --env-file .env \
  postgres:${VERSION_POSTGRESQL:-18.6-alpine}
```

- Runs interactively in the terminal. Open a new terminal and proceed with step 4.
- `--rm`: Automatically removes the container when it exits.
- `-v odoo_postgresql_v18`: Persists the upgraded data in the new volume, as referenced in the updated `docker-compose.yml`.

**4. Restore the Backup into the Temporary Container**

```sh
cat ./upgrade_backup.sql | docker exec -i pg_upgrade_temp \
  bash -c 'psql -U ${POSTGRES_USER:-odoo} -d ${POSTGRES_DB:-odoo}'
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
- OpenUpgrade <https://oca.github.io/OpenUpgrade/>
- OpenUpgrade 19.0 branch <https://github.com/OCA/OpenUpgrade/tree/19.0>
- OCA/ocb 19.0 <https://github.com/oca/ocb/tree/19.0>
- `run-migration.py` (the Python original `migration.sh` is a port of) lives on
  the `run-migration` branch, not on `master`
  <https://github.com/hbrunn/OpenUpgrade/blob/run-migration/run-migration.py>
- Open 19.0 PRs <https://github.com/OCA/OpenUpgrade/pulls?q=is%3Apr+is%3Aopen+base%3A19.0>
- FAQ
  - <https://www.odoo.com/forum/help-1/custom-report-236164>
