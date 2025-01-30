# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
      - [extend .env for connectors run](#extend-env-for-connectors-run)
      - [extend .env for enrichment run](#extend-env-for-enrichment-run)
  - [References](#references)

---

## basic

> defined to work with traefik

### create your `secrets`:

```sh
$echo "APP__HEALTH_ACCESS_KEY=$(pwgen -s 23 1)" >> .env

$pwgen -s 23 1 > config/secrets/opencti_admin_password_file.txt
$uuidgen > config/secrets/opencti_token_file.txt
$pwgen -s 23 1 > config/secrets/rabbitmq_default_pass_file.txt
$pwgen -s 23 1 > config/secrets/minio_root_password_file.txt

$echo "OPENCTI_ADMIN_PASSWORD=$(cat config/secrets/opencti_admin_password_file.txt)" >> .env
$echo "OPENCTI_ADMIN_TOKEN=$(cat config/secrets/opencti_token_file.txt)" >> .env
$echo "OPENCTI_RABBITMQ_PASSWORD=$(cat config/secrets/rabbitmq_default_pass_file.txt)" >> .env
$echo "OPENCTI_MINIO_SECRET_KEY=$(cat config/secrets/minio_root_password_file.txt)" >> .env

$echo "CONNECTOR_EXPORT_FILE_STIX_ID=$(uuidgen)" >> .env
$echo "CONNECTOR_EXPORT_FILE_CSV_ID=$(uuidgen)" >> .env
$echo "CONNECTOR_EXPORT_FILE_TXT_ID=$(uuidgen)" >> .env
$echo "CONNECTOR_IMPORT_FILE_STIX_ID=$(uuidgen)" >> .env
$echo "CONNECTOR_IMPORT_DOCUMENT_ID=$(uuidgen)" >> .env
$echo "CONNECTOR_ANALYSIS_ID=$(uuidgen)" >> .env
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=opencti.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8080
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_ELASTIC=2
RESOURCES_LIMITS_MEMORY_ELASTIC=4g

RESOURCES_LIMITS_CPUS_RABBITMQ=1
RESOURCES_LIMITS_MEMORY_RABBITMQ=500m

RESOURCES_LIMITS_CPUS_VALKEY=1
RESOURCES_LIMITS_MEMORY_VALKEY=1g

RESOURCES_LIMITS_CPUS_MINIO=1
RESOURCES_LIMITS_MEMORY_MINIO=1g

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_OPENCTI=6.4.1
VERSION_CONNECTORS=6.4.1
VERSION_ELASTIC=8.15.4
VERSION_RABBITMQ=4.0.3-management
VERSION_VALKEY=8.0.1-alpine
VERSION_MINIO=RELEASE.2024-11-07T00-52-20Z-cpuv1

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
OPENCTI_ADMIN_EMAIL=<CHANGEME>
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=opencti.home.local

OPENCTI_ADMIN_EMAIL=groot@home.local
```

#### extend .env for connectors run

```sh
$echo "CONNECTORS_OPENCTI_ID=$(uuidgen)" >> .env
$echo "CONNECTORS_MITRE_ID=$(uuidgen)" >> .env
$echo "CONNECTORS_CVE_ID=$(uuidgen)" >> .env
$echo "CONNECTORS_MALPEDIA_ID=$(uuidgen)" >> .env
$echo "CONNECTORS_CISA_ID=$(uuidgen)" >> .env
$echo "CONNECTORS_MANDIANT_ID=$(uuidgen)" >> .env
$echo "CONNECTORS_URLHAUS_ID=$(uuidgen)" >> .env
$echo "CONNECTORS_ALIENVAULT_ID=$(uuidgen)" >> .env
$echo "CONNECTORS_VIRUSTOTAL_LIVEHUNT_NOTIFICATIONS_ID=$(uuidgen)" >> .env
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
$docker compose -f docker-compose-connectors.yaml up connector-opencti
$docker compose -f docker-compose-connectors.yaml up connector-mitre
$docker compose -f docker-compose-connectors.yaml up connector-cve
# $docker compose -f docker-compose-connectors.yaml up connector-malpedia
$docker compose -f docker-compose-connectors.yaml up connector-cisa-known-exploited-vulnerabilities
# $docker compose -f docker-compose-connectors.yaml up connector-mandiant
$docker compose -f docker-compose-connectors.yaml up connector-urlhaus
# $docker compose -f docker-compose-connectors.yaml up connector-alienvault
# $docker compose -f docker-compose-connectors.yaml up connector-virustotal-livehunt-notifications
```

#### extend .env for enrichment run

```sh
$echo "ENRICHMENT_CROWDSEC_ID=$(uuidgen)" >> .env
$echo "ENRICHMENT_VIRUSTOTAL_ID=$(uuidgen)" >> .env
$echo "ENRICHMENT_YARA_ID=$(uuidgen)" >> .env
$echo "ENRICHMENT_GREYNOISE_ID=$(uuidgen)" >> .env
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

## References

- <https://filigran.io/>
- <https://github.com/OpenCTI-Platform/opencti>
- <https://github.com/OpenCTI-Platform/docker>
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
