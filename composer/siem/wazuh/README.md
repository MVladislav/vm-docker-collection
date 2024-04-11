# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create default internal certs](#create-default-internal-certs)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [References](#references)

---

## basic

> defined to work with treafik

### create your `secrets`:

```sh
$pwgen -s 24 1 > config/secrets/dashboard_password_file_secret.txt
$sed "s|REPLACE_KIBANA_SERVER_HASH|$(cat config/secrets/dashboard_password_file_secret.txt | mkpasswd -m bcrypt -s -R 12)|" -i config/wazuh_indexer/internal_users.yml

$pwgen -s 24 1 > config/secrets/indexer_password_file_secret.txt
$sed "s|REPLACE_ADMIN_HASH|$(cat config/secrets/indexer_password_file_secret.txt | mkpasswd -m bcrypt -s -R 12)|" -i config/wazuh_indexer/internal_users.yml

$echo "$(pwgen -cns 24 1).*-" > config/secrets/api_password_file_secret.txt
$sed "s|password:.*|password: \"$(cat config/secrets/api_password_file_secret.txt)\"|" -i config/wazuh_dashboard/wazuh.yml

$sed "s|REPLACE_KIBANA_ARO_HASH|$(pwgen -s 24 1 | mkpasswd -m bcrypt -s -R 12)|" -i  config/wazuh_indexer/internal_users.yml
$sed "s|REPLACE_LOGSTASH_HASH|$(pwgen -s 24 1 | mkpasswd -m bcrypt -s -R 12)|" -i  config/wazuh_indexer/internal_users.yml
$sed "s|REPLACE_READALL_HASH|$(pwgen -s 24 1 | mkpasswd -m bcrypt -s -R 12)|" -i  config/wazuh_indexer/internal_users.yml
$sed "s|REPLACE_SNAP_SHOT_RESTORE_HASH|$(pwgen -s 24 1 | mkpasswd -m bcrypt -s -R 12)|" -i  config/wazuh_indexer/internal_users.yml

$echo "DASHBOARD_PASSWORD=$(cat config/secrets/dashboard_password_file_secret.txt)" >> .env
$echo "INDEXER_PASSWORD=$(cat config/secrets/indexer_password_file_secret.txt)" >> .env
$echo "API_PASSWORD=$(cat config/secrets/api_password_file_secret.txt)" >> .env
```

### create default internal certs

```sh
$docker-compose -f docker-compose-certs-generator.yaml run --rm generator
$sudo chown $USER:$USER config/wazuh_indexer_ssl_certs/*
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
DOMAIN=wazuh.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=https
PORT=5601
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=4
RESOURCES_LIMITS_MEMORY=2g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=4.8.0-beta4

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________


```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=wazuh.home.local
```

---

## References

- <https://wazuh.com/platform/overview/>
- <https://documentation.wazuh.com/current/deployment-options/docker/wazuh-container.html>
- <https://github.com/wazuh/wazuh-docker/tree/master/multi-node>
- <https://github.com/wazuh/wazuh-docker/blob/master/README.md>
- <https://opensearch.org/docs/latest/install-and-configure/install-dashboards/tls/>
- <https://documentation.wazuh.com/current/getting-started/architecture.html>
- <https://datatracker.ietf.org/doc/html/rfc3164>
- decoder
  - <https://documentation.wazuh.com/current/user-manual/ruleset/custom.html>
  - <https://github.com/wazuh/wazuh/tree/master/ruleset/decoders>
  - <https://github.com/wazuh/wazuh-ruleset/tree/master/decoders>
  - <https://documentation.wazuh.com/current/user-manual/ruleset/ruleset-xml-syntax/decoders.html>
  - <https://wazuh.com/blog/creating-decoders-and-rules-from-scratch/>
  - <https://wazuh.com/blog/sibling-decoders-flexible-extraction-of-information/>
  - <https://documentation.wazuh.com/current/user-manual/ruleset/decoders/sibling-decoders.html>
  - <https://medium.com/@HirushanTech/creating-custom-decoders-on-wazuh-siem-67563dfe9aff>
- additional service include references
  - <https://www.youtube.com/watch?v=jNSYinFdWAI>
  - <https://docs.opnsense.org/manual/wazuh-agent.html>
