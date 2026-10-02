# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

```sh
pwgen -s 32 1 > config/secrets/db_password_file_secret.txt
pwgen -s 32 1 > config/secrets/mariadb_root_password.txt

# smtp is a documented system requirement; leave it empty for an open relay
printf '%s' '<your-smtp-password>' > config/secrets/smtp_password_file_secret.txt
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=passbolt.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=80
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=2g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_MARIADB=1
RESOURCES_LIMITS_MEMORY_MARIADB=512m
RESOURCES_RESERVATIONS_CPUS_MARIADB=0.001
RESOURCES_RESERVATIONS_MEMORY_MARIADB=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=5.16.0-1-ce
# VERSION=5.16.0-1-ce-non-root # rootless, then PORT=8080
VERSION_MARIADB=13.0.2

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates

EMAIL_DEFAULT_FROM=
EMAIL_TRANSPORT_DEFAULT_HOST=
EMAIL_TRANSPORT_DEFAULT_PORT=587
EMAIL_TRANSPORT_DEFAULT_USERNAME=
EMAIL_TRANSPORT_DEFAULT_TLS=true
```

#### example short .env (swarm)

```env
DOMAIN=passbolt.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=passbolt.home.local
```

---

## Guides & Insights

### initial admin user

> the command returns a single use url, open it in the browser to finish the setup

```sh
docker exec -it "$(docker ps -q -f name=passbolt)" su -m -s /bin/bash -c \
'source /etc/environment && \
/usr/share/php/passbolt/bin/cake passbolt register_user \
-u <your@email.com> \
-f <yourname> \
-l <surname> \
-r admin' www-data
```

---

## References

- <https://www.passbolt.com/>
- <https://www.passbolt.com/ce/docker>
- <https://www.passbolt.com/docs/hosting/>
- <https://hub.docker.com/r/passbolt/passbolt>
- <https://github.com/passbolt/passbolt_api>
  - <https://github.com/passbolt/passbolt_api/blob/master/CHANGELOG.md>
  - <https://github.com/passbolt/passbolt_api/blob/master/RELEASE_NOTES.md>
