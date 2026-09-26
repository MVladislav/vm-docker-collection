# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

```sh
openssl rand -hex 16 > config/secrets/postgres_password_file.txt
openssl rand -hex 64 > config/secrets/secret_key_file.txt
openssl rand -hex 32 > config/secrets/api_token_pepper_1.txt
openssl rand -hex 16 > config/secrets/superuser_password_file.txt
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
DOMAIN=netbox.home.local # not set in docker-compose, needs to be copied to .env
TRAEFIK_ENTRYPOINT=https
PROTOCOL=http
PORT=8080
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=v4.7.1
VERSION_POSTGRESQL=18.6-alpine
VERSION_VALKEY=9.1.2-alpine

# RESOURCES limits
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS_NETBOX=1
RESOURCES_LIMITS_MEMORY_NETBOX=1g
RESOURCES_LIMITS_CPUS_NETBOX_WORKER=1
RESOURCES_LIMITS_MEMORY_NETBOX_WORKER=1g
RESOURCES_LIMITS_CPUS_POSTGRESQL=1
RESOURCES_LIMITS_MEMORY_POSTGRESQL=512m
RESOURCES_LIMITS_CPUS_VALKEY=1
RESOURCES_LIMITS_MEMORY_VALKEY=128m
RESOURCES_LIMITS_CPUS_VALKEY_CACHE=1
RESOURCES_LIMITS_MEMORY_VALKEY_CACHE=128m

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates

# SMTP, netbox raises InvalidMailer on send when EMAIL_SERVER is unset
# ______________________________________________________________________________
EMAIL_SERVER=mail.home.local
EMAIL_PORT=587
EMAIL_USERNAME=netbox
EMAIL_PASSWORD=
EMAIL_FROM=netbox@netbox.home.local
EMAIL_USE_SSL=false
EMAIL_USE_TLS=true

# SUPERUSER, created on the first start only
# ______________________________________________________________________________
SKIP_SUPERUSER=false
SUPERUSER_NAME=admin
SUPERUSER_EMAIL=netbox@netbox.home.local
```

#### example short .env (swarm)

```env
DOMAIN=netbox.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=netbox.home.local
```

---

## References

- <https://netbox.dev/>
- <https://docs.netbox.dev/>
- <https://hub.docker.com/r/netboxcommunity/netbox>
- <https://github.com/netbox-community/netbox-docker>
