# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

```sh
echo "APP__HEALTH_ACCESS_KEY=$(pwgen -s 23 1)" >> .env
echo "OPENCTI_ADMIN_PASSWORD=$(pwgen -s 23 1)" >> .env
echo "OPENCTI_ADMIN_TOKEN=$(uuidgen)" >> .env
echo "OPENCTI_RABBITMQ_PASSWORD=$(pwgen -s 23 1)" >> .env
echo "OPENCTI_ENCRYPTION_KEY=$(openssl rand -base64 32)" >> .env

echo "rustfsadmin" > config/secrets/rustfs_access_key_file.txt
pwgen -s 23 1 > config/secrets/rustfs_secret_key_file.txt
echo "OPENCTI_RUSTFS_ACCESS_KEY=$(cat config/secrets/rustfs_access_key_file.txt)" >> .env
echo "OPENCTI_RUSTFS_SECRET_KEY=$(cat config/secrets/rustfs_secret_key_file.txt)" >> .env

echo "CONNECTOR_EXPORT_FILE_STIX_ID=$(uuidgen)" >> .env
echo "CONNECTOR_EXPORT_FILE_CSV_ID=$(uuidgen)" >> .env
echo "CONNECTOR_EXPORT_FILE_TXT_ID=$(uuidgen)" >> .env
echo "CONNECTOR_IMPORT_FILE_STIX_ID=$(uuidgen)" >> .env
echo "CONNECTOR_IMPORT_DOCUMENT_ID=$(uuidgen)" >> .env
echo "CONNECTOR_ANALYSIS_ID=$(uuidgen)" >> .env
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
DOMAIN=opencti.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8080
# default-secured@file | public-secured@file | authentik@file
# opt in to crowdsec bans: bouncer-crowdsec@file,default-secured@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_OPENSEARCH=2
RESOURCES_LIMITS_MEMORY_OPENSEARCH=4g
# JVM heap, keep at ~half of RESOURCES_LIMITS_MEMORY_OPENSEARCH. The image
# hardcodes 1g and does not auto-size to the cgroup limit.
OPENSEARCH_HEAP_SIZE=2g

RESOURCES_LIMITS_CPUS_RABBITMQ=1
RESOURCES_LIMITS_MEMORY_RABBITMQ=512m

RESOURCES_LIMITS_CPUS_VALKEY=1
RESOURCES_LIMITS_MEMORY_VALKEY=1g

RESOURCES_LIMITS_CPUS_RUSTFS=1
RESOURCES_LIMITS_MEMORY_RUSTFS=1g

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_OPENCTI=7.260921.0
VERSION_CONNECTORS=7.260921.0
VERSION_OPENSEARCH=3.8.0
VERSION_RABBITMQ=4.3.6-management-alpine
VERSION_VALKEY=9.1.2-alpine
VERSION_RUSTFS=1.0.0

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates

OPENCTI_ADMIN_EMAIL=<CHANGEME>

# alert mail. Off by default: `smtp:hostname` defaults to localhost, which in a
# container is the container itself. Only the keys below exist -- there is no
# SMTP_FROM / SMTP_REPLY_TO / SMTP_SECURE / SMTP_PORT_SECURE / SMTP_AUTH_METHOD.
# SMTP_ENABLED=true
# SMTP_HOSTNAME=
# SMTP_PORT=25
# SMTP_USE_SSL=false # implicit TLS, 465
# SMTP_REJECT_UNAUTHORIZED=false
# SMTP_AUTH_TYPE=basic # basic | oauth2
# SMTP_USERNAME=
# SMTP_PASSWORD=
# SMTP_FORCED_SENDER_EMAIL=

# only if traefik fronts the platform, see the note in docker-compose.yaml
# TRUST_PROXY_ADDRESSES=172.16.0.0/12
```

#### example short .env

```env
DOMAIN=opencti.home.local

OPENCTI_ADMIN_EMAIL=groot@home.local
```

#### extend .env for connectors run

```sh
echo "CONNECTORS_OPENCTI_ID=$(uuidgen)" >> .env
echo "CONNECTORS_MITRE_ID=$(uuidgen)" >> .env
echo "CONNECTORS_CVE_ID=$(uuidgen)" >> .env
echo "CONNECTORS_MALPEDIA_ID=$(uuidgen)" >> .env
echo "CONNECTORS_CISA_ID=$(uuidgen)" >> .env
echo "CONNECTORS_MANDIANT_ID=$(uuidgen)" >> .env
echo "CONNECTORS_URLHAUS_ID=$(uuidgen)" >> .env
echo "CONNECTORS_ALIENVAULT_ID=$(uuidgen)" >> .env
echo "CONNECTORS_VIRUSTOTAL_LIVEHUNT_NOTIFICATIONS_ID=$(uuidgen)" >> .env
```

```env
CVE_API_KEY=<CHANGEME>
MALPEDIA_AUTH_KEY=<CHANGEME>
VIRUSTOTAL_LIVEHUNT_NOTIFICATIONS_API_KEY=<CHANGEME>
MANDIANT_API_V4_KEY_ID=<CHANGEME>
MANDIANT_API_V4_KEY_SECRET=<CHANGEME>
ALIENVAULT_API_KEY=<CHANGEME>
```

to run each connector manually once you can also run:

```sh
docker compose -f docker-compose-connectors.yaml up connector-opencti
docker compose -f docker-compose-connectors.yaml up connector-mitre
docker compose -f docker-compose-connectors.yaml up connector-cve
# docker compose -f docker-compose-connectors.yaml up connector-malpedia
docker compose -f docker-compose-connectors.yaml up connector-cisa-known-exploited-vulnerabilities
# docker compose -f docker-compose-connectors.yaml up connector-mandiant
docker compose -f docker-compose-connectors.yaml up connector-urlhaus
# docker compose -f docker-compose-connectors.yaml up connector-alienvault
# docker compose -f docker-compose-connectors.yaml up connector-virustotal-livehunt-notifications
```

#### extend .env for enrichment run

```sh
echo "ENRICHMENT_CROWDSEC_ID=$(uuidgen)" >> .env
echo "ENRICHMENT_VIRUSTOTAL_ID=$(uuidgen)" >> .env
echo "ENRICHMENT_YARA_ID=$(uuidgen)" >> .env
echo "ENRICHMENT_GREYNOISE_ID=$(uuidgen)" >> .env
```

```env
CROWDSEC_KEY=<CHANGEME>
VIRUSTOTAL_TOKEN=<CHANGEME>
GREYNOISE_KEY=<CHANGEME>
```

```sh
$docker compose -f docker-compose-enrichment.yaml up
```

---

## Guides & Insights

### RabbitMQ upgrade

RabbitMQ only moves **one minor series at a time** - a node refuses to boot when
its data dir is more than one series behind. Coming from `4.0.x`/`4.1.x` you must
pass through `4.2.x`, or simply recreate the volume:

```sh
# Stop service first
docker volume rm opencti_rabbitmq_data
```

Only the in-flight messages are lost - all data lives in PostgreSQL, OpenSearch
and S3 storage. The user is re-seeded from `OPENCTI_RABBITMQ_PASSWORD`.

### OpenSearch and RustFS

Both need the same host prerequisite. `vm.max_map_count` is **not** a namespaced
sysctl, so compose cannot set it for the container -- RustFS is an OpenSearch
distribution, so it applies twice over. Without it the node dies on boot with
`max virtual memory areas vm.max_map_count [65530] is too low`:

```sh
sysctl -w vm.max_map_count=262144
echo 'vm.max_map_count=262144' | sudo tee /etc/sysctl.d/99-opensearch.conf
```

The OpenSearch security plugin is disabled, so 9200 is plain http and no `admin`
user exists. Enabling it means `OPENSEARCH_INITIAL_ADMIN_PASSWORD` (mandatory
since 2.12, no `_FILE` variant), https on 9200, and `ELASTICSEARCH__USERNAME` /
`ELASTICSEARCH__PASSWORD` on the platform.

### RabbitMQ tuning not in this stack

No `rabbitmq.conf` is mounted, so two upstream-recommended settings are **not**
applied and large or long-running ingests will fail:

```conf
max_message_size = 536870912   # 4.3 default is 16 MiB
consumer_timeout = 86400000    # 4.3 default is 30 min
```

Filigran ships both in [`rabbitmq.conf`](https://github.com/OpenCTI-Platform/docker/blob/master/rabbitmq.conf).
Add them as a `configs:` entry (not a bind mount) when you need it.

---

## References

- <https://filigran.io/>
- <https://github.com/OpenCTI-Platform/opencti>
- <https://github.com/OpenCTI-Platform/docker>
- <https://docs.opencti.io/latest/deployment/breaking-changes/>
- <https://docs.opencti.io/latest/deployment/configuration/>
- <https://docs.opencti.io/latest/deployment/upgrade/>
- <https://github.com/OpenCTI-Platform/connectors/tree/master/external-import>
- connectors
  - <https://github.com/OpenCTI-Platform/connectors/tree/master/external-import/opencti>
  - <https://github.com/OpenCTI-Platform/connectors/tree/master/external-import/mitre>
  - <https://github.com/OpenCTI-Platform/connectors/tree/master/external-import/cve>
  - <https://github.com/OpenCTI-Platform/connectors/tree/master/external-import/malpedia>
  - <https://github.com/OpenCTI-Platform/connectors/tree/master/external-import/cisa-known-exploited-vulnerabilities>
  - <https://github.com/OpenCTI-Platform/connectors/tree/master/external-import/mandiant>
  - <https://github.com/OpenCTI-Platform/connectors/tree/master/external-import/urlhaus>
  - <https://github.com/OpenCTI-Platform/connectors/tree/master/external-import/alienvault>
  - <https://github.com/OpenCTI-Platform/connectors/tree/master/external-import/virustotal-livehunt-notifications>
- enrichment
  - <https://github.com/OpenCTI-Platform/connectors/tree/master/internal-enrichment/crowdsec>
  - <https://github.com/OpenCTI-Platform/connectors/tree/master/internal-enrichment/virustotal>
  - <https://github.com/OpenCTI-Platform/connectors/tree/master/internal-enrichment/yara>
  - <https://github.com/OpenCTI-Platform/connectors/tree/master/internal-enrichment/greynoise-vuln>
