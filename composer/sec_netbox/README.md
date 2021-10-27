# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [copy config file from git](#copy-config-file-from-git)
    - [overwrite default `.env` files under folder `config/env/*`:](#overwrite-default-env-files-under-folder-configenv)
  - [References](#references)

---

## basic

### copy config file from git

```sh
$git clone https://github.com/netbox-community/netbox-docker.git && mv netbox-docker/startup_scripts netbox-docker/initializers netbox-docker/configuration netbox-docker/reports netbox-docker/scripts netbox-docker/env config && rm netbox-docker -rf
```

### overwrite default `.env` files under folder `config/env/*`:

create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay
```

specific files:

`netbox.env`

```env
DB_PASSWORD=AWF4nID7jP0RsRotMzEEI
REDIS_CACHE_PASSWORD=AWF4nID7jP0RsRotMzEEI
REDIS_PASSWORD=AWF4nID7jP0RsRotMzEEI
SECRET_KEY=8QSX6wEqH3w+fdQth2z1FgOZF13RqTjbsv5YqFqqTMVmqMKmg
SUPERUSER_API_TOKEN=fzaqA0HdFxnbHLUAwWlt6q99JcbNxg2W5dKaJJF3
SUPERUSER_PASSWORD=swordfish
```

`postgres.env`

```env
POSTGRES_PASSWORD=AWF4nID7jP0RsRotMzEEI
```

`redis-cache.env`

```env
REDIS_PASSWORD=AWF4nID7jP0RsRotMzEEI
```

`redis.env`

```env
REDIS_PASSWORD=AWF4nID7jP0RsRotMzEEI
```

---

## References

- <https://github.com/netbox-community/netbox-docker>
