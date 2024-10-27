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
  - [References](#references)

---

## basic

> defined to work with treafik

### create your `secrets`:

```sh
$pwgen -s 18 1 > config/secrets/session_secret.txt
$pwgen -s 18 1 > config/secrets/wgui_password.txt
# $pwgen -s 18 1 > config/secrets/sendgrid_api_key.txt
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=wg.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=5000
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
VERSION=latest

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
WGUI_USERNAME=groot
WGUI_DNS=9.9.9.9
WGUI_LOG_LEVEL=INFO # DEBUG|INFO|WARN|ERROR|OFF
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=wg.home.local
VERSION=latest
```

---

## References

- <https://github.com/ngoduykhanh/wireguard-ui>
