# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create nfs storage](#create-nfs-storage)
    - [setup proxy (caddy)](#setup-proxy-caddy)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [Manual run after install](#manual-run-after-install)
    - [set default phone region](#set-default-phone-region)
  - [Helpers](#helpers)
    - [Bruteforce protection - unblock ip](#bruteforce-protection---unblock-ip)
    - [On migration](#on-migration)
    - [Troubleshooting file encoding on external storages](#troubleshooting-file-encoding-on-external-storages)
  - [TODO](#todo)
  - [References](#references)

---

## basic

### create nfs storage

on your NAS system, or what you prefer, create an NFS storage path.

in that created path create two folder as:

```sh
$mkdir {master,data}
$chown 33:0 {master,data}
$chmod -R 750 {master,data}
```

for the **data** path the, volume needs to be create manually:

> change below:
>
> > `<NEXTCLOUD_NFS_IP>`: IP to your NFS system
> >
> > `<NEXTCLOUD_NFS_PATH_DATA>`: path to NFS storage

```sh
$docker volume create \
  --name nextcloud_aio_nextcloud_datadir \
  --driver local \
  --opt type=nfs \
  --opt o=nfsvers=4,addr=<NEXTCLOUD_NFS_IP>,rw \
  --opt device=":<NEXTCLOUD_NFS_PATH_DATA>/data"
```

### setup proxy (caddy)

copy the template `Caddyfile` file as:

> in copied file change `<your-nc-domain>`:

```sh
$cp config/Caddyfile_Template config/Caddyfile
```

add your certificate into `config/certs` as:

- `./config/certs/cert.pem`
- `./config/certs/key.pem`

open port to access nextcloud over caddy:

```sh
$sudo ufw allow 80/tcp
$sudo ufw allow 443/tcp

# $sudo ufw allow 3478/tcp
# $sudo ufw allow 3478/udp
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
# needs to be set with ending on "M"
RESOURCES_LIMITS_MEMORY=4096M

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_NEXTCLOUD=20240308_092935-latest
VERSION_CADDY=2.7.6-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
APACHE_PORT=11000
APACHE_IP_BINDING=127.0.0.1
SKIP_DOMAIN_VALIDATION=true

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
NEXTCLOUD_NFS_IP=<NFS_SYSTEM_IP_ADDRESS>
NEXTCLOUD_NFS_PATH_MASTER=<NFS_PATH>

NEXTCLOUD_TRUSTED_DOMAINS=<DOMAIN_NAME>
```

#### example short .env

```env
VERSION_NEXTCLOUD=20240308_092935-latest
VERSION_CADDY=2.7.6-alpine

NEXTCLOUD_NFS_IP=<NFS_SYSTEM_IP_ADDRESS>
NEXTCLOUD_NFS_PATH_MASTER=<NFS_PATH>
```

## Manual run after install

### set default phone region

> change "DE" with your country code

```sh
$docker exec --user www-data nextcloud-aio-nextcloud php occ config:system:set default_phone_region --value="DE"
```

## Helpers

### Bruteforce protection - unblock ip

```sh
$docker exec --user www-data -it nextcloud-aio-nextcloud php occ security:bruteforce:reset <ip-address>
```

### On migration

> _mimetype migrations_

```sh
$docker exec --user www-data -it nextcloud-aio-nextcloud php occ maintenance:repair --include-expensive
```

### Troubleshooting file encoding on external storages

```sh
$docker exec --user www-data -it nextcloud-aio-nextcloud php occ files:scan --all
```

---

## TODO

```sh
$docker exec --user www-data -it nextcloud-aio-nextcloud php occ config:system:set trusted_domains 10 --value="<DOMAIN_NAME>"
$docker exec --user www-data -it nextcloud-aio-nextcloud php occ maintenance:update:htaccess
```

---

## References

- <https://github.com/nextcloud/all-in-one>
- <https://github.com/nextcloud/all-in-one/blob/main/reverse-proxy.md#1-configure-the-reverse-proxy>
- <https://github.com/nextcloud/all-in-one/discussions/575#discussion-4055615>
- <https://github.com/nextcloud/all-in-one#how-to-resolve-security--setup-warnings-displays-the-missing-default-phone-region-after-initial-install>
- <https://github.com/nextcloud/all-in-one?tab=readme-ov-file#bruteforce-protection-faq>
