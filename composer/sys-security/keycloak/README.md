# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

> instead of openssl for passwords you can also use `pwgen -s 50 1`

```sh
openssl rand -base64 18 > config/secrets/keycloak_db_password.txt
openssl rand -base64 18 > config/secrets/keycloak_admin_password.txt
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
DOMAIN=keycloak.home.local # not set in docker-compose, needs to be copied to .env
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
VERSION_KEYCLOAK=26.7.4
VERSION_POSTGRESQL=18.4-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates

KEYCLOAK_ADMIN_USER=admin
POSTGRES_DB=keycloak
POSTGRES_USER=keycloak
```

#### example short .env (swarm)

```env
DOMAIN=keycloak.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=keycloak.home.local
```

---

## Guides & Insights

### Verify the healthcheck

```sh
docker inspect --format "{{json .State.Health }}" "$(docker ps -q -f name=keycloak_keycloak)" | jq
```

### Create first account

Open the admin console at `https://keycloak.home.local/admin/` and log in with
the credentials set via `KEYCLOAK_ADMIN_USER` and the `keycloak_admin_password`
secret (bootstrap admin, see `KC_BOOTSTRAP_ADMIN_*`).

---

## References

- <https://www.keycloak.org/server/containers>
- <https://www.keycloak.org/server/configuration-production>
- <https://www.keycloak.org/server/reverseproxy>
- <https://www.keycloak.org/server/management-interface>
- <https://github.com/keycloak/keycloak>
