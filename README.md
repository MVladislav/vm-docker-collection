# Docker Collection

---

- [Docker Collection](#docker-collection)
  - [best practice start-up](#best-practice-start-up)
  - [References](#references)

---

A docker collection with composer for a fast start-up.

- Each service folder has its own **README**.

## best practice start-up

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
run it example as follow:

create alias for a `docker-swarm` command:

```sh
$alias docker='DOCKER_BUILDKIT=1 docker'
$alias docker-compose='docker compose'
$alias docker-swarm-compose='docker compose --compatibility config | sed '\''s|cpus: \([0-9]\+\(\.[0-9]\+\)*\)|cpus: "\1"|'\'' | sed '\''1{/^name:/d}'\'' | sed '\''s/published: "\(.*\)"/published: \1/'\'' | docker stack deploy --resolve-image=never --with-registry-auth --compose-file -'

```

and as run:

```sh
$docker-swarm-compose <STACK_NAME>
```

---

## References

- Not included
  - <https://github.com/crater-invoice/crater>
    - <https://www.youtube.com/watch?v=velKYXN3A_w>
  - <https://hay-kot.github.io/homebox/quick-start/>
  - <https://github.com/mattermost/mattermost>
  - <https://listmonk.app/>
  - <https://github.com/hackmdio/codimd>
  - <https://rustdesk.com/docs/en/self-host/rustdesk-server-oss/docker/>
  - <https://zentyal.com/>

---

**☕ COFFEE is a HUG in a MUG ☕**
