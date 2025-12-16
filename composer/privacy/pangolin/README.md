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
  - [References](#references)

---

## basic

### create your `secrets`:

```sh
$echo $(htpasswd -nB traefik) > config/secrets/traefik_basicauth_secret.txt
$echo '<YOUR_API_TOKEN>' > config/secrets/dnschallenge_api_key_secret.txt

# Create maxmind secrets and put your secrets in
$touch config/secrets/geoipupdate_account_id.txt
$touch config/secrets/geoipupdate_license_key.txt
```

### create config files:

> Replace min. `home.local`.

```sh
$TMP_DOMAIN_BASE="home.local"
$TMP_DOMAIN_DASHBOARD="proxy.${TMP_DOMAIN_BASE}"
$TMP_DOMAIN_TRAEFIK="traefik.${TMP_DOMAIN_BASE}"

$cp ./config/traefik/dynamic_config.yml.tmpl ./config/traefik/dynamic_config.yml
$cp ./config/pangolin/config.yml.tmpl ./config/pangolin/config.yml

$sed "s|<REPLACE_TRAEFIK_DOMAIN>|${TMP_DOMAIN_TRAEFIK}|" -i  ./config/traefik/dynamic_config.yml
$sed "s|<REPLACE_DASHBOARDURL_DOMAIN>|${TMP_DOMAIN_DASHBOARD}|" -i  ./config/traefik/dynamic_config.yml

$sed "s|<REPLACE_DASHBOARDURL_DOMAIN>|${TMP_DOMAIN_DASHBOARD}|" -i  ./config/pangolin/config.yml
$sed "s|<REPLACE_BASE_DOMAIN>|${TMP_DOMAIN_BASE}|" -i  ./config/pangolin/config.yml
$sed "s|<REPLACE_SERVER_SECRET>|$(pwgen -s 32 1)|" -i  ./config/pangolin/config.yml

$echo "BASEDOMAIN=${TMP_DOMAIN_BASE}" >> .env
$echo "DASHBOARDURL=${TMP_DOMAIN_DASHBOARD}" >> .env
$echo "CERTIFICATES_ACME_EMAIL=info@${TMP_DOMAIN_BASE}" >> .env
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
VERSION_PANGOLIN=1.13.1
VERSION_GERBIL=1.3.0
VERSION_TRAEFIK=v3.6.4
VERSION_BADGER=v1.2.1
VERSION_CROWDSEC_PLUGIN=v1.4.7
VERSION_CROWDSEC=v1.7.4
VERSION_MAXMIND=v7.1.1

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
DASHBOARDURL=<REPLACE_DASHBOARDURL_DOMAIN>
BASEDOMAIN=<BASE_DOMAIN>

CERTIFICATES_ACME_CASERVER=https://acme-staging-v02.api.letsencrypt.org/directory # https://acme-v02.api.letsencrypt.org/directory
CERTIFICATES_ACME_CASERVER=https://acme.zerossl.com/v2/DV90 # needs EAB Credentials (EAB KID & EAB HMAC Key)

CERTIFICATES_ACME_EMAIL=<E-MAIL>
CERTIFICATES_ACME_CERTIFICATES_DURATION=2160 # 2160 (90*24=2160) | 8760 (365*24=8760)
CERTIFICATES_ACME_DNSCHALLENGE_PROVIDER=ionos # https://doc.traefik.io/traefik/https/acme/#providers
CERTIFICATES_ACME_DNSCHALLENGE_RESOLVERS=9.9.9.9,194.242.2.2,1.1.1.1
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

```
$cp docker-compose-newt.override.yaml.tmpl docker-compose-newt.override.yaml
```

extend `networks` sections with your network names where `newt` should have access for and will tunnel over `pangolin`.

---

## References

- <https://github.com/fosrl>
- <https://docs.fossorial.io/Getting%20Started/Manual%20Install%20Guides/docker-compose>
- <https://docs.fossorial.io/Newt/install>
- acme
  - <https://go-acme.github.io/lego/dns/ionos/>
- <https://docs.fossorial.io/Community%20Guides/crowdsec>
- <https://github.com/maxmind/geoipupdate/blob/main/doc/docker.md>
