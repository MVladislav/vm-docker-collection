# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create config files:](#create-config-files)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [NEWT setup](#newt-setup)
    - [create `.env` file following:](#create-env-file-following-1)
    - [copy/update `docker-compose-newt.override.yaml.tmpl`](#copyupdate-docker-compose-newtoverrideyamltmpl)
  - [FAQ](#faq)
    - [Crowdsec](#crowdsec)
      - [Test block](#test-block)
      - [Other](#other)
      - [Enterprise-Edition](#enterprise-edition)
  - [References](#references)

---

## basic

### create your `secrets`:

```sh
$echo "$(htpasswd -nB traefik)" > config/secrets/traefik_basicauth_secret.txt

$echo '<YOUR_API_TOKEN>' > config/secrets/dnschallenge_api_key_secret.txt
# replace `IONOS_API_KEY_FILE` with your provider => https://go-acme.github.io/lego/dns/index.html
$echo "IONOS_API_KEY_FILE=/run/secrets/dnschallenge_api_key_secret" >> .env # pragma: allowlist secret
$echo "CERTIFICATES_ACME_DNSCHALLENGE_PROVIDER=ionos" >> .env

$echo '<GEO_IP_ACCOUNT_ID>' > config/secrets/geoipupdate_account_id.txt
$echo '<GEO_IP_LICENSE_KEY>' > config/secrets/geoipupdate_license_key.txt
```

### create config files:

> Replace min. `home.local`.

```sh
$TMP_DOMAIN_BASE="home.local"
$TMP_DOMAIN_DASHBOARD="proxy.${TMP_DOMAIN_BASE}"
$TMP_DOMAIN_TRAEFIK="traefik.${TMP_DOMAIN_BASE}"
$TMP_SMTP_HOST="smtp.ionos.de"

$cp ./config/traefik/dynamic_config.yml.tmpl ./config/traefik/dynamic_config.yml
$cp ./config/pangolin/config.yml.tmpl ./config/pangolin/config.yml

$sed "s|<REPLACE_TRAEFIK_DOMAIN>|${TMP_DOMAIN_TRAEFIK}|" -i  ./config/traefik/dynamic_config.yml
$sed "s|<REPLACE_DASHBOARDURL_DOMAIN>|${TMP_DOMAIN_DASHBOARD}|" -i  ./config/traefik/dynamic_config.yml

$sed "s|<REPLACE_DASHBOARDURL_DOMAIN>|${TMP_DOMAIN_DASHBOARD}|" -i  ./config/pangolin/config.yml
$sed "s|<REPLACE_BASE_DOMAIN>|${TMP_DOMAIN_BASE}|" -i  ./config/pangolin/config.yml
$sed "s|<REPLACE_SMTP_HOST>|${TMP_SMTP_HOST}|" -i  ./config/pangolin/config.yml

$echo "BASEDOMAIN=${TMP_DOMAIN_BASE}" >> .env
$echo "DASHBOARDURL=${TMP_DOMAIN_DASHBOARD}" >> .env
$echo "CERTIFICATES_ACME_EMAIL=info@${TMP_DOMAIN_BASE}" >> .env
$echo "SERVER_SECRET=$(pwgen -s 32 1)" >> .env
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=4
RESOURCES_LIMITS_MEMORY=2g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_PANGOLIN=1.15.1
VERSION_GERBIL=1.3.0
VERSION_TRAEFIK=v3.6.7
VERSION_BADGER=v1.3.1
VERSION_CROWDSEC_PLUGIN=v1.4.7
VERSION_CROWDSEC=v1.7.6
VERSION_MAXMIND=v7.1.1

VERSION_NEWT=1.9.0
VERSION_CLI=0.3.3
VERSION_OLM=1.4.2

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
BASEDOMAIN=<BASE_DOMAIN>
DASHBOARDURL=<REPLACE_DASHBOARDURL_DOMAIN>

CERTIFICATES_ACME_EMAIL=<E-MAIL>
CERTIFICATES_ACME_CASERVER=https://acme-staging-v02.api.letsencrypt.org/directory # https://acme-v02.api.letsencrypt.org/directory
CERTIFICATES_ACME_DNSCHALLENGE_PROVIDER=ionos # https://doc.traefik.io/traefik/https/acme/#providers
CERTIFICATES_ACME_DNSCHALLENGE_RESOLVERS=9.9.9.9,194.242.2.2,1.1.1.1
IONOS_API_KEY_FILE=/run/secrets/dnschallenge_api_key_secret # https://go-acme.github.io/lego/dns/index.html

TRAEFIK_API=false
TRAEFIK_API_DASHBOARD=false

SERVER_SECRET=<GENERATE_SERVER_SECRET>
EMAIL_SMTP_PASS=<EMAIL_PASSWORD>

# CERTIFICATES_ACME_CASERVER=https://acme.zerossl.com/v2/DV90 # needs EAB Credentials (EAB KID & EAB HMAC Key)
# CERTIFICATES_ACME_EAB_KID=<EAB_KID>
# CERTIFICATES_ACME_EAB_HMACENCODED=<EAB_HMACENCODED>
```

#### example short .env

```env
CERTIFICATES_ACME_CASERVER=https://acme-v02.api.letsencrypt.org/directory
EMAIL_SMTP_PASS=<EMAIL_PASSWORD>
```

## NEWT setup

### create `.env` file following:

```env
PANGOLIN_ENDPOINT=<Newt Endpoint>
NEWT_ID=<Newt ID>
NEWT_SECRET=<Newt Secret Key>
```

### copy/update `docker-compose-newt.override.yaml.tmpl`

```
$cp docker-compose-newt.override.yaml.tmpl docker-compose-newt.override.yaml
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

#### Other

```sh
docker exec -it "$(docker ps -q -f name=crowdsec)" cscli metrics
```

#### Enterprise-Edition

> [`Free for individuals and small businesses`](https://docs.pangolin.net/self-host/enterprise-edition#licensing-overview)

```env
VERSION_PANGOLIN=ee-<VERSION>
```

When Pangolin is started you need navigate to `/admin/license` and enter the [license key](https://app.pangolin.net/).

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
