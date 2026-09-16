# SETUP

## basic

### create your `secrets`:

```sh
echo "$(htpasswd -nB traefik)" > config/secrets/traefik_basicauth_secret.txt

echo '<GEO_IP_ACCOUNT_ID>' > config/secrets/geoipupdate_account_id.txt
echo '<GEO_IP_LICENSE_KEY>' > config/secrets/geoipupdate_license_key.txt

echo "$(pwgen -s 32 1)" > config/secrets/server_secret.txt # `pangctl rotate-server-secret`
echo '<EMAIL_SMTP_PASSWORD>' > config/secrets/email_smtp_pass.txt

echo '<YOUR_API_TOKEN>' > config/secrets/dnschallenge_api_key_secret.txt
# replace `IONOS_API_KEY_FILE` with your provider => https://go-acme.github.io/lego/dns/index.html
echo "IONOS_API_KEY_FILE=/run/secrets/dnschallenge_api_key_secret" >> .env # pragma: allowlist secret
echo "CERTIFICATES_ACME_DNSCHALLENGE_PROVIDER=ionos" >> .env
```

### create config files:

> Replace min. `home.local`.

```sh
# one source of truth for all domains/keys
TMP_DOMAIN_BASE="home.local"
TMP_DOMAIN_DASHBOARD="proxy.${TMP_DOMAIN_BASE}"
TMP_DOMAIN_TRAEFIK="traefik.${TMP_DOMAIN_BASE}"
TMP_SMTP_HOST="smtp.ionos.de"
TMP_LAPI_KEY="$(pwgen -s 32 1)"

# render each config from its template (one command per file)
sed -e "s|<REPLACE_TRAEFIK_DOMAIN>|${TMP_DOMAIN_TRAEFIK}|" \
    -e "s|<REPLACE_DASHBOARDURL>|${TMP_DOMAIN_DASHBOARD}|" \
    -e "s|<REPLACE_LAPI_KEY>|${TMP_LAPI_KEY}|" \
    ./config/traefik/dynamic_config.yml.tmpl > ./config/traefik/dynamic_config.yml

sed -e "s|<REPLACE_DASHBOARDURL>|${TMP_DOMAIN_DASHBOARD}|" \
    -e "s|<REPLACE_BASEDOMAIN>|${TMP_DOMAIN_BASE}|" \
    -e "s|<REPLACE_SMTP_HOST>|${TMP_SMTP_HOST}|" \
    ./config/pangolin/config.yml.tmpl > ./config/pangolin/config.yml

cp ./config/pangolin/privateConfig.yml.tmpl ./config/pangolin/privateConfig.yml

# derive the remaining app values into `.env`:
cat >> .env <<EOF
BASEDOMAIN=${TMP_DOMAIN_BASE}
DASHBOARDURL=${TMP_DOMAIN_DASHBOARD}
CERTIFICATES_ACME_EMAIL=info@${TMP_DOMAIN_BASE}
EMAIL_SMTP_USER=no-reply@${TMP_DOMAIN_BASE}
BOUNCER_KEY_traefik=${TMP_LAPI_KEY}
EOF
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS_GERBIL=2
RESOURCES_LIMITS_MEMORY_GERBIL=512m

RESOURCES_LIMITS_CPUS_PANGOLIN=2
RESOURCES_LIMITS_MEMORY_PANGOLIN=2g

RESOURCES_LIMITS_CPUS_TRAEFIK=1
RESOURCES_LIMITS_MEMORY_TRAEFIK=512m

RESOURCES_LIMITS_CPUS_CROWDSEC=1
RESOURCES_LIMITS_MEMORY_CROWDSEC=512m

RESOURCES_LIMITS_CPUS_GEOIPUPDATE=1
RESOURCES_LIMITS_MEMORY_GEOIPUPDATE=64m


# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_PANGOLIN=1.23.0
VERSION_GERBIL=1.5.1
VERSION_TRAEFIK=v3.7.13
VERSION_BADGER=v1.7.0
VERSION_CROWDSEC_PLUGIN=v1.7.1
VERSION_CROWDSEC=v1.8.1-debian
VERSION_MAXMIND=v8.0.0

VERSION_NEWT=1.17.0
VERSION_CLI=0.17.0
VERSION_OLM=1.9.1

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERTIFICATES_ACME_CASERVER=https://acme-staging-v02.api.letsencrypt.org/directory # https://acme-v02.api.letsencrypt.org/directory
CERTIFICATES_ACME_DNSCHALLENGE_PROVIDER=ionos # https://doc.traefik.io/traefik/https/acme/#providers
CERTIFICATES_ACME_DNSCHALLENGE_RESOLVERS=9.9.9.9,194.242.2.2,1.1.1.1
IONOS_API_KEY_FILE=/run/secrets/dnschallenge_api_key_secret # https://go-acme.github.io/lego/dns/index.html

TRAEFIK_API=false
TRAEFIK_API_DASHBOARD=false

# CERTIFICATES_ACME_CASERVER=https://acme.zerossl.com/v2/DV90 # needs EAB Credentials (EAB KID & EAB HMAC Key)
# CERTIFICATES_ACME_EAB_KID=<EAB_KID>
# CERTIFICATES_ACME_EAB_HMACENCODED=<EAB_HMACENCODED>
```

#### example short .env

```env
CERTIFICATES_ACME_CASERVER=https://acme-v02.api.letsencrypt.org/directory
```

## NEWT setup

### create `.env` file following:

```env
PANGOLIN_ENDPOINT=<Newt Endpoint>
NEWT_ID=<Newt ID>
NEWT_SECRET=<Newt Secret Key>
```

### copy/update `docker-compose-newt.override.yaml.tmpl`

```sh
cp docker-compose-newt.override.yaml.tmpl docker-compose-newt.override.yaml
```

extend `networks` sections with your network names where `newt` should have access for and will tunnel over `pangolin`.

---

## FAQ

### Crowdsec

#### Test block

```sh
# List decisions
docker exec -it "$(docker ps -q -f name=crowdsec)" cscli decisions list
# Manually creating a decision against a public IP of one of your devices
docker exec -it "$(docker ps -q -f name=crowdsec)" \
cscli decisions add --ip <your-public-ip> --duration 1m --type ban --reason "CrowdSec remediation test"
```

#### Helpful information's

```sh
docker exec -it "$(docker ps -q -f name=crowdsec)" cscli metrics
```

### CLI

> <https://docs.pangolin.net/manage/clients/configure-client>

Personal recommended configs:

```sh
pangolin config set up.prefer_local_routes true
```

### NEWT as binary with user scope

```sh
curl -fsSL https://static.pangolin.net/get-newt.sh | bash -s -- --path "$HOME/.local/bin"
```

#### Systemd-Service

```sh
install -d -m 0750 "$HOME/.config/newt"
 tee "$HOME/.config/newt/newt.env" > /dev/null << 'EOF'
NEWT_ID=<TODO>
NEWT_SECRET=<TODO>
PANGOLIN_ENDPOINT=<TODO>
EOF
chmod 600 "$HOME/.config/newt/newt.env"
```

```sh
tee "$HOME/.config/systemd/user/newt.service" >/dev/null <<EOF
[Unit]
Description=Newt
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
EnvironmentFile="$HOME/.config/newt/newt.env"
ExecStart="$HOME/.local/bin/newt" -log-level WARN
Restart=always
RestartSec=5
UMask=0077

NoNewPrivileges=true
PrivateTmp=true

[Install]
WantedBy=default.target

EOF

systemctl --user daemon-reload
systemctl --user enable --now newt
sudo loginctl enable-linger $USER
```

### CLI as binary with user scope

```sh
curl -fsSL https://static.pangolin.net/get-cli.sh | bash -s -- --path "$HOME/.local/bin"
#sudo setcap 'cap_net_admin=ep cap_net_bind_service=ep' "$HOME/.local/bin/pangolin"

pangolin login
pangolin up
```

#### Systemd-Service

```sh
install -d -m 0750 "$HOME/.config/pangolin"
 tee "$HOME/.config/pangolin/cli.env" > /dev/null << 'EOF'
CLIENT_ID=<TODO>
CLIENT_SECRET=<TODO>
PANGOLIN_ENDPOINT=<TODO>

DNS=1.1.1.1
UPSTREAM_DNS=1.1.1.1:53
OVERRIDE_DNS=true
TUNNEL_DNS=true
EOF
chmod 600 "$HOME/.config/pangolin/cli.env"
```

```sh
tee "$HOME/.config/systemd/user/pangolin.service" >/dev/null <<EOF
[Unit]
Description=Pangolin CLI
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
EnvironmentFile="$HOME/.config/pangolin/cli.env"
ExecStart="$HOME/.local/bin/pangolin" up --attach
Restart=always
RestartSec=5
UMask=0077

NoNewPrivileges=true
PrivateTmp=true

[Install]
WantedBy=default.target

EOF

systemctl --user daemon-reload
systemctl --user enable --now pangolin
sudo loginctl enable-linger $USER
```

### Enterprise-Edition

> [`Free for individuals and small businesses`](https://docs.pangolin.net/self-host/enterprise-edition#licensing-overview)

```env
VERSION_PANGOLIN=ee-<VERSION>
```

When Pangolin is started you need navigate to `/admin/license` and enter the [license key](https://app.pangolin.net/).

---

## Future notes

```sh
echo "wireguard" | sudo tee -a /etc/modules-load.d/modules.conf
```

---

## References

- <https://github.com/fosrl>
  - <https://github.com/fosrl/pangolin>
- docker
  - <https://docs.pangolin.net/self-host/manual/docker-compose>
- pangolin
  - <https://docs.pangolin.net/self-host/advanced/config-file>
- newt/client
  - <https://docs.pangolin.net/manage/sites/install-site>
  - <https://docs.pangolin.net/manage/sites/configure-site>
  - <https://docs.pangolin.net/manage/clients/install-client>
  - <https://docs.pangolin.net/manage/clients/configure-client>
- other
  - [acme](https://go-acme.github.io/lego/dns/ionos/)
  - [crowdsec](https://docs.pangolin.net/self-host/community-guides/crowdsec#crowdsec)
  - [maxmind](https://github.com/maxmind/geoipupdate/blob/main/doc/docker.md)
