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
  - [FAQ](#faq)
    - [Report fixing](#report-fixing)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

> instead of openssl for password you can also use `pwgen -s 50 1`

```sh
$pwgen -s 32 1 > config/secrets/postgres_password_file.txt
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
DOMAIN=odoo.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8069
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=2
RESOURCES_LIMITS_MEMORY=2g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_POSTGRESQL=1
RESOURCES_LIMITS_MEMORY_POSTGRESQL=1G
RESOURCES_RESERVATIONS_CPUS_POSTGRESQL=0.001
RESOURCES_RESERVATIONS_MEMORY_POSTGRESQL=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_ODOO=18.0
VERSION_POSTGRESQL=17.2-alpine
```

#### example short .env

```env
DOMAIN=odoo.home.local
```

---

## FAQ

### Report fixing

Go to: `settings > Technical > System Parameters` and create the below entries or update existing

```sh
web.base.url = "https://<DOMAIN>"
report.url = "http://0.0.0.0:8069"
report.url.freeze = True
```

---

## References

- <https://www.odoo.com/app/project>
- <https://github.com/odoo/odoo>
- <https://hub.docker.com/_/odoo/>
- FAQ
  - <https://www.odoo.com/forum/help-1/custom-report-236164>
