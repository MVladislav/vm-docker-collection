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
  - [Notes](#notes)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

> instead of openssl for password you can also use `pwgen -s 50 1`

```sh
$openssl rand -base64 18 > config/secrets/mariadb_user_password.txt
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=net.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=80
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=300m
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=v0.15.2

MARIADB_PASSWORD=<PASSWORD IS CURRENT ALSO AS ENV NEEDED>
```

#### example short .env

```env
DOMAIN=net.home.local
VERSION=v0.15.2

MARIADB_PASSWORD=<PASSWORD IS CURRENT ALSO AS ENV NEEDED>
```

## Notes

Default credentials

- username: `admin@example.com`
- password: `password` # pragma: allowlist secret

---

## References

- <https://github.com/alexjustesen/speedtest-tracker>
- <https://docs.speedtest-tracker.dev/getting-started/installation/installation>
- <https://github.com/alexjustesen/speedtest-tracker/pkgs/container/speedtest-tracker>
