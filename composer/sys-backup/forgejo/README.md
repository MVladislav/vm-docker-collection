# SETUP

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
DOMAIN=forgejo.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=3000
# default-secured@file | public-secured@file | authentik@file
MIDDLEWARE_SECURED=default-secured@file

MIDDLEWARE_SECURED_SSH=default-whitelist
PORT_SSH=22

# GENERAL sources to be used (set by default, change as needed)
# ______________________________________________________________________________
RESOURCES_LIMITS_CPUS=1
RESOURCES_LIMITS_MEMORY=1g
RESOURCES_RESERVATIONS_CPUS=0.001
RESOURCES_RESERVATIONS_MEMORY=32m

# APPLICATION version for easy update
# ______________________________________________________________________________
VERSION=16
VERSION_RUNNER=13.2.0
VERSION_DIND=29.8.1

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates

PORT_SSH_PUBLISH=2222

USER_UID=1000
USER_GID=1000

TIMEZONE=Europe/Berlin

NFS_HOST=<NFS_HOST>
NFS_PATH=<NFS_PATH>
```

#### example short .env (swarm)

```env
DOMAIN=forgejo.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=forgejo.home.local
```

## runner (Forgejo Actions, optional)

### security: two modes

- **automount** (`docker-compose.runner.yaml`, swarm): job containers get the
  host daemon's socket → can inspect/kill/exec every service on the node.
  Only for a node where ALL workflow code is trusted (no untrusted PRs).
- **dind** (`docker-compose.runner-dind.yaml`, `docker compose`, isolated,
  recommended): jobs run in a nested `docker:dind` daemon (`privileged: true`
  → NOT a swarm stack). No host daemon access; use for untrusted workflows.
- Choose ONE mode; both can coexist as separate runners.

### 1. register

`https://$DOMAIN/admin/actions/runners` → Create new runner → copy URL / UUID / token

### 2. render runner config

> holds UUID + token, so renders stay gitignored.

automount mode:

```sh
sed -e 's|<RUNNER_URL>|https://git.example.com|' \
  -e 's|<RUNNER_UUID>|<uuid from Forgejo UI>|' \
  -e 's|<RUNNER_TOKEN>|<token from Forgejo UI>|' \
  config/config.yml.tmpl > config/config.yml
```

dind mode:

```sh
sed -e 's|<RUNNER_URL>|https://git.example.com|' \
  -e 's|<RUNNER_UUID>|<uuid from Forgejo UI>|' \
  -e 's|<RUNNER_TOKEN>|<token from Forgejo UI>|' \
  config/config-dind.yml.tmpl > config/config-dind.yml
```

### 3. deploy

automount (swarm):

```sh
docker-swarm-compose -f docker-compose.yaml -f docker-compose.runner.yaml forgejo
```

dind (plain docker compose):

```sh
docker compose -f docker-compose.runner-dind.yaml up -d
```

Remote daemon (`docker context` → VM): plain-compose `configs.file` is a
**daemon-side bind mount** (swarm uploads file content, compose does NOT) →
the file must exist ON the VM. Push it once, make it world-readable (runner
is root with `cap_drop: ["ALL"]` → no `DAC_OVERRIDE`), and point
`CONFIG_DIND_SOURCE` at the **absolute** remote path (`~` in `.env` expands
to YOUR home, not the VM's):

```sh
scp config/config-dind.yml user@vm:~/config-dind.yml
ssh user@vm chmod 644 ~/config-dind.yml

echo 'CONFIG_DIND_SOURCE=~/config-dind.yml' >> .env
docker compose -f docker-compose.runner-dind.yaml up -d
```

> No remote context: leave `CONFIG_DIND_SOURCE` unset, the compose default
> `$PWD/config/config-dind.yml` is used.

### notes

- runner runs as root (`user: "0:0"`): automount to read the `.sock` (mounted
  `ro`), dind to write the root-owned `/data` volume
- automount: jobs get the HOST daemon → can reach every node service + the
  registry; runner itself is on the `proxy` network (public-URL egress) but not
  publicly reachable
- dind: `/config.yml` keeps the HOST file's perms - `mode:`/`uid:`/`gid:` in
  the compose are swarm-only and ignored; root without `DAC_OVERRIDE` needs the
  file world-readable (`0644`), else `open /config.yml: permission denied`
- cache: `cache.enabled` serves `ACTIONS_CACHE_URL`; stored in `/data/.cache`
  on the `runner-data` volume. Set `cache.host`/`cache.port` if jobs can't
  reach the auto-detected host
- labels: `ubuntu-latest:docker://node:24-bookworm` (job pulls that image);
  tune `capacity`/`force_pull`/labels in the rendered config
- verify runner tags before bumping `VERSION_RUNNER`:
  `curl -s https://data.forgejo.org/v2/forgejo/runner/tags/list` (latest `13.2.0`, no `14`)

## Guides & Insights

- SSH ports: `PORT_SSH` = in-container sshd port (`FORGEJO__server__SSH_LISTEN_PORT`,
  `ports.target:`), `PORT_SSH_PUBLISH` = advertised + published port
  (`FORGEJO__server__SSH_PORT`, `ports.published:`). Keep clone URLs = publish port.
- If self hosted cert use `GIT_SSL_NO_VERIFY=true git ...`.
- SSH is published directly (`ports: mode host`). Alternative: route SSH over
  Traefik TCP instead (needs an `ssh` entrypoint + `MIDDLEWARE_SECURED_SSH`), replace the `ports:` block with commented label.
- Forgejo defines every setting via `FORGEJO__[SECTION]__[KEY]` env overrides
  (see cheat sheet). Points of interest if needed: `[indexer] MAX_FILE_SIZE`,
  `[git] MAX_GIT_DIFF_*`, `[quota] ENABLED`. Actions default actions url:
  `FORGEJO__actions__DEFAULT_ACTIONS_URL`.

---

## References

- <https://codeberg.org/forgejo/forgejo>
- <https://forgejo.org/docs/latest/admin/installation/docker/#docker>
- <https://forgejo.org/docs/latest/admin/config-cheat-sheet/#server-server>
- <https://forgejo.org/docs/latest/admin/actions/>
- <https://forgejo.org/docs/latest/admin/actions/installation/docker/>
- <https://forgejo.org/docs/latest/admin/actions/configuration/>
- <https://forgejo.org/docs/latest/admin/actions/docker-access/>
- <https://forgejo.org/docs/latest/admin/actions/security/>
- <https://code.forgejo.org/forgejo/runner/src/branch/main/internal/pkg/config/config.example.yaml>
