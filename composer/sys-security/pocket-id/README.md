# SETUP

## basic

> designed to work with traefik

### create your `secrets`:

```sh
openssl rand -base64 32 > config/secrets/pocket_id_encryption_key_file.txt
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
DOMAIN=auth.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=1411
# default-secured@file | public-secured@file | authentik@file
# opt in to crowdsec bans: bouncer-crowdsec@file,default-secured@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_POCKET_ID=v2.19.3

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates
TZ=Europe/Berlin

ANALYTICS_DISABLED=true # 24h heartbeat to analytics.pocket-id.org
VERSION_CHECK_DISABLED=true # api.github.com "latest release" lookup

# comma separated IPs or CIDRs allowed to set X-Forwarded-For.
# `true` = trust everybody, unset = trust nobody (the traefik container address
# is then recorded as the client in the audit log).
TRUST_PROXY=127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,fe80::/10,::1/128

LOG_LEVEL=info # debug | info | warn | error

# upstream defaults to the selfh.st icon collection on cdn.jsdelivr.net;
# `disabled` keeps OIDC client-logo lookups local
ICON_LIBRARY_URL=disabled
# upstream defaults to true, allowing plain http:// OIDC redirect URIs;
# false rejects them behind traefik (loopback callbacks still work)
ALLOW_INSECURE_CALLBACK_URLS=false
```

#### example short `.env` (swarm)

```env
DOMAIN=auth.home.local
```

#### example short `.env` (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=auth.home.local
```

---

## Guides & Insights

### Encryption key

Changing the key is not an edit of `.env`. Run the re-encryption first with the
**old** key still in place, then restart with the new one:

```sh
docker exec "$(docker ps -q -f name=pocket-id\\.)" /app/pocket-id encryption-key-rotate --new-key "<NEW>"
# then replace config/secrets/pocket_id_encryption_key_file.txt and redeploy
```

---

## References

- <https://pocket-id.org/>
- <https://pocket-id.org/docs/installation>
- <https://pocket-id.org/docs/configuration/environment-variables>
- <https://github.com/pocket-id/pocket-id>
  - <https://github.com/pocket-id/pocket-id/blob/main/docker/Dockerfile>
  - <https://github.com/pocket-id/pocket-id/blob/main/scripts/docker/entrypoint.sh>
  - <https://github.com/pocket-id/pocket-id/blob/main/docker-compose.yml>
  - <https://github.com/pocket-id/pocket-id/blob/main/.env.example>
