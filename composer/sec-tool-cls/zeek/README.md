# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [edit node.cfg](#edit-nodecfg)
    - [create `.env` file following:](#create-env-file-following)
  - [References](#references)

---

## basic

### edit node.cfg

change **interface** to which interface you will monitor

### create `.env` file following:

```env
# NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=VERSION:-5.1.1
```

---

## References

- <https://docs.zeek.org/en/master/install.html#docker-images>
- <https://hub.docker.com/r/zeekurity/zeek>
