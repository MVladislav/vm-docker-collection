# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

```sh
pwgen -s 32 1 > config/secrets/postgres_password_file.txt
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
DOMAIN=invoice.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8080
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_INVOICE_SHELF=2.4.6
VERSION_POSTGRESQL=18.6-alpine
VERSION_GOTENBERG=8.37.0

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates

PDF_DRIVER=gotenberg # gotenberg | dompdf
GOTENBERG_HOST=http://gotenberg:3000
GOTENBERG_ALLOWED_PRIVATE_HOST=http://gotenberg:3000

# honoured since 2.4.2 — schedules follow it, previously they stayed on UTC
APP_TIMEZONE=Europe/Berlin
```

#### example short .env

```env
DOMAIN=invoice.home.local
```

---

## References

- <https://invoiceshelf.com>
- <https://github.com/InvoiceShelf/InvoiceShelf>
- <https://github.com/InvoiceShelf/docker>
  - <https://hub.docker.com/r/invoiceshelf/invoiceshelf>
