# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

```sh
pwgen -s 32 1 > config/secrets/postgres_password_file.txt

echo "DB_PASSWORD=$(cat config/secrets/postgres_password_file.txt)" >> .env
echo "JWT_SECRET=$(pwgen -s 32 1)" >> .env
echo "ENCRYPTION_KEY=$(pwgen -s 32 1)" >> .env
echo "STORAGE_ENCRYPTION_KEY=$(openssl rand -hex 32)" >> .env
echo "MEILI_MASTER_KEY=$(pwgen -s 32 1)" >> .env
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
DOMAIN=archiver.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=3000
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=2g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_OPEN_ARCHIVER=v0.5.1
VERSION_MEILISEARCH=v1.49
VERSION_POSTGRESQL=18.4-alpine
VERSION_VALKEY=9.1.0-alpine
VERSION_TIKA=3.3.1.0-full

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates
```

#### example short .env (swarm)

```env
DOMAIN=archiver.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=archiver.home.local
```

---

## Guides & Insights

### Meilisearch upgrade

```sh
docker exec -it "$(docker ps -q -f name=^archiver_meilisearch\\.)" sh -c 'curl -X POST 'http://127.0.0.1:7700/snapshots' \
  -H "Authorization: Bearer $MEILI_MASTER_KEY"'
docker exec -it "$(docker ps -q -f name=^archiver_meilisearch\\.)" sh -c 'curl -X POST 'http://127.0.0.1:7700/tasks/<TASK_UID>' \
  -H "Authorization: Bearer $MEILI_MASTER_KEY"'

# Stop the stack or meilisearch
# Update meilisearch to new version
# Start the stack or meilisearch (meilisearch as command defined to use --experimental-dumpless-upgrade)
```

---

## References

- <https://openarchiver.com/>
- <https://github.com/LogicLabs-OU/OpenArchiver>
  - <https://github.com/LogicLabs-OU/OpenArchiver/blob/main/docker-compose.yml>
  - <https://github.com/LogicLabs-OU/OpenArchiver/blob/main/.env.example>
- <https://www.meilisearch.com/>
- <https://github.com/meilisearch/meilisearch>
  - <https://www.meilisearch.com/docs/learn/self_hosted/configure_meilisearch_at_launch#environment-variable>
- <https://github.com/apache/tika-docker>
