# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
    - [traefik](#traefik)
  - [References](#references)

---

## basic

> defined to work with treafik

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=11.5.21
VERSION_PHP=8.0
TYPO3_VERSION=11.5.21
TYPO3_SHA256=babb6cba545691e30353c6d3cd5d14017685eeb650e638b660ce570cbb6f6f77

#VERSION=10.4.34
#VERSION_PHP=7.4
#TYPO3_VERSION=10.4.34
#TYPO3_SHA256=e1cc1b8e51277fc4981f46be76a6ef65a771e4fa40132dbeb650b27cc00ca13c

LB_SWARM=true
DOMAIN=typo3.home.local
PROTOCOL=http
PORT=80
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file
```

### traefik

after install, with traefik usage,
change in file `/var/www/html/typo3conf/LocalConfiguration.php`:

- add the line `'security.backend.enforceReferrer' => false,`
- into `SYS > features`

---

## References

- <https://get.typo3.org/#download>
- <https://hub.docker.com/_/composer>
- <https://docs.typo3.org/m/typo3/guide-installation/11.5/en-us/Major/UpgradeCore.html>
- <https://docs.typo3.org/m/typo3/reference-inside/8.7/en-us/CoreArchitecture/Configuration/LocalConfiguration/Index.html>
