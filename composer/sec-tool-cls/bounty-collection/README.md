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

```sh
$docker compose run --remove-orphans bounty
```

## basic

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=4
RESOURCES_LIMITS_MEMORY=4g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=latest

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
# NOTE: extend additional info here ...
```

#### example short .env

```env

```

---

|      |             |     |
| :--- | :---------- | :-- |
| apt  | nmap        |     |
| apt  | xsltproc    |     |
| py   | httpie      |     |
| py   | volatility3 |     |
| py   | NetExec     |     |
| rust | monolith    |     |
| go   | httpx       |     |
| go   | katana      |     |
| go   | subfinder   |     |
| go   | nuclei      |     |
| go   | alterx      |     |
| go   | cvemap      |     |
| go   | uncover     |     |
| go   | dalfox      |     |
| go   | gobuster    |     |
| go   | ffuf        |     |
| go   | unew        |     |
| go   | sj          |     |
| go   | gum         |     |

---

## References

- <https://docs.docker.com/compose/compose-file/compose-file-v3/#configs>
- <https://docs.docker.com/engine/swarm/secrets/>
- <https://docs.docker.com/compose/use-secrets/>
- <https://...>
- <https://github.com/aaaguirrep/offensive-docker/blob/master/Dockerfile>
