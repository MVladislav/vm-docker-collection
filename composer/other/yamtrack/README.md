# SETUP

## basic

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=watch.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8000
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_YAMTRACK=0.25.3
VERSION_VALKEY=9.1.0-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates
SECRET=<longstring> # `pwgen -s 32 1`
```

#### example short .env (swarm)

```env
DOMAIN=watch.home.local
SECRET=<longstring> # `pwgen -s 32 1`
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=watch.home.local
SECRET=<longstring> # `pwgen -s 32 1`
```

---

## References

- <https://github.com/FuzzyGrim/Yamtrack>
- <https://github.com/FuzzyGrim/Yamtrack/blob/dev/docker-compose.yml>
