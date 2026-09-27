# SETUP

> defined to work with traefik

## basic

### prerequisites

- deploy the **traefik** stack first, it owns the shared `traefik_logs` volume
  this stack acquires from (`log.filePath` / `accesslog.filePath` in its
  `traefik.yml` have to stay enabled for that)
- attach this stack to the external `proxy` overlay network

### create `.env` file following:

```env
NODE_ROLE=manager

DISABLE_LOCAL_API=false
AGENT_USERNAME=
AGENT_PASSWORD=
LOCAL_API_URL=http://crowdsec:8080

# registers the bouncer `traefik` on first start, and authenticates bouncer-traefik below
CROWDSEC_BOUNCER_API_KEY_TRAEFIK=<API_KEY>
CROWDSEC_AGENT_HOST=crowdsec:8080

# http_telegram notification, both interpolated into config/telegram.yaml
TELEGRAM_BOT_TOKEN=
TELEGRAM_CHAT_ID=

# http_elasticsearch notification, base64 of "USER:PASSWORD"
ELASTIC_AUTH=

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_CROWDEC=v1.8.1
VERSION_BOUNCER_TRAEFIK=0.5.0

# APPLICATION general sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS_CROWDEC=1
RESOURCES_LIMITS_MEMORY_CROWDEC=1g
RESOURCES_RESERVATIONS_CPUS_CROWDEC=0.001
RESOURCES_RESERVATIONS_MEMORY_CROWDEC=32m

RESOURCES_LIMITS_CPUS_BOUNCER_TRAEFIK=0.25
RESOURCES_LIMITS_MEMORY_BOUNCER_TRAEFIK=128m
RESOURCES_RESERVATIONS_CPUS_BOUNCER_TRAEFIK=0.001
RESOURCES_RESERVATIONS_MEMORY_BOUNCER_TRAEFIK=32m
```

---

## traefik integration

`bouncer-traefik` is the target of the `bouncer-crowdsec` forwardAuth
middleware, which is defined in the **traefik** stack (`config.yml`, file
provider) but deliberately left out of the `default-secured` chain, so a
crowdsec outage cannot lock every other stack out of its routers. Enable it per
stack:

```env
MIDDLEWARE_SECURED=bouncer-crowdsec@file,default-secured@file
```

The bouncer reads the client IP from `X-Forwarded-For`, which traefik sets to the
real client, so no `authRequestHeaders` is needed. It carries no traefik labels
on purpose -- `providers.swarm.exposedByDefault: false` keeps it unrouted, and
a router would expose the bouncer itself.

The bouncer is registered automatically as `traefik` by `BOUNCER_KEY_TRAEFIK`.
Swarm secrets are supported as well (a secret named `bouncer_key_traefik` is
read from `/run/secrets` and registers the same name), but `bouncer-traefik` has
no `*_FILE` support for `CROWDSEC_BOUNCER_API_KEY`, so the key would have to be
in `.env` regardless. One source of truth is less to keep in sync.

---

## notifications

`config/profiles.yaml` decides which sinks an alert reaches. The plugins are
always loaded from `config/`, so a plugin that is not listed in the profile is
registered but never called. There is no `disabled:` key -- the profile decoder
is strict and rejects unknown fields, so commenting the entry out is the only
way to stop a sink.

Every credential lives in `.env` and is interpolated into the committed
notification config. Crowdsec expands `${VAR}` in all keys except `format`,
which is a go template and needs sprig's `{{ env "VAR" }}`. Notification
configs have **no** `_FILE` indirection -- the image only reads
`/run/secrets/bouncer_key*` -- so the environment is the only secret channel
here, and no notification config may ever hold a real credential.

- `http_elasticsearch` ships **disabled**: no search/index service runs in this
  stack, so `http://opensearch:9200/_bulk` never resolves. Enable it only after
  attaching one to the same overlay network, then set `ELASTIC_AUTH` in `.env`
  (`printf '%s' "USER:PASSWORD" | base64 -w0`). Do not raise `log_level` to
  `debug` on any of these, the plugin logs every request header and URL.
- `http_telegram` is enabled and ready, it only needs `TELEGRAM_BOT_TOKEN` and
  `TELEGRAM_CHAT_ID`.

Removing a `config/*.yaml` while the profile still lists it makes crowdsec
refuse to start (`binary for plugin ... not found`).

```sh
$docker exec "$(docker ps -q -f name=crowdsec)" cscli notifications list
$docker exec "$(docker ps -q -f name=crowdsec)" cscli notifications inspect http_telegram
# `inspect` never interpolates env vars, it always prints the raw `${TELEGRAM_BOT_TOKEN}`
$docker exec -e TELEGRAM_BOT_TOKEN="$(grep ^TELEGRAM_BOT_TOKEN .env | cut -d= -f2-)" \
  -e TELEGRAM_CHAT_ID="$(grep ^TELEGRAM_CHAT_ID .env | cut -d= -f2-)" \
  "$(docker ps -q -f name=crowdsec)" cscli notifications test http_telegram
```

---

## commands for verify

show metrics:

```sh
$docker exec "$(docker ps -q -f name=crowdsec)" cscli metrics
```

check if decisions listed:

```sh
$docker exec "$(docker ps -q -f name=crowdsec)" cscli decisions list
```

check that the traefik logs are actually being acquired:

```sh
$docker exec "$(docker ps -q -f name=crowdsec)" cscli parsers list
$docker exec "$(docker ps -q -f name=crowdsec)" cscli metrics | grep -i Parsers
```

install collection:

> some default are always in docker-composer defined

```sh
$docker exec "$(docker ps -q -f name=crowdsec)" cscli collections install crowdsecurity/<collection name>
```

perform updates:

```sh
$docker exec "$(docker ps -q -f name=crowdsec)" cscli hub update
$docker exec "$(docker ps -q -f name=crowdsec)" cscli hub upgrade
```

list bouncers, expect `traefik` (registered from the environment on first start):

```sh
$docker exec "$(docker ps -q -f name=crowdsec)" cscli bouncers list
```

---

## References

- <https://crowdsec.net/blog/secure-docker-compose-stacks-with-crowdsec/>
- <https://docs.crowdsec.net/docs/local_api/notification_plugins/intro/>
- <https://github.com/fbonalair/traefik-crowdsec-bouncer>
