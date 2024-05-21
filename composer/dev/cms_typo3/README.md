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
    - [traefik and logging](#traefik-and-logging)
    - [mariadb import](#mariadb-import)
      - [install from shell](#install-from-shell)
    - [upgrade process](#upgrade-process)
  - [Additional](#additional)
    - [installToolPassword](#installtoolpassword)
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

### traefik and logging

open file for edit:

```sh
# >= version 12
$docker exec --privileged -it "$(docker ps -q -f name=typo3_typo3)" vim /var/www/html/typo3conf/system/additional.php
# <= version 11
$docker exec --privileged -it "$(docker ps -q -f name=typo3_typo3)" vim /var/www/html/typo3conf/AdditionalConfiguration.php
```

```php
<?php
$GLOBALS['TYPO3_CONF_VARS']['SYS']['reverseProxySSL'] = '*';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['reverseProxyIP'] = '*';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['displayErrors'] = '1';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['features']['security.backend.enforceReferrer'] = 'false';
```

### mariadb import

inside your sql script, change lines from

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

than import old database records with following command

```sh
# $docker exec --privileged -it "$(docker ps -q -f name=typo3_mariadb)" bash -c 'mariadb -u typo3 -p -e "DROP DATABASE IF EXISTS typo3; CREATE DATABASE IF NOT EXISTS typo3;"'
$docker exec --privileged -it "$(docker ps -q -f name=typo3_mariadb)" bash -c 'mariadb -u typo3 -p < /sql/records.sql'
```

```sh
$docker exec --privileged -it "$(docker ps -q -f name=typo3_mariadb)" bash -c 'mariadb-dump -u typo3 -p typo3 > /sql/dump.sql'
```

#### install from shell

```sh
# >= version 12
$docker exec --privileged -it "$(docker ps -q -f name=typo3_typo3)" vim /var/www/html/typo3conf/system/settings.php
# <= version 11
$docker exec --privileged -it "$(docker ps -q -f name=typo3_typo3)" vim /var/www/html/typo3conf/LocalConfiguration.php
```

> mostly when you get over web-page until stage `3 / 5 - 60% Complete` you only need to add into conf file `'dbname' => 'typo3',`

```php
return [
    'DB' => [
        'Connections' => [
            'Default' => [
                'dbname' => 'typo3',
                // ...
            ],
        ],
    ],
]
```

### upgrade process

```sh
$docker exec --privileged -it "$(docker ps -q -f name=typo3_typo3)" php /var/www/html/typo3/sysext/core/bin/typo3 referenceindex:update
```

## Additional

### installToolPassword

```sh
# >= version 12
$docker exec --privileged -it "$(docker ps -q -f name=typo3_typo3)" vim /var/www/html/typo3conf/system/settings.php
# <= version 11
$docker exec --privileged -it "$(docker ps -q -f name=typo3_typo3)" vim /var/www/html/typo3conf/LocalConfiguration.php
```

```php
'BE' => [
   'installToolPassword' => '$argon2i$v=xyz',
],
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
- <https://docs.typo3.org/m/typo3/tutorial-getting-started/main/en-us/Troubleshooting/TYPO3.html>
- <https://docs.j7k6.org/typo3-reverse-proxy-ssl/>
