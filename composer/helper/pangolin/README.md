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

> Below domains `traefik.home.local`, `proxy.home.local` and `home.local` are used as example, replace them as you need.
> As also E-Mail `groot@home.local`

```sh
$cp ./config/pangolin/traefik/dynamic_config_template.yml ./config/pangolin/traefik/dynamic_config.yml
$cp ./config/pangolin/traefik/traefik_config_template.yml ./config/pangolin/traefik/traefik_config.yml

$sed "s|<REPLACE_TRAEFIK_DOMAIN>|traefik.home.local|" -i  ./config/pangolin/traefik/dynamic_config.yml
$sed "s|<REPLACE_DASHBOARDURL_DOMAIN>|proxy.home.local|" -i  ./config/pangolin/traefik/dynamic_config.yml

$sed "s|<REPLACE_EMAIL_ACME>|groot@home.local|" -i  ./config/pangolin/traefik/traefik_config.yml
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_PANGOLIN=latest
VERSION_GERBIL=latest
VERSION_TRAEFIK=latest

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
DASHBOARDURL=<UI_DOMAIN>
BASEDOMAIN=<BASE_DOMAIN>

USERS_SERVERADMIN_EMAIL=<USERMAIL>
USERS_SERVERADMIN_PASSWORD=<PASSWORD>
```

#### example short .env

```env
NETWORK_MODE=overlay

DASHBOARDURL=proxy.home.local
BASEDOMAIN=home.local

USERS_SERVERADMIN_EMAIL=groot@home.local
USERS_SERVERADMIN_PASSWORD=IwasHere!337
```

---

## References

- <https://docs.fossorial.io/Getting%20Started/Manual%20Install%20Guides/docker-compose>
- <https://docs.fossorial.io/Newt/install>
- acme
  - <https://go-acme.github.io/lego/dns/ionos/>
