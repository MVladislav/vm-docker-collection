# SETUP

## basic

> defined to work with traefik

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=beszel.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8090
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
VERSION=0.20.0
VERSION_AGENT=0.20.0

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates
MFA_OTP=true # you need first setup SMTP inside PocketBase

# agent: the public SSH key shown when adding a system in the hub
# (required by the same-system agent in docker-compose.yaml)
KEY=ssh-ed25519 AAAAC3Nza... user@host

# Agent GPU variants
AGENT_TYPE= # empty | -nvidia | -intel  (must match HWACCEL)
HWACCEL=none # none|gpu-amd|gpu-nvidia|gpu-intel

# Optional hub settings (add/change as needed)
# CHECK_UPDATES=true                # show update notifications in the hub UI
# CONTAINER_DETAILS=true            # allow viewing container details/logs (default true)
# CSP=default-src 'self'            # set a Content-Security-Policy header
# HEARTBEAT_URL=https://hc-ping.com/<uuid>  # dead-man's-switch ping
# HEARTBEAT_INTERVAL=60
# HEARTBEAT_METHOD=POST
# TRUSTED_AUTH_HEADER=Cf-Access-Authenticated-User-Email  # forwarded auth SSO
# TRUSTED_PROXY_IPS=10.0.0.0/8,192.168.0.0/16  # allowlist for TRUSTED_AUTH_HEADER (v0.20+)
# OAUTH_DISABLE_POPUP=false

# If you setup with SSO
MFA_OTP=false
SHARE_ALL_SYSTEMS=true
DISABLE_PASSWORD_AUTH=true
USER_CREATION=true
```

#### example short .env (swarm)

```env
DOMAIN=beszel.home.local
KEY=ssh-ed25519 AAAAC3Nza... user@host
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=beszel.home.local
KEY=ssh-ed25519 AAAAC3Nza... user@host
```

## FAQ

### Reset SuperUser password

```sh
docker exec -it "$(docker ps -q -f name=^beszel_beszel\\.)" /beszel superuser upsert <MAIL> <PASSWORD>
```

---

## References

- <https://github.com/henrygd/beszel>
- <https://github.com/henrygd/beszel/blob/main/supplemental/docker/same-system/docker-compose.yml>
