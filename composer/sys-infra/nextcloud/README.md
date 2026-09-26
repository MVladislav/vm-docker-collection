# SETUP

## basic

> defined to work with traefik

### database setup

This stack ships **no database**. Deploy a MariaDB stack separately (see the
`mariadb` service in
[`__template/docker-compose-example-services.yaml`](../../__template/docker-compose-example-services.yaml))
and attach it to a shared external network:

```sh
docker network create --driver overlay --attachable mysql
```

Create the `nextcloud` database and user inside that MariaDB instance, then set
the `MYSQL_*` variables below. `nextcloud/server` talks to MariaDB through the
same `MYSQL_*` variables, so no other change is needed.

### create your `secrets`:

```sh
echo "swordfish" > config/secrets/nextcloud_admin_password.txt
echo "swordfish" > config/secrets/mysql_password.txt
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=nextcloud.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=80
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
# 500m | 1g | ...
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_NEXTCLOUD=27.1.3-apache
VERSION_NEXTCLOUD_CRON=27.1.3-fpm
VERSION_REDIS=7.2.2-alpine3.18

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
NEXTCLOUD_ADMIN_USER=admin

MYSQL_HOST=mysql
MYSQL_DATABASE=nextcloud
MYSQL_USER=nextcloud
```

#### example short .env

```env
DOMAIN=nextcloud.home.local

VERSION_NEXTCLOUD=27.1.3-apache
VERSION_NEXTCLOUD_CRON=27.1.3-fpm
VERSION_REDIS=7.2.2-alpine3.18
```

---

## FAQ

- redis
  - redis needs to have ipv6 turned on, check grub for entry with `ipv6.disable=1`

---

## References

- <https://hub.docker.com/_/nextcloud>
- <https://github.com/nextcloud/all-in-one#how-to-use-this>
- <https://github.com/nextcloud/docker/issues/1028>
- <https://github.com/nextcloud/docker/issues/1740>
