# Contributing

Thanks for your interest in this Docker Compose collection! Contributions in
any form (new stacks, fixes, documentation) are welcome.

## Project structure

```
.
├── __template/          # base templates for new stacks (start here!)
├── composer/
│   └── <category>/
│       └── <name>/
│           ├── docker-compose.yaml
│           ├── README.md
│           ├── .gitignore
│           └── config/ (optional, e.g. secrets, ssl)
└── .github/             # issue/PR templates, Renovate config
```

Every service folder must contain:

- a **`docker-compose.yaml`** (or `docker-compose-*.yaml`)
- a **`README.md`** with a short description and setup instructions
- a **`.gitignore`** that excludes local files (`.env`, `config/secrets/*`)

## Adding a new service

1. Copy the relevant template from [`__template/`](./__template/README.md)
   (e.g. `docker-compose.yaml` for a full stack, `docker-compose-quick.yaml`
   for a minimal one).
2. Adjust the service definition, environment variables, secrets, volumes and
   Traefik labels to your use case.
3. Write the service `README.md` with:
   - a short description and the official project link
   - the required `.env` variables
   - how to create the required secrets
   - any special notes (hardware acceleration, prerequisites, ...)
4. Add the service to the service table in the root
   [`README.md`](./README.md) under the right category.

## Validation

Before submitting, make sure the compose file is valid:

```sh
cd composer/<category>/<name>
docker compose config
```

The stack is expected to work both with plain `docker compose` and with
`docker stack deploy` (Swarm) via the
[`docker-swarm-compose`](./README.md#best-practice-start-up) alias.

## Development workflow

1. Fork the repository and create a feature branch.
2. Make your changes, keeping the formatting consistent:
   - YAML/JSON are formatted with **prettier** (`prettier-plugin-sort-json`)
   - YAML is linted with **yamllint**
   - Dockerfiles are linted with **hadolint**
3. Run the checks:
   ```sh
   pre-commit run --all-files
   ```
   (Install [pre-commit](https://pre-commit.com) first if not already done.)
4. Open a pull request using the provided template and describe your changes.

## Pull request guidelines

- Use the PR template; the "detailed" one is for larger additions, the
  "simple" one for small fixes.
- Reference the issue/feature request if there is one.
- Keep the diff focused on a single stack or topic.
