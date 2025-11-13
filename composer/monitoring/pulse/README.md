# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
      - [example short .env (swarm)](#example-short-env-swarm)
      - [example short .env (bridge)](#example-short-env-bridge)
  - [FAQ](#faq)
    - [Create pve](#create-pve)
    - [Create pbs](#create-pbs)
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
DOMAIN=pulse.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=7655
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=4.30.0

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
# NOTE: extend additional info here ...
```

#### example short .env (swarm)

```env
DOMAIN=pulse.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=pulse.home.local
```

---

## FAQ

### Create pve

```sh
pveum user add pulse-monitor@pam --comment "Pulse monitoring service"
pveum user token add pulse-monitor@pam pulse-token --privsep 0
pveum aclmod / -user pulse-monitor@pam -role PVEAuditor
```

### Create pbs

```sh
proxmox-backup-manager user create pulse-monitor@pbs
proxmox-backup-manager user generate-token pulse-monitor@pbs pulse-token
proxmox-backup-manager acl update / Audit --auth-id pulse-monitor@pbs
proxmox-backup-manager acl update / Audit --auth-id 'pulse-monitor@pbs!pulse-token'
```

---

## References

- <https://github.com/rcourtman/Pulse>
- <https://github.com/rcourtman/Pulse/blob/main/docker-compose.yml>
