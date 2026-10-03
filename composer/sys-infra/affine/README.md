# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

```sh
openssl rand -hex 18 > config/secrets/postgres_password_file.txt
echo "POSTGRES_PW=$(cat config/secrets/postgres_password_file.txt)" >> .env
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
DOMAIN=affine.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=3010
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=2
RESOURCES_LIMITS_MEMORY=3g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_MIGRATION=2
RESOURCES_LIMITS_MEMORY_MIGRATION=2g
RESOURCES_RESERVATIONS_CPUS_MIGRATION=0.001
RESOURCES_RESERVATIONS_MEMORY_MIGRATION=32m

RESOURCES_LIMITS_CPUS_VALKEY=1
RESOURCES_LIMITS_MEMORY_VALKEY=128m
RESOURCES_RESERVATIONS_CPUS_VALKEY=0.001
RESOURCES_RESERVATIONS_MEMORY_VALKEY=32m

RESOURCES_LIMITS_CPUS_POSTGRESQL=1
RESOURCES_LIMITS_MEMORY_POSTGRESQL=512m
RESOURCES_RESERVATIONS_CPUS_POSTGRESQL=0.001
RESOURCES_RESERVATIONS_MEMORY_POSTGRESQL=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_AFFINE=0.27.4
VERSION_VALKEY=9.1.2-alpine
VERSION_POSTGRESQL=18.6-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates
```

#### example short .env (swarm)

```env
DOMAIN=affine.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=affine.home.local
```

---

## References

- <https://affine.pro/>
- <https://github.com/toeverything/AFFiNE>
- <https://docs.affine.pro/self-host-affine>
- <https://docs.affine.pro/self-host-affine/install>
- <https://docs.affine.pro/self-host-affine/install/configuration>
- <https://docs.affine.pro/self-host-affine/install/upgrade>
