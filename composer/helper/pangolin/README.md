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
  - [References](#references)

---

## basic

### create your `secrets`:

```sh
$echo $(htpasswd -nB traefik) > config/secrets/traefik_basicauth_secret.txt
$echo '<YOUR_API_TOKEN>' > config/secrets/ionos_api_key_secret.txt
```

### create config files:

> Replace `home.local`.

```sh
$TMP_DOMAIN_BASE="home.local"
$TMP_DOMAIN_DASHBOARD="proxy.${TMP_DOMAIN_BASE}"
$TMP_DOMAIN_TRAEFIK="traefik.${TMP_DOMAIN_BASE}"

$cp ./config/pangolin/traefik/dynamic_config.yml.tmpl ./config/pangolin/traefik/dynamic_config.yml
$cp ./config/pangolin/config.yml.tmpl ./config/pangolin/config.yml

$sed "s|<REPLACE_TRAEFIK_DOMAIN>|${TMP_DOMAIN_TRAEFIK}|" -i  ./config/pangolin/traefik/dynamic_config.yml
$sed "s|<REPLACE_DASHBOARDURL_DOMAIN>|${TMP_DOMAIN_DASHBOARD}|" -i  ./config/pangolin/traefik/dynamic_config.yml

$sed "s|<REPLACE_DASHBOARDURL_DOMAIN>|${TMP_DOMAIN_DASHBOARD}|" -i  ./config/pangolin/config.yml
$sed "s|<REPLACE_BASE_DOMAIN>|${TMP_DOMAIN_BASE}|" -i  ./config/pangolin/config.yml
$sed "s|<REPLACE_SERVER_SECRET>|$(pwgen -s 32 1)|" -i  ./config/pangolin/config.yml
$sed "s|<REPLACE_USERS_PASSWORD>|$(pwgen -c  -n -y -s 18 1)|" -i  ./config/pangolin/config.yml

$echo "BASEDOMAIN=${TMP_DOMAIN_BASE}" >> .env
$echo "DASHBOARDURL=${TMP_DOMAIN_DASHBOARD}" >> .env
$echo "USERS_SERVERADMIN_EMAIL=groot@${TMP_DOMAIN_BASE}" >> .env
$echo "USERS_SERVERADMIN_PASSWORD=$(pwgen -c  -n -y -s 18 1)"  >> .env
$echo "ACME_EMAIL=info@${TMP_DOMAIN_BASE}" >> .env
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=4
RESOURCES_LIMITS_MEMORY=2g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_PANGOLIN=1.5.1
VERSION_GERBIL=1.0.0
VERSION_TRAEFIK=v3.4.1

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
DASHBOARDURL=<REPLACE_DASHBOARDURL_DOMAIN>
BASEDOMAIN=<BASE_DOMAIN>

USERS_SERVERADMIN_EMAIL=<USERMAIL>
USERS_SERVERADMIN_PASSWORD=<PASSWORD>

ACME_EMAIL=<E-MAIL>
ACME_CASERVER=https://acme-staging-v02.api.letsencrypt.org/directory # https://acme-v02.api.letsencrypt.org/directory
ACME_DNSCHALLENGE_PROVIDER=ionos
ACME_DNSCHALLENGE_RESOLVERS=9.9.9.9,194.242.2.2,1.1.1.1
```

#### example short .env

```env
ACME_CASERVER=https://acme-v02.api.letsencrypt.org/directory
```

---

## References

- <https://github.com/fosrl>
- <https://docs.fossorial.io/Getting%20Started/Manual%20Install%20Guides/docker-compose>
- <https://docs.fossorial.io/Newt/install>
- acme
  - <https://go-acme.github.io/lego/dns/ionos/>
