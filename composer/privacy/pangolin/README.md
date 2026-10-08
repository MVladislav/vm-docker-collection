# SETUP

## basic

### create your `secrets`:

```sh
echo "$(htpasswd -nB traefik)" > config/secrets/traefik_basicauth_secret.txt

# REQUIRED, not optional: pangolin opens /app/geo/GeoLite2-*.mmdb at startup with
# no existsSync guard, and docker-compose.yaml holds it until geoipupdate reports
# healthy. Invalid or missing credentials -> "dependency failed to start:
# container ...-geoipupdate-1 is unhealthy".
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
RESOURCES_LIMITS_MEMORY_CROWDSEC=1g

RESOURCES_LIMITS_CPUS_GEOIPUPDATE=1
RESOURCES_LIMITS_MEMORY_GEOIPUPDATE=64m


# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_PANGOLIN=1.24.0
VERSION_GERBIL=1.5.2
VERSION_TRAEFIK=v3.7.14
VERSION_BADGER=v1.7.0
VERSION_CROWDSEC_PLUGIN=v1.7.1
VERSION_CROWDSEC=v1.8.1-debian
VERSION_MAXMIND=v8.0.0

VERSION_NEWT=1.18.0
VERSION_CLI=0.18.0
VERSION_OLM=1.10.0
VERSION_ALPINE=3.24.1

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

### start & first login

```sh
docker compose up -d
docker compose ps                                   # pangolin, traefik, gerbil: running
docker compose logs pangolin | grep -A1 'Token:'   # one-time, first boot only
```

Then register the first admin with that token:

```text
https://<dashboard-domain>/auth/initial-setup
```

> The first ACME request can take a minute, so a browser warning on the first load
> is normal - reload once the certificate is issued.

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

## Guides & Insights

### Crowdsec

What: the Traefik bouncer + AppSec WAF are bound to the `websecure` entrypoint, so
they cover the dashboard **and** every resource router Pangolin generates. Three
layers: access-log IP/behaviour bans, in-band virtual patching (403 on the spot),
OWASP CRS (alert, then ban after 5 hits / 30 s).

```sh
cs() { docker exec -it "$(docker ps -q -f name=crowdsec)" "$@"; }

cs cscli decisions list        # active bans, [] means none
cs cscli alerts list           # why someone was banned
cs cscli metrics               # WAF processed / blocked
cs cscli appsec-configs list   # loaded rule sets
```

A new decision needs up to 60 s to take effect (the bouncer caches the ban list).

#### Test the WAF

Virtual patching is immediate - one request answers 403:

```sh
curl -sk -o /dev/null -w '%{http_code}\n' \
  https://<domain>/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php   # 403
```

Behaviour bans need a burst, not a single hit (leaky buckets, and repeated identical
paths do not count):

```sh
for p in /.env /.git/config /.aws/credentials /.ssh/id_rsa /.DS_Store; do
  curl -sk -o /dev/null "https://<domain>$p"
done
cs cscli decisions list
```

Ban yourself for a minute:

```sh
cs cscli decisions add --ip <your-public-ip> --duration 1m --type ban --reason test
```

#### Web UI (opt-in)

Default is `DISABLE_ONLINE_API=true`: no `api.crowdsec.net` contact, no telemetry,
no community blocklist. `cscli` is the source of truth until you opt in.

| UI                   | needs                                                                 | trade-off                                              |
| -------------------- | --------------------------------------------------------------------- | ------------------------------------------------------ |
| **Metabase** (local) | uncomment `crowdsec-dashboard` + a router with `default-secured@file` | reads `crowdsec_db` read-only, nothing leaves the host |
| **Console** (cloud)  | account at <https://app.crowdsec.net> + `DISABLE_ONLINE_API=false`    | third party in the data path                           |

Console, three steps:

```sh
docker exec -it $(docker ps -q -f name=crowdsec) \
  cscli console enroll --quick --name pangolin-crowdsec --tags docker
# open the printed https://app.crowdsec.net/quick-enroll?token=... URL (16 min),
# approve it, then:
docker compose restart crowdsec
```

`--name` / `--tags` are the same values as `ENROLL_INSTANCE_NAME` /
`ENROLL_TAGS` in `docker-compose.yaml`; cscli reads the flags, not the env.

```sh
cs cscli machines list
cs cscli capi status
```

Enabling the console also re-enables the community blocklist - the only detection
content you get back. `cscli hub update` (collections + CRS rules) runs daily either
way and has no switch.

#### SSH / host: firewall bouncer

CrowdSec remediates the HTTP layer only. SSH, WireGuard and RawTCP need the bouncer
**on the host**: <https://docs.crowdsec.net/u/bouncers/firewall/>

```sh
sudo apt install crowdsec-firewall-bouncer-iptables
docker exec crowdsec cscli bouncers add vps-firewall
# paste the printed key into /etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml
sudo systemctl restart crowdsec-firewall-bouncer
```

It needs the LAPI on `crowdsec:8080`, which is stack-internal. Publish it, then lock
it down - docker publishes on every interface:

```yaml
crowdsec:
  ports:
    - target: 8080
      published: 8080
      mode: host
```

```sh
sudo ufw allow from 127.0.0.1 to any port 8080 proto tcp
sudo ufw deny 8080/tcp
```

Port-scan detection: log dropped packets, `config/crowdsec/syslog.yaml` already reads
`/var/log/syslog`.

```sh
sudo iptables -A INPUT -j LOG --log-prefix "iptables: "
```

#### Multi-node only

Single node: `:443` goes straight to Traefik, so the real client IP is already visible.
Multi-node: gerbil forwards to a peer, so publish `443:8443` (its SNI proxy) and tell
Traefik to read the PROXY header.

```yaml
traefik:
  ports:
    - target: 8443
      published: 443
  environment:
    TRAEFIK_ENTRYPOINTS_WEBSECURE_PROXYPROTOCOL_TRUSTEDIPS: 127.0.0.1/32,::1/128
```

> Never on a single node - Traefik would then require the header on every connection.

### Pangolin CLI

> <https://docs.pangolin.net/manage/clients/configure-client>

```sh
curl -fsSL https://static.pangolin.net/get-cli.sh | bash -s -- --path "$HOME/.local/bin"

pangolin login
pangolin config set up.prefer_local_routes true   # personal recommendation
pangolin up
```

#### systemd user unit

```sh
install -d -m 0750 "$HOME/.config/pangolin"
 tee "$HOME/.config/pangolin/cli.env" >/dev/null <<'EOF'
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

### Newt as binary

```sh
curl -fsSL https://static.pangolin.net/get-newt.sh | bash -s -- --path "$HOME/.local/bin"
```

#### systemd user unit

```sh
install -d -m 0750 "$HOME/.config/newt"
tee "$HOME/.config/newt/newt.env" >/dev/null <<'EOF'
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

### Enterprise Edition

> [`Free for individuals and small businesses`](https://docs.pangolin.net/self-host/enterprise-edition#licensing-overview)

Same repository, only the tag differs - no compose edit. Set the pinned version in
`.env` to the `ee-` prefixed tag of the version above (for `1.24.0` that is
`ee-1.24.0`).

Other prefixes: `postgresql-<version>`, `ee-postgresql-<version>`. The trailing `-`
matters: `ee-1.24.0` is published, `ee1.24.0` is not.

After start: `/admin/license` → paste the key from <https://app.pangolin.net/>.

### WireGuard kernel module

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
  - [crowdsec appsec](https://docs.crowdsec.net/docs/appsec/quickstart/general_setup/)
  - [owasp crs](https://docs.crowdsec.net/docs/appsec/crs/intro/)
  - [crowdsec bouncer plugin](https://plugins.traefik.io/plugins/6335346ca4caa9ddeffda116/crowdsec-bouncer-traefik-plugin)
  - [maxmind](https://github.com/maxmind/geoipupdate/blob/main/doc/docker.md)
