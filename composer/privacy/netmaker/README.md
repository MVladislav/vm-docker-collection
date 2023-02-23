# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [pre setup host:](#pre-setup-host)
    - [create `.env` file following:](#create-env-file-following)
  - [References](#references)

---

## basic

> defined to work with treafik

> **this is not working in swarm mode** \
> **it can only be started with network in bride mode**

### pre setup host:

```sh
$sudo ufw allow proto tcp from any to any port 443
$sudo ufw allow 51821:51830/udp
$sudo iptables --policy FORWARD ACCEPT
```

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION_NETMAKER=v0.18.0
VERSION_NETMAKER_UI=v0.18.0
VERSION_COREDNS=1.10.1
VERSION_MQTT=2.0.15-openssl
VERSION_TRAEFIK=v3.0

LB_SWARM=true
DOMAIN=netmaker.home.local

PROTOCOL_NETMAKER_API=http
PORT_NETMAKER_API=8081
PROTOCOL_NETMAKER_UI=http
PORT_NETMAKER_UI=80
PROTOCOL_MQTT=http
PORT_MQTT=8883

# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED_NETMAKER_UI=default-secured@file,nmui-security@docker
MIDDLEWARE_SECURED_NETMAKER_API=default-secured@file

SERVER_PUBLIC_IP=<PUBLIC_IP>
ACME_MAIL=<EMAIL>

# tr -dc A-Za-z0-9 </dev/urandom | head -c 30 ; echo ''
MASTER_KEY=<KEY>

MQ_ADMIN_PASSWORD=<PASSWORD>
```

---

## References

- <https://docs.netmaker.org/quick-start.html>
