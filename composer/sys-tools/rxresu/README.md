# SETUP

## basic

> defined to work with traefik

### create your `secrets`:

```sh
openssl rand -hex 18 > config/secrets/postgres_password_file.txt
echo "POSTGRES_PW=$(cat config/secrets/postgres_password_file.txt)" >> .env

openssl rand -hex 8 > config/secrets/rustfs_access_key_file.txt
echo "S3_ACCESS_KEY_ID=$(cat config/secrets/rustfs_access_key_file.txt)" >> .env
openssl rand -hex 32 > config/secrets/rustfs_secret_key_file.txt
echo "S3_SECRET_ACCESS_KEY=$(cat config/secrets/rustfs_secret_key_file.txt)" >> .env

echo "AUTH_SECRET=$(openssl rand -hex 32)" >> .env
echo "ENCRYPTION_SECRET=$(openssl rand -hex 32)" >> .env
```

### create `.env` file following:

```env
# GENERAL variables (mostly by default, change as needed)
# ______________________________________________________________________________
NODE_ROLE=manager
NETWORK_MODE=overlay # overlay | bridge

# GENERAL traefik variables (set by default, change as needed)
# ______________________________________________________________________________
LB_SWARM=true
DOMAIN=resume.home.local # not set in docker-compose, needs to be copied to .env
PROTOCOL=http
PORT=3000
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
VERSION_RESUME=v5.3.1
VERSION_POSTGRESQL=18.6-alpine
VERSION_RUSTFS=1.0.0
VERSION_AWS_CLI=2.37.4
VERSION_VALKEY=9.1.2-alpine

# APPLICATION general variable to adjust the apps
# ______________________________________________________________________________
CERT_RESOLVER=certificates

# set to true after the first account exists
FLAG_DISABLE_SIGNUPS=false
# set to true for a local Ollama or other private AI base url
FLAG_ALLOW_UNSAFE_AI_BASE_URL=false
```

#### example short .env (swarm)

```env
DOMAIN=resume.home.local
```

#### example short .env (bridge)

```env
NETWORK_MODE=bridge
LB_SWARM=false

DOMAIN=resume.home.local
```

---

## References

- <https://rxresu.me/>
- <https://github.com/reactive-resume/reactive-resume>
- <https://docs.rxresu.me/self-hosting/docker>
