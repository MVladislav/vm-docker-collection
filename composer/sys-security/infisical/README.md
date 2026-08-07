# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

```sh
pwgen -s 32 1 > config/secrets/postgres_password_file.txt
echo "POSTGRES_PW=$(cat config/secrets/postgres_password_file.txt)" >> .env

echo "ENCRYPTION_KEY=$(pwgen -s 32 1)" >> .env
echo "AUTH_SECRET=$(pwgen -s 32 1)" >> .env
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
DOMAIN=infisical.home.local # not set in docker-compose, needs to be copied to .env
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
VERSION=v0.162.7
VERSION_VALKEY=9.1.0-alpine
VERSION_POSTGRESQL=18.4-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates

# Mail/SMTP
SMTP_HOST=
SMTP_PORT=
SMTP_FROM_ADDRESS=
SMTP_FROM_NAME=
SMTP_USERNAME=
SMTP_PASSWORD=
```

#### example short .env (swarm)

```env
DOMAIN=infisical.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=infisical.home.local
```

---

## References

- <https://infisical.com/>
- <https://infisical.com/docs/self-hosting/deployment-options/docker-compose>
- <https://github.com/Infisical/infisical>
  - <https://github.com/Infisical/infisical/blob/main/docker-compose.prod.yml>
  - <https://github.com/Infisical/infisical/blob/main/.env.example>
