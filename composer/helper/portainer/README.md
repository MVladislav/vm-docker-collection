# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [References](#references)

---

## basic

> defined to work with treafik

### create `.env` file following:

```env
NETWORK_MODE=overlay

VERSION=latest

LB_SWARM=true
DOMAIN=portainer.home.local
PROTOCOL=http
PORT=9000
# default-secured@file | protected-secured@file | admin-secured@file
MIDDLEWARE_SECURED=protected-secured@file

# PORT_HTTP=9000
# PORT_HTTPS=9443
```

---

## References

- <https://github.com/portainer/portainer-compose>
- <https://www.digitalocean.com/community/tutorials/how-to-configure-the-linux-firewall-for-docker-swarm-on-ubuntu-16-04>
