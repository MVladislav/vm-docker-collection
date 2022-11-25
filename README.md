# Docker Collection

```sh
  MVladislav
```

---

- [Docker Collection](#docker-collection)
  - [more description](#more-description)
    - [best practice start-up](#best-practice-start-up)
  - [References](#references)

---

A docker collection with composer for a fast start-up.

Each composer-service folder has its own **README**.

## more description

...

### best practice start-up

use docker-swarm to manage and start containers.

for that is in each service following defined:

```yml
services:
  ...:
    ...
    deploy:
      mode: replicated
      replicas: 1
      placement:
        max_replicas_per_node: 1
        constraints:
          # - "node.id==${NODE_ID}"
          - "node.role==${NODE_ROLE}"
      restart_policy:
        condition: on-failure
    ...
    ports:
      - target: ...
        published: ...
        mode: host
```

to start this configuration with all supportings between docker-stack and docker-composer
run it with following commando:

```sh
$DOCKER_BUILDKIT=1 docker-compose config | CONFIG_VERSION=1 docker stack deploy --resolve-image=never --with-registry-auth --compose-file - <STACK_NAME>
```

or create directly an alias for it:

```sh
$alias docker='DOCKER_BUILDKIT=1 docker'
$alias docker-compose='DOCKER_BUILDKIT=1 docker-compose'
$alias docker-swarm-compose='docker-compose config | CONFIG_VERSION=1 docker stack deploy --resolve-image=never --with-registry-auth --compose-file -'
```

and run:

```sh
$docker-swarm-compose <STACK_NAME>
```

---

## References

- <...>

---

**☕ COFFEE is a HUG in a MUG ☕**
