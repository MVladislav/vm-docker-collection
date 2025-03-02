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
  - [Helper](#helper)
    - [password forgot or not work](#password-forgot-or-not-work)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$pwgen -s 18 1 > config/secrets/admin_password_file_secret.txt
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
DOMAIN=grafana.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=3000
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=2
RESOURCES_LIMITS_MEMORY=2g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=11.5.2

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
GF_SECURITY_ADMIN_USER=groot
GF_USERS_ALLOW_SIGN_UP=false

GF_INSTALL_PLUGINS=magnesium-wordcloud-panel,flant-statusmap-panel,grafana-piechart-panel,grafana-worldmap-panel

GF_SMTP_ENABLED=false
GF_SMTP_HOST=
GF_SMTP_USER=
GF_SMTP_PASSWORD=
GF_SMTP_FROM_ADDRESS=
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=grafana.home.local
```

---

## Helper

### password forgot or not work

```sh
$docker exec "$(docker ps -q -f name=grafana)" grafana-cli admin reset-admin-password <PASSWORD>
```

---

## References

- <https://grafana.com/docs/grafana/latest/installation/docker/>
- <https://grafana.com/docs/grafana/latest/getting-started/getting-started/>
- <https://github.com/b4b857f6ee/opnsense_grafana_dashboard>
- <https://grafana.com/docs/grafana/latest/setup-grafana/configure-docker/>
