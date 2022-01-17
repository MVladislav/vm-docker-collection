# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
    - [create self signed tls cert](#create-self-signed-tls-cert)
  - [References](#references)

---

## basic

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=latest
PORT=3443

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

### create self signed tls cert

```sh
$openssl req -x509 -nodes -newkey rsa:2048 \
-keyout $PWD/config/ssl/grafana-selfsigned.key \
-out $PWD/config/ssl/grafana-selfsigned.crt \
-days 999 \
-addext "subjectAltName=DNS:home.local,IP:127.0.0.1" \
-subj "/C=DE/ST=BW/L=A/O=VM/OU=VM/CN=home.local"
```

---

## References

- <https://grafana.com/docs/grafana/latest/installation/docker/>
- <https://grafana.com/docs/grafana/latest/getting-started/getting-started/>
- <https://github.com/b4b857f6ee/opnsense_grafana_dashboard>
