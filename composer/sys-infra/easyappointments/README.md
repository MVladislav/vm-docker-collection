# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env (swarm)](#example-short-env-swarm)
      - [example short .env (bridge)](#example-short-env-bridge)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$pwgen -s 32 1 > config/secrets/mariadb_user_password.txt
$echo "DB_PASSWORD=$(cat config/secrets/mariadb_user_password.txt)" >> .env
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
DOMAIN=appt.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=80
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=512m
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_MARIADB=1
RESOURCES_LIMITS_MEMORY_MARIADB=512m
RESOURCES_RESERVATIONS_CPUS_MARIADB=0.001
RESOURCES_RESERVATIONS_MEMORY_MARIADB=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_APPT=1.5.1
VERSION_MARIADB=11.8.2

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
MAIL_PROTOCOL=smtp
MAIL_SMTP_DEBUG=0
MAIL_SMTP_AUTH=0
MAIL_SMTP_HOST=smtp.example.org
MAIL_SMTP_USER:
MAIL_SMTP_PASS:
MAIL_SMTP_CRYPTO=tls
MAIL_SMTP_PORT=587
MAIL_FROM_ADDRESS=info@example.org
MAIL_FROM_NAME=APPT
MAIL_REPLY_TO_ADDRESS=info@example.org
```

#### example short .env (swarm)

```env
DOMAIN=appt.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=appt.home.local
```

---

## References

- <https://easyappointments.org/>
- <https://easyappointments.org/docs.html#1.5.1/docker.md>
- <https://github.com/alextselegidis/easyappointments>
