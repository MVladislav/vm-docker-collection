# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [References](#references)

---

## basic

> defined to work with treafik

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=latest
PORT=3443

DOMAIN=grafana.home.local

GF_SECURITY_ADMIN_USER=root
GF_SECURITY_ADMIN_PASSWORD=swordfish

GF_USERS_ALLOW_SIGN_UP=false
GF_SERVER_DOMAIN=grafana.home.local
GF_SMTP_ENABLED=false
GF_SMTP_HOST=
GF_SMTP_USER=
GF_SMTP_PASSWORD=
GF_SMTP_FROM_ADDRESS=
GF_INSTALL_PLUGINS=magnesium-wordcloud-panel,flant-statusmap-panel,grafana-piechart-panel,grafana-worldmap-panel
```

---

## References

- <https://grafana.com/docs/grafana/latest/installation/docker/>
- <https://grafana.com/docs/grafana/latest/getting-started/getting-started/>
- <https://github.com/b4b857f6ee/opnsense_grafana_dashboard>
