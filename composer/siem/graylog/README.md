# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [first startup database container](#first-startup-database-container)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
  - [Optional: add TLS for syslog](#optional-add-tls-for-syslog)
  - [Graylog setup example](#graylog-setup-example)
    - [syslog](#syslog)
  - [References](#references)

---

## basic

> defined to work with treafik

### first startup database container

run mongodb from example here: <https://github.com/MVladislav/vm-docker-collection/tree/develop/composer/db/mongodb>

and create new user with database for graylog:

```mongodb
use graylog
db.createUser(
  {
    user: "graylog",
    pwd:  passwordPrompt(),   // or cleartext password
    roles: [ { role: "readWrite", db: "graylog" } ]
  }
)
```

### create your `secrets`:

```sh
#: 'must be at least 16 characters!'
$echo "swordfishswordfish" > config/secrets/graylog_password_secret.txt
$echo -n 'swordfish' | sha256sum | awk '{ print $1 }' > config/secrets/graylog_root_password_sha2.txt
$echo "mongodb://graylog:swordfish@mongodb:27017/graylog" > config/secrets/graylog_mongodb_uri.txt
```

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION_GRAYLOG=5.0.0-beta.4-1
VERSION_OPENSEARCH=2.4.0

LB_SWARM=true
DOMAIN=graylog.home.local
PROTOCOL=http
PORT=9000
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=default-secured@file

OPENSEARCH_MEM_USE_GB=1g
OPENSEARCH_MEM_USE_GB=1g

CLUSTER_NAME=opensearch-cluster

GRAYLOG_HTTP_EXTERNAL_URI=http://127.0.0.1:9000/
GRAYLOG_TRANSPORT_EMAIL_ENABLED=true
GRAYLOG_TRANSPORT_EMAIL_HOSTNAME=smtp
GRAYLOG_TRANSPORT_EMAIL_PORT=465
GRAYLOG_TRANSPORT_EMAIL_USE_AUTH=true
GRAYLOG_TRANSPORT_EMAIL_USE_TLS=true
GRAYLOG_TRANSPORT_EMAIL_USE_SSL=false
```

## Optional: add TLS for syslog

add **pub-cert** file into folder `./config/secrets/tls`

## Graylog setup example

### syslog

create **input** by open `system > inputs` and choose **Syslog UDP** as _Lauch new input_

- set a **title**
- change **port** to `1514`
- activate **Store full message?**

on the new create **input** click on **Manage extractors** \
than klick upper right on **actions** and than **import extractors**

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
- <https://github.com/Graylog2/graylog-docker>
- <https://docs.graylog.org/docs/docker>
- <https://www.youtube.com/watch?v=rtfj6W5X0YA>
- <https://github.com/Graylog2/graylog-docker/blob/261b48d65b48a7c35f8934e6a6b4a13a67ab6fbe/test/docker-compose.tpl>
- <https://hub.docker.com/r/opensearchproject/opensearch>
