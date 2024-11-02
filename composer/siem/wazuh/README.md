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
  - [Agent](#agent)
    - [Linux Install](#linux-install)
      - [Password Enrollment protected](#password-enrollment-protected)
      - [Remove an Agent](#remove-an-agent)
    - [Extend/Update agent config](#extendupdate-agent-config)
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
DOMAIN=siem.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=https
PORT=5601
# # default-secured@file | public-whitelist@file | authentik@file
# MIDDLEWARE_SECURED=default-secured@file
# default-whitelist@file | public-whitelist@file
MIDDLEWARE_SECURED=default-whitelist@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=4
RESOURCES_LIMITS_MEMORY=2g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

RESOURCES_LIMITS_CPUS_INDEXER=1
RESOURCES_LIMITS_MEMORY_INDEXER=2g
RESOURCES_RESERVATIONS_CPUS_INDEXER=0.001
RESOURCES_RESERVATIONS_MEMORY_INDEXER=32m

WAZUH_INDEXER_JAVA=1g

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=4.9.1

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________

```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=siem.home.local
```

## Agent

### Linux Install

Change below following placeholder:

- `<AGENT_NAME>`
- `<SERVER_ADDRESS>`

Below is agent version `4.x` used inside `https://packages.wazuh.com/4.x/apt/` change for your needs.

```sh
# install dependencies
$sudo apt install curl net-tools

# install wazuh
$curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/wazuh.gpg >/dev/null && sudo chmod 644 /etc/apt/trusted.gpg.d/wazuh.gpg
$echo "deb [signed-by=/etc/apt/trusted.gpg.d/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee /etc/apt/sources.list.d/wazuh.list && sudo chmod 644 /etc/apt/sources.list.d/wazuh.list
$sudo apt update
$sudo WAZUH_MANAGER='wazuh.home.local' WAZUH_AGENT_NAME='cis-2204-ubuntu-test' apt install wazuh-agent

# start wazuh
$sudo systemctl daemon-reload
$sudo systemctl enable wazuh-agent
$sudo systemctl start wazuh-agent
```

#### Password Enrollment protected

```sh
$echo "<CUSTOM_PASSWORD>" > /var/ossec/etc/authd.pass
$chmod 640 /var/ossec/etc/authd.pass
$chown root:wazuh /var/ossec/etc/authd.pass
```

#### Remove an Agent

```sh
$docker exec -it "$(docker ps -q -f name=wazuh_wazuh-master)" /var/ossec/bin/manage_agents
```

- <https://documentation.wazuh.com/current/user-manual/agent/agent-management/remove-agents/remove.html>

### Extend/Update agent config

```xml
<wodle name="docker-listener">
  <disabled>no</disabled>
  <interval>10m</interval>
  <attempts>5</attempts>
  <run_on_start>no</run_on_start>
</wodle>

<directories>/etc,/usr/bin,/usr/sbin</directories>
<directories>/bin,/sbin,/boot</directories>
<directories realtime="yes">/home/root</directories>
<directories realtime="yes">/home/<USERNAME>/Downloads</directories>
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
- agent
  - <https://documentation.wazuh.com/current/user-manual/agent/agent-enrollment/security-options/using-password-authentication.html>
  - <https://documentation.wazuh.com/current/user-manual/capabilities/container-security/monitoring-docker.html>
  - <https://wazuh.com/blog/benefits-of-using-aes-in-our-communications/>
  - <https://documentation.wazuh.com/current/user-manual/wazuh-dashboard/settings.html#enrollment-dns>
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
- YT
  - <https://www.youtube.com/watch?v=RjvKn0Q3rgg>
