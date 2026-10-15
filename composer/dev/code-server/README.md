# SETUP

## basic

> designed to work with traefik

### create your `secrets`:

```sh
sudo apt install pwgen argon2

# pick ONE of the following, they are alternatives:

# 1) plain - readable in cleartext by `docker service inspect`
pwgen -s 24 1 | sed 's/^/PASSWORD=/' >> .env

# 2) hashed - what `docker service inspect` cannot leak
PASS=$(pwgen -s 24 1)
printf '%s' "$PASS" | argon2 'code-server' -e \
  | sed 's/\$/$$/g' | sed 's/^/HASHED_PASSWORD=/' >> .env
echo "your password: $PASS"

# 3) hash a password you already picked instead (input stays hidden)
read -rs -p 'password: ' PW && echo
printf '%s' "$PW" | argon2 'code-server' -e \
  | sed 's/\$/$$/g' | sed 's/^/HASHED_PASSWORD=/' >> .env
unset PW
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
DOMAIN=code.home.local
PROTOCOL=http
PORT=8080
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file
CERT_RESOLVER=certificates

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=4
RESOURCES_LIMITS_MEMORY=4g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=4.141.0-ubuntu

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
# folder the explorer opens on start
WORKSPACE=/home/coder/projects
# shut down after N idle seconds (>60); empty/omitted = never idle out
IDLE_TIMEOUT_SECONDS=
KEYBOARD_LAYOUT=de
```

#### example short `.env` (swarm)

```env
DOMAIN=code.home.local
```

#### example short `.env` (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=code.home.local
```

### deploy

```sh
# swarm
docker-swarm-compose code-server -f docker-compose.yaml

# with remote storage, name the volumes file too
docker-swarm-compose code-server -f docker-compose.yaml -f docker-compose.volumes.yaml
```

---

## References

- <https://coder.com/docs/code-server/install#docker>
- <https://hub.docker.com/r/codercom/code-server>
- image build recipe: <https://github.com/coder/code-server/blob/main/ci/release-image/Dockerfile>
- image entrypoint: <https://github.com/coder/code-server/blob/main/ci/release-image/entrypoint.sh>
