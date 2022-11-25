# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
      - [`.env` credentials](#env-credentials)
    - [create `.env` file following:](#create-env-file-following)
  - [References](#references)

---

**find source and docker-compose on [github](https://github.com/MVladislav/vm-docker-collection/tree/develop/composer/siem/sophos)**

---

## basic

> defined to work with treafik

### create your `secrets`:

> do not use **TOKEN_INFO** anymore instead use the 3 other secrets below

_replace TOKEN_INFO with your token info_

```sh
: 'API Access URL + Headers'
: 'API token setup steps: https://community.sophos.com/kb/en-us/125169'
: '<Copy API Access URL + Headers block from Sophos Central here>'
$echo "TOKEN_INFO" > config/secrets/token_info.txt
```

_replace CLIENT_ID and CLIENT_SECRET with your token info_ \
_the variable TENANT_ID is optional if needed_

```sh
: 'Client ID and Client Secret for Partners, Organizations and Tenants'
: '<Copy Client ID and Client Secret from Sophos Central here>'
$echo "CLIENT_ID" > config/secrets/client_id.txt
$echo "CLIENT_SECRET" > config/secrets/client_secret.txt
: 'Customer tenant Id'
$echo "TENANT_ID" > config/secrets/tenant_id.txt
```

#### `.env` credentials

get jwt:

- change:
  - `<CLIENT_ID>`
  - `<CLIENT_SECRET>`

```sh
$curl -XPOST -H "Content-Type:application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials&client_id=<CLIENT_ID>&client_secret=<CLIENT_SECRET>&scope=token" \
  https://id.sophos.com/api/v2/oauth2/token
```

get tenant-id:

- change:
  - `<JWT>`

```sh
$curl -XGET -H "Authorization: Bearer <JWT>" https://api.central.sophos.com/whoami/v1
```

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

BUILD_DATE=2022
PYTHON_VERSION=3.10.8-alpine3.16
GROUP=1000
USER=1000

VERSION=2022-10-17

# Host URL for Oauth token
AUTH_URL = https://id.sophos.com/api/v2/oauth2/token

# whoami API host url
API_HOST = api.central.sophos.com

# format can be json, cef, xlsx or keyvalue
FORMAT = json

SOPHOS_SIEM_HOME = /var/log/sophos

# filename can be syslog, stdout, any custom filename
FILENAME = result.txt

# if format set to xlsx
FILENAME_XLSX = result.xlsx

# endpoint can be event, alert or all
ENDPOINT = event

# syslog properties
# for remote address use <remoteServerIp>:<port>, for e.g. 192.1.2.3:514
# for linux local systems use /dev/log
# for MAC OSX use /var/run/syslog
# append_nul will append null at the end of log message if set to true
ADDRESS = /dev/log
FACILITY = daemon
SOCKTYPE = udp
APPEND_NUL = false

# cache file full or relative path (with a ".json" extension)
STATE_FILE_PATH = state/siem_sophos.json

# Delay the data collection by X minute to avoid events missing issue from Sophos API
# The issue could be due to some specific host being ahead in time for a few minute and Sophos Central would consider events received from that host as a checkpoint.
EVENTS_FROM_DATE_OFFSET_MINUTES = 0

# Delay the data collection by X minute.
ALERTS_FROM_DATE_OFFSET_MINUTES = 0

# Convert the dhost field to valid fqdn.
CONVERT_DHOST_FIELD_TO_VALID_FQDN = true
```

---

## References

- <https://developer.sophos.com/docs/siem-v1/1/routes/events/get>
- <https://github.com/sophos/Sophos-Central-SIEM-Integration>
- <https://nschdr.medium.com/running-scheduled-python-tasks-in-a-docker-container-bf9ea2e8a66c>
- <https://blog.thesparktree.com/cron-in-docker>
