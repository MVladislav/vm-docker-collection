# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [conf](#conf)
  - [References](#references)

---

## basic

> defined to work with treafik

### create `.env` file following:

```env
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=12

LB_SWARM=true
DOMAIN=teleport.home.local
PROTOCOL=http
PORT=3080
# default-secured@file | public-whitelist@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file
```

## conf

create a user `groot` for allowed login as `root,groot,ubuntu`:

```sh
# create the new user with specific logins
$docker exec "$(docker ps -q -f name=teleport_teleport)" tctl users add groot --roles=editor,access --logins=root

# update specific user with changed logins
$docker exec "$(docker ps -q -f name=teleport_teleport)" tctl users update groot --set-logins root,ubuntu
```

---

## References

- <https://goteleport.com/>
- <https://goteleport.com/docs/getting-started/docker-compose/>
- <https://gallery.ecr.aws/gravitational/teleport>
- <https://goteleport.com/docs/management/guides/docker/>
- <https://goteleport.com/docs/management/admin/users/>
