# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
    - [edit config files in `./config`](#edit-config-files-in-config)
      - [`config.ini`](#configini)
  - [References](#references)

---

## basic

> defined to work with treafik

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

BUILD_DATE: 2022
PYTHON_VERSION: 3.6.12-alpine3.12
GROUP: 1000
USER: 1000

VERSION=latest
```

### edit config files in `./config`

- `crontab`
  > when sophos python should be schedule collect new data
- `config.ini`
  > the sophos conif.ini

#### `config.ini`

get jwt:

- change:
  - `<client-id>`
  - `<client-secret>`

```sh
$curl -XPOST -H "Content-Type:application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials&client_id=<client-id>&client_secret=<client-secret>&scope=token" \
  https://id.sophos.com/api/v2/oauth2/token
```

get tenant-id:

- change:
  - `<jwt>`

```sh
$curl -XGET -H "Authorization: Bearer <jwt>" https://api.central.sophos.com/whoami/v1
```

---

## References

- <https://developer.sophos.com/docs/siem-v1/1/routes/events/get>
- <https://github.com/sophos/Sophos-Central-SIEM-Integration>
- <https://nschdr.medium.com/running-scheduled-python-tasks-in-a-docker-container-bf9ea2e8a66c>
- <https://blog.thesparktree.com/cron-in-docker>
