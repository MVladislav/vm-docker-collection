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
    - [Default credentials](#default-credentials)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

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
DOMAIN_FRONT=dtrack.home.local # not set in docker-compose, needs to be copied to .env
DOMAIN_API=dtrack-api.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8080
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=2
RESOURCES_LIMITS_MEMORY=4.5g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_DTRACK=4.12.5
VERSION_POSTGRESQL=17.3-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
# NOTE: extend additional info here ...
```

#### example short .env

```env
DOMAIN_FRONT=dtrack.home.local
DOMAIN_API=dtrack-api.home.local
```

## FAQ

> **The initial mirroring may take between 10 - 30 minutes or more.**
> Do not interrupt this process. Wait for the completion of all mirroring tasks before shutting down the system.
> These tasks can be monitored by watching the Docker containers console.

### Default credentials

- username: `admin`
- password: `admin` # pragma: allowlist secret

---

## References

- <https://dependencytrack.org/>
- <https://github.com/DependencyTrack/dependency-track>
- <https://docs.dependencytrack.org/getting-started/deploy-docker/>
