# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [Commands](#commands)
    - [check the model’s max context length](#check-the-models-max-context-length)
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

## Commands

### check the model’s max context length

```sh
$docker exec -it "$(docker ps -q -f name=ollama-ollama)" ollama show <model_name>
# set `OLLAMA_CONTEXT_LENGTH` <= `context length`
#   - right value is a compromise between that limit and what your RAM/VRAM and workload can handle comfortably
#   - start testing with for example '16384' than '32768' than '65536' and so on
```

#### download model

```sh
$docker exec -it "$(docker ps -q -f name=ollama-ollama)" ollama pull <model_name>
# => https://ollama.com/library (code / instruct)
# gpt-oss:20b #tools #thinking #cloud
# deepseek-r1:32b #tools #thinking
# qwen3-coder:30b #tools #cloud
# ministral-3:14b #tools #vision #cloud
# codestral:22b
```

---

## References

- <https://ollama.com/>
- <https://github.com/ollama/ollama>
- <https://hub.docker.com/r/ollama/ollama>
- <https://github.com/open-webui/open-webui>
- YT
  - <https://www.youtube.com/watch?v=PnIY1Ure6Nc>
