# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

```sh
echo "APP_SECRET=$(pwgen -s 32 1)" >> .env
```

### create empty `rclone.conf`:

> Setup rclone conf as you need, a short example is provided in `./config/rclone.conf.tmpl`

```sh
echo '# empty' > ./config/rclone.conf
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
DOMAIN=zerobyte.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=4096
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=v0.21

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates

APP_SECRET=<SECRET>
```

#### example short .env (swarm)

```env
DOMAIN=zerobyte.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=zerobyte.home.local
```

---

## FAQ

### Helpful command

```sh
docker exec -it "$(docker ps -q -f name=^zerobyte-zerobyte\\.)" bun run cli change-username
```

---

## References

- <https://github.com/nicotsx/zerobyte>
- <https://github.com/nicotsx/zerobyte/pkgs/container/zerobyte>
- <https://rclone.org/>
