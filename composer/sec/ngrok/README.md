# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [config](#config)
  - [commands](#commands)
  - [References](#references)

---

## basic

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=latest
PORT=4040

NGROK_AUTH=...
NGROK_SUBDOMAIN=...
NGROK_HOSTNAME=...
NGROK_REMOTE_ADDR=...
NGROK_USERNAME=...
NGROK_PASSWORD=...
NGROK_PROTOCOL=...
NGROK_PORT=80
NGROK_REGION=...
NGROK_LOOK_DOMAIN=...
NGROK_BINDTLS=...
NGROK_HEADER=...
NGROK_DEBUG=...
```

## config

you can easy update the **ngrok conf** file under `./config/ngrok.yml`
and build docker again:

```sh
$docker-compose build
```

or use **env** variables if you do not need special setup

## commands

run:

```sh
$docker-compose up -d
```

find assigned domain:

```sh
$curl $(docker-compose port ngrok 4040)/api/tunnels | jq
```

---

## References

- <https://ngrok.com/>
- <https://github.com/wernight/docker-ngrok>
