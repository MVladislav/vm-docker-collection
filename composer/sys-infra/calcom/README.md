# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$pwgen -s 32 1 > config/secrets/postgres_password_file.txt
$echo "DATABASE_PASSWORD=$(cat config/secrets/postgres_password_file.txt)" >> .env

$echo "NEXTAUTH_SECRET=$(pwgen -s 32 1)" >> .env
$echo "CALENDSO_ENCRYPTION_KEY=$(pwgen -s 32 1)" >> .env
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=calcom.home.local # not set in docker-compose, needs to be copied to .env
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

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_CALCOM=v5.4.4
VERSION_POSTGRESQL=17.5-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
EMAIL_FROM_NAME=YourOrganizationName
EMAIL_FROM=groot@${DOMAIN?domain variable not set}

# Configure SMTP settings (@see https://nodemailer.com/smtp/).
EMAIL_SERVER_HOST=smtp.example.com
EMAIL_SERVER_PORT=587
EMAIL_SERVER_USER=email_user
EMAIL_SERVER_PASSWORD=email_password
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=calcom.home.local
```

---

## References

- <https://cal.com/>
- <https://cal.com/docs/self-hosting/docker>
- <https://github.com/calcom/cal.com>
- <https://github.com/calcom/docker>
- <https://hub.docker.com/r/calcom/cal.com>
