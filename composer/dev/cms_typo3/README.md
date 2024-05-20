# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create your `secrets`:](#create-your-secrets)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [Helper](#helper)
    - [traefik](#traefik)
    - [mariadb](#mariadb)
    - [install from shell](#install-from-shell)
  - [References](#references)

---

## basic

> defined to work with treafik

### create your `secrets`:

```sh
$pwgen -s 18 1 > config/secrets/mariadb_user_password.txt
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
DOMAIN=page.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=80
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_TYPO3=13.1.1
VERSION_MARIADB=11.3

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
# NOTE: extend additional info here ...

# BUILD variable to adjust the apps
# ______________________________________________________________________________
VERSION_PHP=8.3-apache
VERSION_TYPO3=13.1.1
TYPO3_SHA256=e57cbb2e201e0fb00007a75e8abf0f796146ea3771240f48f6e3c0d5d37626e8
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=page.home.local
```

## Helper

### traefik

open file for edit:

```sh
$docker exec --privileged -it "$(docker ps -q -f name=typo3_typo3)" vim /var/www/html/typo3conf/system/settings.php
```

add into `SYS > features` the following setting:

```php
<?php
return [
    'SYS' => [
        'features' => [
           'security.backend.enforceReferrer' => false,
        ],
    ],
]
```

### mariadb

for your script change lines from

```sql
CREATE DATABASE IF NOT EXISTS ...
USE ...
```

into

```sql
DROP DATABASE IF EXISTS `typo3`;
CREATE DATABASE IF NOT EXISTS `typo3` DEFAULT CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci;
USE `typo3`;
```

import old database records

```sh
# $docker exec --privileged -it "$(docker ps -q -f name=typo3_mariadb)" bash -c 'mariadb -u typo3 -p -e "DROP DATABASE IF EXISTS typo3; CREATE DATABASE IF NOT EXISTS typo3;"'
$docker exec --privileged -it "$(docker ps -q -f name=typo3_mariadb)" bash -c 'mariadb -u typo3 -p < /sql/records.sql'
```

### install from shell

```sh
$docker exec --privileged -it "$(docker ps -q -f name=typo3_typo3)" vim /var/www/html/typo3conf/system/settings.php
```

```php
return [
    'DB' => [
        'Connections' => [
            'Default' => [
                'dbname' => 'typo3',
                'charset' => 'utf8mb4',
                'driver' => 'mysqli',
                'host' => 'mariadb',
                'password' => '<PASSWORD>',
                'port' => 3306,
                'tableoptions' => [
                    'charset' => 'utf8mb4',
                    'collate' => 'utf8mb4_unicode_ci',
                ],
                'user' => 'typo3',
            ],
        ],
    ],
]
```

---

## References

- <https://get.typo3.org/#download>
- <https://hub.docker.com/_/composer>
- <https://docs.typo3.org/m/typo3/guide-installation/11.5/en-us/Major/UpgradeCore.html>
- <https://docs.typo3.org/m/typo3/reference-inside/8.7/en-us/CoreArchitecture/Configuration/LocalConfiguration/Index.html>
- <https://docs.typo3.org/m/typo3/reference-exceptions/main/en-us/Exceptions/1588095935.html>
- <https://t3planet.com/blog>
- <https://www.derhansen.de/2022/12/2022-12-31-typo3-12-not-working-after-extension-install.html>
