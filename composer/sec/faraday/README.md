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
  - [Note](#note)
    - [credentials](#credentials)
    - [passwort reset](#passwort-reset)
  - [References](#references)

---

## basic

> defined to work with treafik

### create your `secrets`:

> instead of openssl for password you can also use `pwgen -s 50 1`

```sh
$openssl rand -base64 18 > config/secrets/postgres_password_file.txt
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
DOMAIN=faraday.home.local
PROTOCOL=http
PORT=5985
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_POSTGRESQL=1
RESOURCES_LIMITS_MEMORY_POSTGRESQL=500M
RESOURCES_RESERVATIONS_CPUS_POSTGRESQL=0.001
RESOURCES_RESERVATIONS_MEMORY_POSTGRESQL=32m
RESOURCES_LIMITS_CPUS_REDIS=1
RESOURCES_LIMITS_MEMORY_REDIS=128M
RESOURCES_RESERVATIONS_CPUS_REDIS=0.001
RESOURCES_RESERVATIONS_MEMORY_REDIS=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_FARADAY=5.1.1
VERSION_POSTGRESQL=16.2-alpine3.19
VERSION_REDIS=7.2.4-alpine3.19
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=faraday.home.local

# password over secrets seems current not to work
PGSQL_PASSWD=<ADD_PASSWORD>
```

## Note

### credentials

- **username**: `faraday`
- **password**: _is printed in logs_

### passwort reset

```sh
faraday-manage change-password
```

---

## References

- <https://faradaysec.com>
- <https://docs.faradaysec.com/Install-guide-Docker/>
- <https://github.com/infobyte/faraday>
- <https://github.com/infobyte/faraday/blob/master/docker-compose.yaml>
- <https://hub.docker.com/r/faradaysec/faraday>
- <https://docs.faradaysec.com/import/>
- alternatives
  - <https://hexway.io/pricing>
    - `sudo apt-get install uidmap`
  - <https://reconmap.com/pricing>
  - <https://attackforge.com/pricing>
