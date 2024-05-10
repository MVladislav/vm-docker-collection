# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [References](#references)

---

## basic

### create `.env` file following:

```env
...
```

#### example short .env

```env
VERSION=latest
```

```sh
$docker-compose up postgresql -d
$docker-compose run --rm --service-ports ms ./msfconsole -r docker/msfconsole.rc -y config/database.yml
```

---

## References

- <https://github.com/rapid7/metasploit-framework>
- <https://github.com/rapid7/metasploit-omnibus>
- <https://github.com/rapid7/metasploit-omnibus/blob/master/docker/ubuntu1804-x64/Dockerfile>
