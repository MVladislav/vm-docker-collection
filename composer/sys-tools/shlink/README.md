# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

> generate api token for web-ui usage

```sh
docker exec -it "$(docker ps -q -f name=shlink-short)" shlink api-key:generate
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
DOMAIN=short.home.local # not set in docker-compose, needs to be copied to .env
DOMAIN_SHORT=s.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=80
PORT_SHORT=8080
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
VERSION=latest

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates

TZ=Europe/Berlin
IS_HTTPS_ENABLED=true
```

#### example short .env (swarm)

```env
DOMAIN=short.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=short.home.local
```

---

## References

- <https://hub.docker.com/r/shlinkio/shlink/>
