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

> defined to work with treafik

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=ai.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=8080
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=8
RESOURCES_LIMITS_MEMORY=16g
RESOURCES_RESERVATIONS_CPUS=4
RESOURCES_RESERVATIONS_MEMORY=8g

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_OLLAMA=0.1.34-rocm
VERSION_OPEN_WEBUI=git-90503be
```

#### example short .env

```env
NETWORK_MODE=overlay
DOMAIN=ai.home.local
```

#### download model

```sh
$docker exec -it "$(docker ps -q -f name=ollama_ollama)" ollama pull llama3
# mistral
```

---

## References

- <https://ollama.com/>
- <https://github.com/ollama/ollama>
- <https://hub.docker.com/r/ollama/ollama>
- <https://github.com/open-webui/open-webui>
