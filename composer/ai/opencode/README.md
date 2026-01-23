# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [run](#run)
  - [References](#references)

---

## basic

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=bridge

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# BUILD
# ______________________________________________________________________________
UBUNTU_VERSION=25.10

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=1.1.28

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
BASE_URL=http://ollama:11434/v1
OPENCODE_MODEL=ministral-3:14b # ministral-3:14b | qwen3-coder:30b | gpt-oss:20b
WORKSPACE=/workspace
```

#### example short .env

```env
OPENCODE_MODEL=gpt-oss:20b
WORKSPACE=/tmp/my-project
```

## run

```sh
$docker compose --rm run opencode
```

---

## References

- <https://opencode.ai>
- <https://opencode.ai/docs#install>
- <https://github.com/anomalyco/opencode>
- docs:
  - [permissions](https://opencode.ai/docs/permissions)
