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
  - [FAQ](#faq)
    - [Default credentials](#default-credentials)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$pwgen -s 32 1 > config/secrets/mariadb_user_password.txt
$pwgen -s 32 1 > config/secrets/mariadb_root_password.txt
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
DOMAIN=zabbix.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8080
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=2
RESOURCES_LIMITS_MEMORY=2g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_ZABBIX_WEB=7.4.5-alpine
VERSION_ZABBIX_SERVER=7.4.5-alpine
# NOTE: Zabbix 7.4 documents MariaDB support as 10.5.00-12.3.X, so this pin is
# ahead of the vendor's stated range. It tracks the newest upstream release
# rather than the newest one Zabbix has certified; drop back to 12.3 if the
# server reports unsupported-version problems.
# https://www.zabbix.com/documentation/7.4/en/manual/installation/requirements
VERSION_MARIADB=13.0.2

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
# NOTE: extend additional info here ...
```

#### example short .env (swarm)

```env
DOMAIN=zabbix.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=zabbix.home.local
```

---

## FAQ

### Default credentials

- Username: `Admin`
- Password: `zabbix` # pragma: allowlist secret

---

## References

- <https://www.zabbix.com/>
- <https://github.com/zabbix/zabbix>
- <https://www.zabbix.com/documentation/current/en/manual/installation/containers>
- <https://github.com/zabbix/zabbix-docker>
- <https://shop.ntop.org/?filter=only_linux>
