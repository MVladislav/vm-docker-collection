# Description

Please include a summary of the changes and the related issue. List any
dependencies that are required for this change.

Fixes # (issue)

## Type of change

Please delete options that are not relevant.

- [ ] New service (adds a stack under `composer/<category>/<name>/`)
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (requires changes to existing `.env` files or configs)
- [ ] Documentation update

## How Has This Been Tested?

Please describe how you verified your changes, e.g.:

- `docker compose config` validates the changed stack
- `docker compose up -d` and basic smoke test of the service
- `pre-commit run --all-files` passes

**Test configuration**:

- Deployment mode (Docker Compose / Swarm):
- Host OS:
- Docker version:

## Checklist:

- [ ] Service folder contains a `README.md` and a `.gitignore`
- [ ] Compose file validates with `docker compose config`
- [ ] No secrets or real credentials are committed
- [ ] Root `README.md` table is updated if the service list changed
- [ ] `pre-commit run --all-files` passes locally
- [ ] My changes generate no new warnings
