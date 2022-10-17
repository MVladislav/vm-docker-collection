# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [pre setup host:](#pre-setup-host)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
  - [References](#references)

---

## basic

> defined to work with treafik

### pre setup host:

```sh
$sudo ufw allow proto tcp from any to any port 443
$sudo ufw allow 51821:51830/udp
$sudo iptables --policy FORWARD ACCEPT
```

### create your `secrets`:

```sh
$echo "swordfish" | docker secret create my_external_secret -
$echo "swordfish" > config/secrets/my_file_secret.txt
```

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION_NETMAKER=v0.16.1
VERSION_NETMAKER_UI=v0.16.1
VERSION_COREDNS=latest
VERSION_MQTT=2.0.11-openssl

LB_SWARM=true
DOMAIN=netmaker.home.local
PROTOCOL_NETMAKER=http
PORT_NETMAKER=8081
PROTOCOL_NETMAKER_UI=http
PORT_NETMAKER_UI=80
PROTOCOL_MQTT=http
PORT_MQTT=8883

SERVER_PUBLIC_IP=<PUBLIC_IP>
YOUR_EMAIL=<EMAIL>

# tr -dc A-Za-z0-9 </dev/urandom | head -c 30 ; echo ''
MASTER_KEY=<KEY>

MQ_ADMIN_PASSWORD=<PASSWORD>
```

---

## References

- <https://docs.netmaker.org/quick-start.html>
