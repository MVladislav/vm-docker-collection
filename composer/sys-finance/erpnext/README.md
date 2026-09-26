# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

```sh
pwgen -s 32 1 > config/secrets/mariadb_root_password.txt
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
DOMAIN=erp.home.local # not set in docker-compose, needs to be copied to .env
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

RESOURCES_LIMITS_CPUS_MARIADB=1
RESOURCES_LIMITS_MEMORY_MARIADB=512m
RESOURCES_RESERVATIONS_CPUS_MARIADB=0.001
RESOURCES_RESERVATIONS_MEMORY_MARIADB=32m

RESOURCES_LIMITS_CPUS_VALKEY=1
RESOURCES_LIMITS_MEMORY_VALKEY=128m
RESOURCES_RESERVATIONS_CPUS_VALKEY=0.001
RESOURCES_RESERVATIONS_MEMORY_VALKEY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_ERPNEXT=v15.70.0
VERSION_MARIADB=13.0.2
VERSION_VALKEY=9.1.2-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
ERPNEXT_PASSWORD=<ADMIN-PASSWORD>
```

#### example short .env (swarm)

```env
DOMAIN=erp.home.local
ERPNEXT_PASSWORD=admin
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=erp.home.local
ERPNEXT_PASSWORD=admin
```

---

## References

- <https://frappe.io/erpnext>
- <https://github.com/frappe/erpnext>
- <https://github.com/frappe/frappe_docker>
  - <https://github.com/frappe/frappe_docker/blob/main/pwd.yml>
