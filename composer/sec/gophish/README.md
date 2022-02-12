# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [info](#info)
  - [References](#references)

---

## basic

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=latest
PORT=3333
```

## info

default credentials are printed in log, get it with:

```sh
$docker logs gophish_app*| grep "Please login with"
```

---

## References

- <https://github.com/gophish/gophish>
