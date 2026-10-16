# SETUP

## basic

> designed to work with traefik

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=draw.home.local # not set in docker-compose, needs to be copied to .env
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=500m
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_STORAGE=1
RESOURCES_LIMITS_MEMORY_STORAGE=1g
RESOURCES_RESERVATIONS_CPUS_STORAGE=0.001
RESOURCES_RESERVATIONS_MEMORY_STORAGE=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_EXCALIDRAW=v0.18.1
VERSION_EXCALIDRAW_ROOM=03ff435860b508d7cd9e005cfc90f7977ae2a593
VERSION_STORAGE=1.0.0
VERSION_NODE=22.22.2
VERSION_NGINX=1.31.7-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates

# PUBLIC_PROTOCOL=https # scheme the BROWSER sees (https|wss, or http|ws without TLS)
CACHE_INVALIDATOR=

# PORT=80
# PROTOCOL=http # container-side scheme/port for excalidraw (traefik -> nginx)
# PORT_STORAGE=8080
# PROTOCOL_STORAGE=http
# PORT_ROOM=8080
# PROTOCOL_ROOM=http
# GLOBAL_PREFIX_STORAGE=/api/v2 # must match the traefik PathPrefix(`/api/v2`) rule
# BODY_LIMIT_STORAGE=50mb
# LOG_LEVEL_STORAGE=info
# MAX_HTTP_BUFFER_SIZE=5242880 # excalidraw rebroadcasts the whole scene on join
# DATA_DIR=/data # read by the storage image, not by the compose file
# DRAIN_TIMEOUT_MS=10000 # graceful-shutdown budget, storage image only

# Build args. Every VITE_APP_* below is read by a user-initiated action only (a
# link href, a window.open, or a fetch after a click), so leaving them empty keeps
# the build from ever handing a scene to a third party.
# ______________________________________________________________________________
VITE_APP_ENABLE_TRACKING=false
# VITE_APP_AI_BACKEND=
# VITE_APP_PLUS_LP=
# VITE_APP_PLUS_APP=
```

#### example short `.env` (swarm)

```env
DOMAIN=draw.home.local
```

#### example short `.env` (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=draw.home.local
```

---

## Guides & Insights

### build & deploy

All three services are **locally built**, and `docker stack deploy` deploys
`image:` only - it ignores `build:`. Build first, on every node that will run the
stack:

```sh
# swarm
docker compose -f docker-compose.yaml build   # excalidraw + room + storage
docker-swarm-compose excalidraw               # or: docker stack deploy -c docker-compose.yaml excalidraw

# bridge (same compose file, plain compose)
docker compose -f docker-compose.yaml build
docker compose -f docker-compose.yaml up -d
```

`PUBLIC_PROTOCOL` and `DOMAIN` are baked into the client build, so changing
either needs `build` again, not just a redeploy.

## Notes

- Backup is the one volume: `docker run --rm -v excalidraw_storage:/data -v "$PWD":/out alpine tar czf /out/excalidraw-storage.tar.gz -C /data .`
- The `storage` **named** volume inherits uid 1000 from the image. A bind mount
  or an NFS volume needs `chown -R 1000:1000` first, or the service cannot write.
- `replicas: 1` and one local volume: a second replica would start with an empty
  `/data`. No shared storage, no eviction, no TTL.
- `patches/*.patch` is invisible to the repo's YAML hooks; both builds assert
  the patch actually applied.

## References

- <https://github.com/excalidraw/excalidraw>
- <https://github.com/excalidraw/excalidraw-room>
