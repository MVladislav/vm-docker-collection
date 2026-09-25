# Setup

## Basic

> designed to work with traefik

### Create your `secrets`

```sh
pwgen -s 32 1 > config/secrets/postgres_password_file.txt
echo "PATCHMON_DB_PW=$(cat config/secrets/postgres_password_file.txt)" >> .env
echo "JWT_SECRET=$(pwgen -s 64 1)" >> .env
echo "AI_ENCRYPTION_KEY=$(pwgen -s 64 1)" >> .env
echo "SESSION_SECRET=$(pwgen -s 64 1)" >> .env
```

### Create the `.env` file

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=patchmon.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=3000
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m
RESOURCES_LIMITS_CPUS_POSTGRESQL=1
RESOURCES_LIMITS_MEMORY_POSTGRESQL=512m
RESOURCES_RESERVATIONS_CPUS_POSTGRESQL=0.001
RESOURCES_RESERVATIONS_MEMORY_POSTGRESQL=32m
RESOURCES_LIMITS_CPUS_VALKEY=1
RESOURCES_LIMITS_MEMORY_VALKEY=128m
RESOURCES_RESERVATIONS_CPUS_VALKEY=0.001
RESOURCES_RESERVATIONS_MEMORY_VALKEY=32m
RESOURCES_LIMITS_CPUS_GUACD=1
RESOURCES_LIMITS_MEMORY_GUACD=512m
RESOURCES_RESERVATIONS_CPUS_GUACD=0.001
RESOURCES_RESERVATIONS_MEMORY_GUACD=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_PATCHMON=2.1.3
VERSION_GUACD=1.6.0
VERSION_POSTGRESQL=18.6-alpine
VERSION_VALKEY=9.1.0-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates
```

#### Example short `.env` (swarm)

```env
DOMAIN=patchmon.home.local
```

#### Example short `.env` (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=patchmon.home.local
```

## References

- <https://github.com/PatchMon/PatchMon>
- <https://patchmon.net/docs/patchmon-operator-guide#container-image>
- <https://github.com/PatchMon/PatchMon/blob/main/docker/docker-compose.yml>
