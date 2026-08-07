# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

```sh
echo "SEARXNG_SECRET_KEY=$(pwgen -s 50 1)" >>.env
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
DOMAIN=search.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8080
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS_SEARXNG=2
RESOURCES_LIMITS_MEMORY_SEARXNG=512m
RESOURCES_RESERVATIONS_CPUS_SEARXNG=0.001
RESOURCES_RESERVATIONS_MEMORY_SEARXNG=32m

RESOURCES_LIMITS_CPUS_VALKEY=2
RESOURCES_LIMITS_MEMORY_VALKEY=512m
RESOURCES_RESERVATIONS_CPUS_VALKEY=0.001
RESOURCES_RESERVATIONS_MEMORY_VALKEY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=2026.7.28-8372f5d85
VERSION_VALKEY=9.1.0-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates
```

#### example short .env (swarm)

```env
DOMAIN=search.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=search.home.local
```

---

## References

- <https://github.com/searxng/searxng>
  - <https://github.com/searxng/searxng/blob/master/container/docker-compose.yml>
