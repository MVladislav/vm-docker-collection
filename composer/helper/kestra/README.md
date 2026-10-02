# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

```sh
cp config/secrets.yaml.tmpl config/secrets.yaml
echo "KESTRA_PASSWORD=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20; echo '')" >> .env
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
DOMAIN=kestra.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8080
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
VERSION_KESTRA=v0.24.20
VERSION_POSTGRESQL=18.6-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
KESTRA_USERNAME=kestra@home.local


KESTRA_ANONYMOUS_USAGE_REPORT=false
KESTRA_UI_ANONYMOUS_USAGE_REPORT=false
```

#### example short .env (swarm)

```env
DOMAIN=kestra.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=kestra.home.local
```

---

## References

- <https://kestra.io/>
- <https://kestra.io/docs/installation/docker-compose>
- <https://github.com/kestra-io/kestra/blob/develop/docker-compose.yml>
