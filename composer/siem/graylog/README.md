# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

```sh
pwgen -s 24 1 > config/secrets/graylog_password_secret.txt
pwgen -s 24 1 > config/secrets/graylog_root_password_plain.txt
tr -d '\n' < config/secrets/graylog_root_password_plain.txt | sha256sum | awk '{ print $1 }' > config/secrets/graylog_root_password_sha2.txt
```

### get/update plugins

```sh
# ... graylog-plugin-integrations-4.3.0.jar
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
DOMAIN=graylog.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=9000
# default-secured@file | public-whitelist@file | authentik@file
# opt in to crowdsec bans: bouncer-crowdsec@file,default-secured@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1.5
RESOURCES_LIMITS_MEMORY=2g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_GRAYLOG_DATANODE=2
RESOURCES_LIMITS_MEMORY_GRAYLOG_DATANODE=3g
RESOURCES_RESERVATIONS_CPUS_GRAYLOG_DATANODE=0.001
RESOURCES_RESERVATIONS_MEMORY_GRAYLOG_DATANODE=32m

RESOURCES_LIMITS_CPUS_MONGODB=1
RESOURCES_LIMITS_MEMORY_MONGODB=512m
RESOURCES_RESERVATIONS_CPUS_MONGODB=0.001
RESOURCES_RESERVATIONS_MEMORY_MONGODB=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_GRAYLOG=7.1.9
VERSION_MONGODB=8.3.9

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates

GRAYLOG_TRANSPORT_EMAIL_ENABLED=false
# GRAYLOG_TRANSPORT_EMAIL_HOSTNAME=<RELAY>
# GRAYLOG_TRANSPORT_EMAIL_PORT=587
# GRAYLOG_TRANSPORT_EMAIL_USE_AUTH=true
# GRAYLOG_TRANSPORT_EMAIL_AUTH_USERNAME=<USERNAME>
# GRAYLOG_TRANSPORT_EMAIL_AUTH_PASSWORD=<PASSWORD>
# GRAYLOG_TRANSPORT_EMAIL_USE_TLS=true
# GRAYLOG_TRANSPORT_EMAIL_USE_SSL=false
```

#### example short .env

```env
DOMAIN=graylog.home.local
```

## Graylog setup example

### syslog

create **input** by open `system > inputs` and choose **Syslog UDP** as _Lauch new input_

- set a **title**
- change **port** to `5140`
- activate **Store full message?**

on the new create **input** click on **Manage extractors** \
than click upper right on **actions** and than **import extractors**

you can find example extractor for example here:

- <https://github.com/IRQ10/Graylog-OPNsense_Extractors>

create **indices** by open `system > indices` and click **create index set**

- set **title** and **description**
- change **Max number of indices** to `30` that we have a ~month of records back

create new **stream** by open `streams` and click on **create stream**

- set **title** and **description**
- choose **index set**
- activate **Remove matches from ‘Default Stream’**

on the new create **stream** click on **manage rules** \
than add new rule by click on **add stream rule**

- set **field** as `gl2_source_input`
- set **value** as input id
  > from your created **input** under `system/inputs`, when click on **show received messages** you can get the **gl2_source_input** number

under page `streams`, do not forget to activate the stream by click on **start stream**

---

## References

- <https://www.graylog.org/>
- <https://hub.docker.com/r/graylog/graylog>
  - <https://hub.docker.com/r/graylog/graylog-datanode>
- source + `UPGRADING.md` (the authoritative release notes, there is no CHANGELOG)
  - <https://github.com/Graylog2/graylog2-server>
  - <https://github.com/Graylog2/graylog2-server/blob/7.1.9/UPGRADING.md>
- <https://github.com/Graylog2/docker-compose>
- <https://github.com/Graylog2/graylog-docker>
- <https://docs.graylog.org/docs/docker>
- <https://go2docs.graylog.org/current/setting_up_graylog/graylog_upgrade.html>
- <https://www.youtube.com/watch?v=rtfj6W5X0YA>
- <https://go2docs.graylog.org/current/setting_up_graylog/server.conf.html>
- opensearch
  - <https://hub.docker.com/r/opensearchproject/opensearch>
- infos:
  - <https://www.youtube.com/watch?v=wZxwwQ1gchI>
- logs
  - <https://community.graylog.org/t/graylog-encryption-between-graylog-client-and-server/29705/4>
  - <https://graylog.org/post/how-to-guide-securing-graylog-with-tls/>
  - <https://go2docs.graylog.org/5-1/setting_up_graylog/secured_graylog_and_beats_input.html>
