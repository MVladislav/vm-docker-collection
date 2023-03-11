# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
  - [password forgot or not work](#password-forgot-or-not-work)
  - [References](#references)

---

## basic

> defined to work with treafik

### create your `secrets`:

```sh
$echo "swordfish" > config/secrets/admin_password_file_secret.txt
```

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=9.4.3

LB_SWARM=true
DOMAIN=grafana.home.local
PROTOCOL=http
PORT=3000
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

GF_SECURITY_ADMIN_USER=groot

GF_USERS_ALLOW_SIGN_UP=false
GF_SMTP_ENABLED=false
GF_SMTP_HOST=
GF_SMTP_USER=
GF_SMTP_PASSWORD=
GF_SMTP_FROM_ADDRESS=
GF_INSTALL_PLUGINS=magnesium-wordcloud-panel,flant-statusmap-panel,grafana-piechart-panel,grafana-worldmap-panel
```

## password forgot or not work

```sh
$docker exec "$(docker ps -q -f name=grafana)" grafana-cli admin reset-admin-password <PASSWORD>
```

---

## References

- <https://grafana.com/docs/grafana/latest/installation/docker/>
- <https://grafana.com/docs/grafana/latest/getting-started/getting-started/>
- <https://github.com/b4b857f6ee/opnsense_grafana_dashboard>
- <https://grafana.com/docs/grafana/latest/setup-grafana/configure-docker/>
