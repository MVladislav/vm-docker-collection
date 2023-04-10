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

find source and docker-compose on [github](https://github.com/MVladislav/vm-docker-collection/tree/main/composer/helper/ansible/docker-ubuntu-systemd-sudo-ansible)

---

## basic

### create `.env` file following:

```env
BUILD_DATE=2023
VERSION_UBUNTU=23.04
# for python 3.11 with ubuntu 23.04
PYTHON_ARGS=--break-system-packages
```

---

## References

- <https://github.com/geerlingguy/docker-ubuntu2204-ansible>
