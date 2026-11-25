# SETUP

## basic

> designed to work with traefik

### create your `secrets`:

```sh
printf '%s' '<CLIENT_SECRET_FROM_POCKET_ID>' > config/secrets/oauth2_proxy_client_secret.txt
openssl rand 32 > config/secrets/oauth2_proxy_cookie_secret.bin
# chmod 0644 config/secrets/oauth2_proxy_*
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
PROTOCOL=http
PORT=4180
# the /oauth2/ router serves login pages and must be reachable from the internet
MIDDLEWARE_SECURED=public-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=256m
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=v7.15.6-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates

TZ=Europe/Berlin
OAUTH2_PROXY_CLIENT_ID=<client id from Pocket ID>
OAUTH2_PROXY_OIDC_ISSUER_URL=https://auth.home.local
OAUTH2_PROXY_EMAIL_DOMAINS=*
# if the Pocket ID client has PKCE enabled, keep S256 so code_challenge is sent
OAUTH2_PROXY_CODE_CHALLENGE_METHOD=S256
# domains allowed in rd=, e.g. .home.local covers every app host below it
OAUTH2_PROXY_WHITELIST_DOMAINS=
# narrow this to the proxy network's subnet in production
OAUTH2_PROXY_TRUSTED_PROXY_IPS=127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,fe80::/10,::1/128
OAUTH2_PROXY_COOKIE_NAME=__Host-oauth2-proxy
OAUTH2_PROXY_SKIP_PROVIDER_BUTTON=true
```

#### example short `.env` (swarm)

```env
OAUTH2_PROXY_CLIENT_ID=<client id from Pocket ID>
OAUTH2_PROXY_OIDC_ISSUER_URL=https://auth.home.local
```

#### example short `.env` (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

OAUTH2_PROXY_CLIENT_ID=<client id from Pocket ID>
OAUTH2_PROXY_OIDC_ISSUER_URL=https://auth.home.local
```

---

## Guides & Insights

### Protect an app

1. In Pocket ID create one OIDC client. Add a callback URL
   `https://<APP_DOMAIN>/oauth2/callback` for **each** host you want to protect;
   `callbackURLs` is a list, so one client is enough. Note its client ID and
   put the secret in `config/secrets/oauth2_proxy_client_secret.txt` above.
2. In the protected app's `.env` set:

   ```env
   MIDDLEWARE_SECURED=oauth2-errors@swarm,oauth2-auth@swarm,public-secured@file
   ```

   Use `default-secured@file` instead when the app is internal-only. The order
   matters: `forwardAuth` returns 401, then `errors` rewrites it to a 302 to
   `/oauth2/sign_in?rd={url}`. Note that `errors` also catches a 401/403
   returned by the app itself.

3. Redeploy the app. Its router stays a plain `Host(...)` catch-all - the
   `Host(`\*`) && PathPrefix(`/oauth2/`)` router of this stack has priority 1000
   and takes the callback and sign-in paths before the app's router sees them.
4. Users get a `__Host-` cookie scoped to the app host, so each host is a
   separate login session. `X-Auth-Request-{User,Email,Groups,Preferred-Username}`
   are passed to the app; the app must only trust them when reached through
   Traefik.

---

## References

- <https://oauth2-proxy.github.io/oauth2-proxy/configuration/overview/>
- <https://oauth2-proxy.github.io/oauth2-proxy/configuration/integrations/traefik/>
- <https://pocket-id.org/docs/guides/proxy-services>
- <https://doc.traefik.io/traefik/reference/routing-configuration/http/middlewares/forwardauth/>
- <https://doc.traefik.io/traefik/reference/routing-configuration/http/middlewares/errorpages/>
- <https://github.com/oauth2-proxy/oauth2-proxy>
