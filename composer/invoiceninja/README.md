# SETUP

```sh
    MVladislav
```

**not working :/ (i think it has not work last time ^^), current testing**

---

- [SETUP](#setup)
  - [official](#official)
    - [create ninja key:](#create-ninja-key)
    - [create storage](#create-storage)
    - [create `.env` file following:](#create-env-file-following)
  - [from source](#from-source)
    - [create Docker-Image local](#create-docker-image-local)
    - [create ninja key:](#create-ninja-key-1)
    - [create `.env` file following:](#create-env-file-following-1)
  - [References](#references)

---

## official

### create ninja key:

```sh
$docker run --rm -it invoiceninja/invoiceninja php artisan key:generate --show
```

### create storage

```sh
$sudo mkdir -p /var/invoiceninja/public /var/invoiceninja/storage && sudo chmod 755 /var/invoiceninja/public && sudo chmod 755 /var/invoiceninja/storage && sudo chown -R 1500:1500 /var/invoiceninja
```

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

APP_ENV=production
APP_DEBUG=false
APP_URL=http://localhost
APP_KEY=<add ninja key her, with 'base64:...'>
APP_CIPHER=AES-256-CBC
APP_LOCALE=de

DB_TYPE=mysql
MYSQL_ROOT_PASSWORD=swordfish
DB_STRICT=false
DB_HOST=localhost
DB_DATABASE=ninja
DB_USERNAME=ninja
DB_PASSWORD=ninja
```

## from source

### create Docker-Image local

```sh
$docker build -t localhost:5000/invoiceninja:latest --build-arg INVOICENINJA_VERSION=5.0.56-release .
$docker image push localhost:5000/invoiceninja:latest
```

### create ninja key:

```sh
$docker run --rm -it localhost:5000/invoiceninja:latest php artisan key:generate --show
```

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

PHP_VERSION=7.4
INVOICENINJA_VERSION=5.2.19-release

APP_ENV=production
APP_DEBUG=false
APP_URL=http://localhost
APP_KEY=<add ninja key her, with 'base64:...'>
APP_CIPHER=AES-256-CBC
APP_LOCALE=de

MULTI_DB_ENABLED=false
DB_TYPE=mysql
MYSQL_ROOT_PASSWORD=swordfish
DB_STRICT=false
DB_HOST=db
DB_DATABASE=ninja
DB_USERNAME=ninja
DB_PASSWORD=ninja

DB_HOST1=db
DB_USERNAME1=ninja
DB_PASSWORD1=ninja
DB_DATABASE1=ninja

#this is a system variable please do not remove
IS_DOCKER=true
```

---

## References

- <https://www.invoiceninja.com/>
- <https://github.com/invoiceninja/dockerfiles>
