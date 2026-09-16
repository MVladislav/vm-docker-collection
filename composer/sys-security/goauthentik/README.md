# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

> instead of openssl for passwords you can also use `pwgen -s 50 1`

```sh
openssl rand -base64 18 > config/secrets/postgres_password_file.txt
openssl rand -base64 66 > config/secrets/authentik_secret_key.txt
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
DOMAIN=authentik.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=9000
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
VERSION_GOAUTHENTIK=2026.8.2
VERSION_POSTGRESQL=18.4-alpine

# APPLICATION general variable to adjust the apps (OPTIONAL)
# ______________________________________________________________________________
CERT_RESOLVER=certificates

# Port publishing (optional, when not using Traefik)
# ______________________________________________________________________________
# SMTP server
AUTHENTIK_EMAIL__HOST=localhost
AUTHENTIK_EMAIL__PORT=587
# Optionally authenticate (don't add quotation marks to your password)
AUTHENTIK_EMAIL__USERNAME=
AUTHENTIK_EMAIL__PASSWORD=
# STARTTLS / explicit TLS, usually on port 587
AUTHENTIK_EMAIL__USE_TLS=true
# Implicit TLS/SSL on the SMTP connection (`USE_SSL` is the variable name), usually on port 465
AUTHENTIK_EMAIL__USE_SSL=false
AUTHENTIK_EMAIL__TIMEOUT=30
# Sender email address; verify that the domain is valid.
AUTHENTIK_EMAIL__FROM=authentik@localhost
```

#### example short .env (swarm)

```env
DOMAIN=authentik.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=authentik.home.local
```

---

## Guides & Insights

### Verify the healthcheck

```sh
docker inspect --format "{{json .State.Health }}" "$(docker ps -q -f name=goauthentik)" | jq
```

### Initial setup

Open `https://authentik.home.local` (or whatever domain you set in `DOMAIN`)
and follow the initial setup flow. You will be prompted to set a password for
the `akadmin` user (the default admin).

---

## References

- <https://goauthentik.io/>
- <https://docs.goauthentik.io/install-config/install/docker-compose/>
- <https://docs.goauthentik.io/install-config/reverse-proxy/>
- <https://github.com/goauthentik/authentik>
- <https://github.com/goauthentik/authentik/pkgs/container/server>
- [passwordless authentication setup example](https://www.youtube.com/watch?v=aEpT2fYGwLw)
- [ldap example setup](https://www.youtube.com/watch?v=RtPKMMKRT_E)
  - <https://goauthentik.io/docs/providers/ldap/generic_setup>
