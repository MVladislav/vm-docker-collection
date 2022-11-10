# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [test alert](#test-alert)
  - [References](#references)

---

**find source and docker-compose on [github](https://github.com/MVladislav/vm-docker-collection/tree/develop/composer/sec/suricata)**

---

## basic

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=7.0.0-beta1

S_INTERFACE=eth0
```

## test alert

```sh
$curl http://testmynids.org/uid/index.html
$curl http://www.testmyids.ca/
```

---

## References

- <https://suricata.readthedocs.io/en/latest/install.html>
- <https://github.com/OISF/suricata/pull/8128/commits/abeee13259a3ffa4448e0e30e2dc7551ee1bb9cf>
- <https://suricata.readthedocs.io/en/suricata-6.0.0/command-line-options.html>
