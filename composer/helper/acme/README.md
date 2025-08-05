# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
      - [CA Server](#ca-server)
      - [example run \[IONOS\]](#example-run-ionos)
      - [example run \[HETZNER\]](#example-run-hetzner)
  - [Helper](#helper)
  - [References](#references)

---

## basic

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=latest
```

#### CA Server

```sh
... --server https://api.test4.buypass.no/acme/directory
... --server https://api.buypass.com/acme/directory

# needs EAB information (KID & HMACENCODED)
... --server https://acme.zerossl.com/v2/DV90
... --server zerossl

... --server https://acme-staging-v02.api.letsencrypt.org/directory
... --server https://acme-v02.api.letsencrypt.org/directory
```

#### example run [IONOS]

> <https://github.com/acmesh-official/acme.sh/wiki/dnsapi2#dns_ionos>

```env
IONOS_PREFIX="..."
IONOS_SECRET="..."
```

```sh
$docker compose run --rm acme --issue \
  --dns dns_ionos \
  --dnssleep 20 \
  --ecc \
  -m my@example.com \
  --test \
  -d example.com
```

#### example run [HETZNER]

> <https://github.com/acmesh-official/acme.sh/wiki/dnsapi2#dns_hetzner>

```env
HETZNER_Token="..."
```

```sh
$docker compose run --rm acme --issue \
  --dns dns_hetzner \
  --dnssleep 20 \
  --ecc \
  -m my@example.com \
  --test \
  -d example.com
```

## Helper

```sh
for cert in ./acme/*.eu_ecc/*.cer; do
  echo "==> '$cert'"
  openssl x509 -in "$cert" -noout -issuer -subject -dates -text
  echo "************************************************"
done
```

---

## References

- <https://github.com/acmesh-official/acme.sh>
- <https://github.com/acmesh-official/acme.sh/wiki/Run-acme.sh-in-docker>
