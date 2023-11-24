# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
      - [ubuntu 23.04](#ubuntu-2304)
      - [ubuntu 22.04](#ubuntu-2204)
  - [References](#references)

---

find source and docker-compose on [github](https://github.com/MVladislav/vm-docker-collection/tree/main/composer/helper/ansible/docker-ubuntu-systemd-sudo-ansible)

---

## basic

### create `.env` file following:

#### ubuntu 23.04

```env
BUILD_DATE=2023
VERSION_UBUNTU=23.04
# for python 3.11 with ubuntu 23.04
PYTHON_ARGS=--break-system-packages
```

#### ubuntu 22.04

```env
BUILD_DATE=2023
VERSION_UBUNTU=22.04
# for python 3.11 with ubuntu 22.04
PYTHON_ARGS=
```

---

## References

- <https://github.com/geerlingguy/docker-ubuntu2204-ansible>
