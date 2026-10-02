# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

```sh
echo "JWT_SECRET=$(openssl rand -base64 64 | tr -d '\n')" >> .env
echo "ENCRYPTION_KEY=$(pwgen -s 32 1)" >> .env
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
DOMAIN=check.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=80
PROTOCOL_SERVER=http
PORT_SERVER=52345
# default-secured@file | public-secured@file | authentik@file
# opt in to crowdsec bans: bouncer-crowdsec@file,default-secured@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=2
RESOURCES_LIMITS_MEMORY=2g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_VALKEY=1
RESOURCES_LIMITS_MEMORY_VALKEY=128m
RESOURCES_RESERVATIONS_CPUS_VALKEY=0.001
RESOURCES_RESERVATIONS_MEMORY_VALKEY=32m

RESOURCES_LIMITS_CPUS_MONGODB=1
RESOURCES_LIMITS_MEMORY_MONGODB=2g
RESOURCES_RESERVATIONS_CPUS_MONGODB=0.001
RESOURCES_RESERVATIONS_MEMORY_MONGODB=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_CHECKMATE=v2.3.1
VERSION_VALKEY=9.1.2-alpine
VERSION_MONGODB=8.3.9

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
JWT_SECRET=<SECRET>
ENCRYPTION_KEY=<SECRET>
```

#### example short .env

```env
DOMAIN=check.home.local
```

---

## References

- <https://checkmate.so/>
- <https://github.com/bluewave-labs/Checkmate>
  - <https://github.com/bluewave-labs/Checkmate/tree/develop/docker/dist>
- <https://github.com/bluewave-labs/capture>
- <https://docs.checkmate.so/users-guide/quickstart>
  - <https://docs.checkmate.so/users-guide/quickstart#env-vars-server>
