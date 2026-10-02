# SETUP

## basic

> defined to work with traefik

> **this is not working in swarm mode** \
> **it can only be started with network in bride mode**

### pre setup host:

```sh
sudo ufw allow proto tcp from any to any port 443
sudo ufw allow 51821:51830/udp
sudo iptables --policy FORWARD ACCEPT
```

### create `.env` file following:

```env
NODE_ROLE=manager

VERSION_NETMAKER=v0.99.0
VERSION_NETMAKER_UI=v0.99.0
VERSION_COREDNS=1.14.7
VERSION_MQTT=2.0.22-openssl

LB_SWARM=true
DOMAIN=netmaker.home.local

PROTOCOL_NETMAKER_API=http
PORT_NETMAKER_API=8081
PROTOCOL_NETMAKER_UI=http
PORT_NETMAKER_UI=80
TRAEFIK_ENTRYPOINT_MQTT=mqtt
PORT_MQTT=8883

# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED_NETMAKER_UI=default-secured@file,nmui-security@docker
MIDDLEWARE_SECURED_NETMAKER_API=default-secured@file

SERVER_PUBLIC_IP=<PUBLIC_IP>
ACME_MAIL=<EMAIL>

# tr -dc A-Za-z0-9 </dev/urandom | head -c 30 ; echo ''
MASTER_KEY=<KEY>

MQ_USERNAME=netmaker
# tr -dc A-Za-z0-9 </dev/urandom | head -c 30 ; echo ''
MQ_PASSWORD=<PASSWORD>

# optional, netclient hole punching
STUN_SERVERS=stun1.l.google.com:19302,stun2.l.google.com:19302,stun3.l.google.com:19302,stun4.l.google.com:19302
```

---

## References

- <https://docs.netmaker.org/quick-start.html>
