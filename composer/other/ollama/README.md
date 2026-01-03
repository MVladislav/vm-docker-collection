# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
      - [download model](#download-model)
  - [References](#references)

---

## basic

> defined to work with traefik

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN_WEBUI=ai.home.local # not set in docker-compose, needs to be copied to .env
DOMAIN_OLLAMA=ollama.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL_WEBUI=http
PORT_WEBUI=8080
PORT_OLLAMA=11434
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED_WEBUI=default-secured@file
# default-whitelist@file | public-whitelist@file
MIDDLEWARE_SECURED_OLLAMA=default-whitelist@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=8
RESOURCES_LIMITS_MEMORY=16g
RESOURCES_RESERVATIONS_CPUS=4
RESOURCES_RESERVATIONS_MEMORY=8g

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_OLLAMA=rocm
VERSION_OPEN_WEBUI=git-90503be
```

#### example short .env

```env
DOMAIN_WEBUI=ai.home.local
DOMAIN_OLLAMA=ollama.home.local
```

#### download model

```sh
$docker exec -it "$(docker ps -q -f name=ollama-ollama)" ollama pull ministral-3:14b
# => https://ollama.com/library
# ministral-3:14b #tools #vision
# gpt-oss:20b #tools #thinking
# qwen2.5-coder:32b #tools
# gemma3:12b #vision
# gemma3:27b #vision
#
# llama3:8b
# codellama
# mistral
# dolphin-mistral
#   openhermes
#   openchat
# deepseek-coder
# deepseek-r1:7b #tools #thinking
# deepseek-r1:8b #tools #thinking
# deepseek-r1:14b #tools #thinking
# deepseek-r1:32b #tools #thinking
# starling-lm - summarisation and text analysis
# zephyr - summarization
```

---

## References

- <https://ollama.com/>
- <https://github.com/ollama/ollama>
- <https://hub.docker.com/r/ollama/ollama>
- <https://github.com/open-webui/open-webui>
- YT
  - <https://www.youtube.com/watch?v=PnIY1Ure6Nc>
