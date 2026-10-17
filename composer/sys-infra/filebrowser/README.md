# SETUP

## basic

> designed to work with traefik

### render the config

```sh
(
  umask 022
  sed -e 's|<SOURCE_PATH>|/srv|g' \
    config/filebrowser.yaml.tmpl > config/filebrowser.yaml
)
```

### create your `secrets`:

```sh
printf 'FILEBROWSER_ADMIN_PASSWORD=%s\n' "$(pwgen -s 50 1)" >> .env
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
DOMAIN=share.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT_FILEBROWSER=8080 # must match http.port in config/filebrowser.yaml
# default-secured@file | public-secured@file | authentik@file
# opt in to crowdsec bans: bouncer-crowdsec@file,default-secured@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=128m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_FILEBROWSER=2.0.0-stable

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates
```

#### example short `.env` (swarm)

```env
DOMAIN=share.home.local
NFS_HOST=<your-nfs-server>
NFS_PATH=<your-existing-nas-data-export>
```

#### example short `.env` (bridge)

```env
LB_SWARM=false
DOMAIN=share.home.local
NFS_HOST=<your-nfs-server>
NFS_PATH=<your-existing-nas-data-export>
```

## Guides & Insights

### UID of files created in the share

The service runs as `user: "915:915"` and uploaded files land on the export
with the same owner as the rest of the share.

Upstream has no automatic mapping for this. The documented method is to set
`user:` **and** give the data directory the same ownership.

Do the chown **with the same image**, so it cannot be undone afterwards. The
image ships `/home/filebrowser/data` (`config.yaml`, `1000:1000`) and Docker
copies that ownership into a new empty volume on first mount, which silently
reverts a chown done before the first start:

```sh
docker run --rm --user 0:0 --cap-add CHOWN \
  -v filebrowser_data:/home/filebrowser/data \
  --entrypoint /bin/sh ghcr.io/gtsteffaniak/filebrowser:${VERSION_FILEBROWSER:-2.0.0-stable} \
  -c 'chown -R 915:915 /home/filebrowser/data && ls -lan /home/filebrowser/data'
```

Run it on the node where the service is placed (Swarm volumes are node-local).
Verify with the same `ls -lan`: the directory and `config.yaml` must read
`915 915`. Until then the container exits with
`unable to open database file (14)` or `cacheDir failed to create cache directory`.

## References

- <https://filebrowserquantum.com/en/docs/getting-started/docker/>
- <https://filebrowserquantum.com/en/docs/configuration/sources/>
- <https://filebrowserquantum.com/en/docs/getting-started/v2/migration/>
