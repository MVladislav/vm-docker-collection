# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env](#example-short-env)
  - [FAQ](#faq)
    - [Default Credentials](#default-credentials)
    - [changes config](#changes-config)
  - [References](#references)

---

## basic

> defined to work with traefik

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # by default "bridge"

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN_RIPPING=ripping.home.local # not set in docker-compose, needs to be copied to .env
DOMAIN_TDARR=tdarr.home.local # not set in docker-compose, needs to be copied to .env

PROTOCOL_RIPPING=http
PORT_RIPPING=8080
PROTOCOL_TDARR=http
PORT_TDARR=8265

# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=8
RESOURCES_LIMITS_MEMORY=8g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION_RIPPING=latest
VERSION_TDARR=latest

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
# NOTE: extend additional info here ...
```

#### example short .env

```env
DOMAIN_RIPPING=ripping.home.local
DOMAIN_TDARR=tdarr.home.local
```

---

## FAQ

### Default Credentials

- username: `admin`
- password: `password` # pragma: allowlist secret

### changes config

```ini
PREVENT_99: false
MAINFEATURE: true

HB_PRESET_DVD: "H.265 VCE 1080p"
HB_PRESET_BD: "HQ 1080p30 Surround"

HB_ARGS_DVD: "--subtitle scan -F --quality=18 --encoder-preset=quality"
HB_ARGS_BD: "--subtitle scan -F --quality=22 --encoder-preset=quality --subtitle-burned --audio-lang-list eng --all-audio"
```

---

## References

- <https://github.com/automatic-ripping-machine/automatic-ripping-machine>
- <https://github.com/automatic-ripping-machine/automatic-ripping-machine/blob/main/scripts/docker/start_arm_container.sh>
- tadarr
  - <https://tdarr.io/>
  - <https://docs.tdarr.io/docs/installation/docker/run-compose>
  - <https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html>
  - <https://docs.docker.com/compose/gpu-support/>
- YT
  - <https://www.youtube.com/watch?v=UA1Sktq40pA>
  - <https://www.youtube.com/watch?v=Ut12su3pUHE>
