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

> defined to work with traefik

### create `.env` file following:

```env
VERSION_PORTAINER=2.16.2-alpine
VERSION_AGENT=2.16.2-alpine

LB_SWARM=true
DOMAIN=portainer.home.local
PROTOCOL=http
PORT=9000
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=protected-secured@file
```

---

## References

- <https://github.com/portainer/portainer-compose>
- <https://www.digitalocean.com/community/tutorials/how-to-configure-the-linux-firewall-for-docker-swarm-on-ubuntu-16-04>
