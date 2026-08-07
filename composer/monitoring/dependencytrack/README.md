# SETUP

## basic

> defined to work with traefik

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=dtrack.home.local # not set in docker-compose, needs to be copied to .env
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
VERSION=latest

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates
```

#### example short .env (swarm)

```env
DOMAIN=dtrack.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=dtrack.home.local
```

---

## Guides & Insights

### Initial Credentials

| Username | Password |
| -------- | -------- |
| `admin`  | `admin`  |

---

## References

- <https://dependencytrack.org/>
- <https://github.com/DependencyTrack/dependency-track>
- <https://dependencytrack.github.io/docs/next/tutorials/quickstart/>
  - <https://github.com/DependencyTrack/docs/blob/main/docs/tutorials/docker-compose.quickstart.yml>
