#!/usr/bin/env bash
#
# Odoo community database migration via OCA OpenUpgrade.
#
#   https://hbrunn.github.io/OpenUpgrade/  (bash port of run-migration.py)
#
# Requires bash >= 4.4. Associative arrays need 4.0, but this script also runs
# under `set -u` and expands several arrays that are legitimately empty (the
# optional `--load openupgrade_framework`, the OCA repo list, the PR list). Bash
# < 4.4 treats expanding an empty array under `set -u` as an "unbound variable"
# error, which would abort a migration part-way with no useful message. Checked
# here so that case fails immediately and legibly instead.
if [[ -z "${BASH_VERSINFO[*]:-}" ]] || ((BASH_VERSINFO[0] < 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] < 4))); then
  echo "ERROR: bash >= 4.4 required, found ${BASH_VERSION:-unknown}." >&2
  exit 1
fi
# Run it from this directory. Drop an Odoo database-manager backup in ZIP format
# next to this script, then pick the source/target versions and the postgres
# major you are running.
#
# Reads  : <this dir>/*.zip
# Writes : source/ docker/ logs/  (all gitignored scratch dirs)
set -euo pipefail
trap 'echo "ERROR: Unexpected error on line $LINENO (command: $BASH_COMMAND)." >&2; exit 1' ERR

# --- Global Variables ---------------------------------------------------------
# Only versions whose OpenUpgrade branch actually carries migration scripts may
# be listed here. A version that is not listed is refused rather than attempted:
# OpenUpgrade publishes the branch skeleton for the next major as soon as the
# branch is created, so "the branch exists" is NOT a signal that a migration is
# possible. oca/openupgrade@20.0 currently has a single commit and no
# openupgrade_scripts at all, so 19.0 -> 20.0 is not migratable yet.
ODOO_VERSIONS=("14.0" "15.0" "16.0" "17.0" "18.0" "19.0")
# Left unset on purpose: main() always prompts with fzf. Assigning a default
# here would make the selection look like an override and the prompt would
# never be reached.

# Experimental versions pull every open OCA PR targeted at them, which is only
# useful when you are helping to write the migration scripts. A released major
# belongs in ODOO_VERSIONS with its plain branch.
ODOO_VERSIONS_EXPERIMENTAL=()
ODOO_ALLOW_EXPERIMENTAL=""

# Unmerged OCA pull requests to merge on top of the plain OpenUpgrade branch.
# This is the equivalent of upstream run-migration.py's --prs, and it is the
# escape hatch for a migration script that has been written but not yet merged:
# stock_account and account were still collecting 19.0 fixes in October 2026
# (PRs #5890, #5910, #5951, #5954), and a database can hit a breakage the plain
# branch does not carry yet.
# A plain string of PR numbers, separated by spaces or commas, NOT a bash array.
# Edit this line to keep a value permanently. Empty = plain branches, which is
# the default and what a production migration should use unless a script is
# genuinely missing. Only refs/pull/*/head of oca/openupgrade are fetched, so
# the Odoo (ocb) source always comes from its plain branch.
ODOO_PRS=""

# The `anonymize` command (or the `--anonymize` flag) makes export_backup scrub
# the sandbox before dumping (see config/anonymize.sql): the mail infrastructure
# (ir.mail_server, fetchmail.server, the mail_mail queue, mail gateway/push,
# SMTP system parameters) is deleted, e-mail addresses are rewritten to
# deterministic id@sandbox.local values, personal names are rewritten, phone /
# address / bank / tax identifiers are nulled, every 2FA secret, trusted device
# and API key is removed, and all user passwords are reset to the test value
# "test". One known administrator is exposed as login "admin". The exported .zip
# can then be uploaded to a test instance without any chance it sends real mail
# or keeps a real credential.
ANONYMIZE=false

ODOO_DB_CURRENT_VERSION=""
ODOO_DB_CURRENT_NAME=""
ODOO_MIGRATION_VERSION_TO_RUN=()

# Postgres majors a dump taken from that major can be restored into. The value
# has to match the major of your production database: pg_dump from a newer
# server cannot be read by an older one, and OpenUpgrade is only tested on the
# majors its CI runs.
ODOO_DB_VERSIONS=("13" "14" "15" "16" "17" "18")
ODOO_DB_USERNAME='odoo'
ODOO_DB_PASSWORD='odoo' # pragma: allowlist secret

# Extra git-aggregate blocks, appended after the detected OCA ones:
#   "mycompany https://github.com/mycompany/custom-addons"  private addons
#   "l10n_custom"                                          OCA repo the DB can't identify
# OCA repositories ARE detected from ir_module_module.website, but private
# custom addons are invisible there and have to be listed by hand or their
# upgrade path is silently missing.
ODOO_EXTRA_REPOS=()

# Everything else (target version, source Postgres major, backup file) is asked
# with fzf during the run. Nothing can be pre-set from the environment; see the
# entry point for the only optional shortcuts (a backup file as an argument and
# the `anonymize` / `cleanup` commands).

OCA_REPOS_DETECTED=()

PATH_SOURCE="source"
PATH_DOCKER="docker"
PATH_LOGS="logs"
PATH_PATCHES="patches"

ODOO_GITHUB_API="https://api.github.com/repos/oca/openupgrade/pulls?state=open"
USER_AGENT="oca/openupgrade run-migration.sh"

# --- Main ---------------------------------------------------------------------
main() {
  check_dependencies

  ODOO_VERSION_SELECTED=$(printf "%s\n" "${ODOO_VERSIONS[@]}" | sort -rh | fzf --height=~40% --prompt="Select Odoo version, you want migrate to: ")
  # An unknown value would silently generate a compose file for a version this
  # helper knows nothing about (wrong OpenUpgrade branch, no Dockerfile entry),
  # so reject it here rather than half-way through the migration.
  if ! printf '%s\n' ${ODOO_VERSIONS[@]+"${ODOO_VERSIONS[@]}"} ${ODOO_VERSIONS_EXPERIMENTAL[@]+"${ODOO_VERSIONS_EXPERIMENTAL[@]}"} | grep -qx "$ODOO_VERSION_SELECTED"; then
    print_error "Unknown Odoo version '$ODOO_VERSION_SELECTED'. Supported: ${ODOO_VERSIONS[*]}"
  fi
  if printf '%s\n' "${ODOO_VERSIONS_EXPERIMENTAL[@]}" | grep -qx "$ODOO_VERSION_SELECTED"; then
    ODOO_ALLOW_EXPERIMENTAL=$(echo -e "no\nyes" | fzf --height=~40% --prompt="Do you attempt to run migration for current experimental version (${ODOO_VERSIONS_EXPERIMENTAL[*]}): ")
  fi

  if [[ "${ODOO_ALLOW_EXPERIMENTAL:-}" == "no" ]] && printf '%s\n' "${ODOO_VERSIONS_EXPERIMENTAL[@]}" | grep -qx "$ODOO_VERSION_SELECTED"; then
    print_error "Version '$ODOO_VERSION_SELECTED' is experimental, migration will be stopped!"
  fi

  ODOO_DB_VERSION=$(printf "%s\n" "${ODOO_DB_VERSIONS[@]}" | sort -rh | fzf --height=~40% --prompt="Select Postgres version you are running: ")
  # accepts both "18" and the image tag "18-alpine"
  if ! printf '%s\n' "${ODOO_DB_VERSIONS[@]}" | grep -qE "^${ODOO_DB_VERSION%%-*}"; then
    print_error "Unknown Postgres version '$ODOO_DB_VERSION'. Supported: ${ODOO_DB_VERSIONS[*]}"
  fi
  echo

  if [[ -n "${ODOO_VERSIONS_EXPERIMENTAL[*]}" ]] && printf '%s\n' "${ODOO_VERSIONS_EXPERIMENTAL[@]}" | grep -qx "$ODOO_VERSION_SELECTED"; then
    echo "############################################################################################################################"
    echo "You chose to run the experimental migration."
    echo "Be warned that this will not give you a production ready database, is meant to help with the development of upgrade scripts,"
    echo "will most likely fail and is only helpful if you can interpret the resulting logs and contribute meaningful bug reports."
    echo "############################################################################################################################"
    echo
  fi

  select_and_extract_backup
  echo
  check_to_run_versions
  echo

  main_migration

  print_success
}

print_success() {
  local version="$ODOO_VERSION_SELECTED"
  local archive="$ODOO_DB_CURRENT_NAME-migrated-$version.zip"

  echo
  echo "############################################################"
  echo "# Migration successful: Odoo $ODOO_DB_CURRENT_VERSION -> $version"
  echo "############################################################"
  echo
  echo "Created:"
  echo "  $PWD/$archive"
  echo "  $PWD/$PATH_LOGS/                  migration logs"
  echo
  echo "Next:"
  echo "  1. Deploy this stack as $version (VERSION_ODOO=$version in .env)."
  echo "  2. Restore $archive in the target stack via"
  echo "     https://<DOMAIN>/web/database/manager"
  echo "     master password = config/secrets/admin_passwd.txt"
  echo "  3. IMPORTANT: the Name field must NOT be an existing database."
  echo "     Odoo refuses a restore onto a name that is already taken"
  echo "     (\"Database already exists\"), so give it a fresh name or"
  echo "     drop the old one first. Nothing else is needed - there is"
  echo "     no reason to delete the postgres volume."
  echo "  4. Log in as the unique administrator: login \"admin\"."
  if [[ "${ANONYMIZE:-false}" == "true" ]]; then
    echo "     This export was anonymized, so its password is \"test\""
    echo "     and 2FA is removed (every other user was reset to the"
    echo "     same test password too)."
  else
    echo "     A restore keeps the source credentials, it does not"
    echo "     reset them, so the password is the SOURCE admin one."
  fi
  echo "  5. Verify: no module left \"to upgrade\", a document renders"
  echo "     together with its attachment, and Settings > Technical >"
  echo "     Database reports $version."
  echo "  6. Only then point production over, then close"
  echo "     /web/database/manager again. Keep dbfilter unset until"
  echo "     the restore is done, or the database stays invisible."
  echo
  echo "Two ZIPs now sit next to each other:"
  echo "  ${ODOO_BACKUP_SOURCE:-<your backup>.zip}"
  echo "      the $ODOO_DB_CURRENT_VERSION backup you fed in (keep it)"
  echo "  $archive"
  echo "      the migrated result - this is the one you deploy"
  echo
  cleanup_menu
}

human_size() {
  local bytes
  bytes=$(du -sb "$1" 2>/dev/null | cut -f1)
  [[ -z "$bytes" ]] && bytes=0
  numfmt --to=iec --suffix=B "$bytes" 2>/dev/null || echo "${bytes}B"
}

image_size() {
  local bytes
  bytes=$(docker image inspect --format '{{.Size}}' "$1" 2>/dev/null)
  if [[ -z "$bytes" ]]; then
    echo "-"
    return 0
  fi
  numfmt --to=iec --suffix=B "$bytes" 2>/dev/null || echo "${bytes}B"
}

# The build needs roughly 14 GB of free disk (image layers + the source it
# compiles). Docker only reports "no space left on device" after the fact, and
# then only as a truncated pip traceback inside BuildKit output, so check the
# one number we can actually read before starting a ~40 minute build.
check_disk_space() {
  local version="$1"
  local required_kb=$((14 * 1024 * 1024))
  local avail_kb cache_size="" cache_bytes=0

  # warm image: nothing is written, nothing to check
  if docker image inspect "openupgrade-$version" >/dev/null 2>&1; then
    echo "Image openupgrade-$version already present - skipping the disk check."
    return 0
  fi

  # warm build cache: the compiled layers are already on disk and the image
  # mostly references them, so the build writes far less than a cold one
  cache_size=$(docker system df --format '{{.Type}}|{{.Size}}' 2>/dev/null |
    awk -F'|' '$1 == "Build Cache" {print $2}')
  if [[ -n "$cache_size" ]]; then
    # numfmt --from=iec rejects the "B" suffix docker prints
    cache_bytes=$(numfmt --from=iec "${cache_size%B}" 2>/dev/null || echo 0)
    if ((cache_bytes > 1024 * 1024 * 1024)); then
      required_kb=$((9 * 1024 * 1024))
      echo "Build cache of $cache_size is present, so the compiled layers are reused: ~9G needed instead of ~14G."
    fi
  fi

  avail_kb=$(df -Pk . | awk 'NR==2 {print $4}')
  if [[ -z "$avail_kb" ]]; then
    return 0
  fi
  echo "Free disk: $(numfmt --to=iec --suffix=B $((avail_kb * 1024)) 2>/dev/null || echo "${avail_kb}K") (build needs ~$(numfmt --to=iec --suffix=B $((required_kb * 1024)) 2>/dev/null || echo "${required_kb}K"))"
  if ((avail_kb < required_kb)); then
    print_error "Not enough free disk for the $version build: $(numfmt --to=iec --suffix=B $((avail_kb * 1024)) 2>/dev/null || echo "${avail_kb}K") free, ~$(numfmt --to=iec --suffix=B $((required_kb * 1024)) 2>/dev/null || echo "${required_kb}K") needed. Free space first (./migration.sh cleanup)."
  fi
}

# Picks what to reclaim after a run. Every target is disposable on its own;
# the point of asking is that removing the image or the build cache is what
# turns the next run into a ~40 minute rebuild.
cleanup_menu() {
  local version="${ODOO_VERSION_SELECTED:-19.0}"
  local selection=""
  local -a keys=()

  if [[ ! -t 0 ]] || [[ -z "$(command -v fzf)" ]]; then
    # non-interactive: never delete anything behind the user's back
    echo "Non-interactive run, skipping the cleanup prompt."
    echo "Reclaim the space later with: ./migration.sh cleanup"
    echo
    return 0
  fi

  local choices=()
  choices+=("containers"$'\t'"helper containers + their volumes"$'\t'"~0"$'\t'"always safe, next run recreates them in seconds")
  choices+=("logs"$'\t'"$PATH_LOGS/ migration logs"$'\t'"$(human_size "$PATH_LOGS")"$'\t'"keep while you are still verifying the run")
  choices+=("source"$'\t'"$PATH_SOURCE/ extracted backup + scratch"$'\t'"$(human_size "$PATH_SOURCE")"$'\t'"only saves the unzip on a rerun")
  choices+=("docker"$'\t'"$PATH_DOCKER/ generated compose, sources, clones"$'\t'"$(human_size "$PATH_DOCKER")"$'\t'"next run re-clones the OpenUpgrade repos (~2 GB)")
  choices+=("cache"$'\t'"docker build cache (ALL projects)"$'\t'"$(docker system df --format '{{.Size}}' 2>/dev/null | tail -1)"$'\t'"next build recompiles Odoo from scratch (~40 min)")
  choices+=("image"$'\t'"helper image openupgrade-$version"$'\t'"$(image_size "openupgrade-$version")"$'\t'"next run rebuilds the image from scratch")

  echo "What should be cleaned up? (tab to select, enter to confirm)"
  echo "The ZIP files are never touched - the -migrated- one is your result."
  echo
  selection=$(printf '%s\n' "${choices[@]}" |
    fzf --multi --height=~45% --delimiter=$'\t' --with-nth=2.. \
      --prompt="cleanup> " \
      --header="Keep image+cache if you want a fast rerun - only logs/source are cheap." \
      --bind 'ctrl-a:toggle-all' || true)
  [[ -n "$selection" ]] && mapfile -t keys < <(printf '%s\n' "$selection" | cut -f1)

  if [[ ${#keys[@]} -eq 0 ]]; then
    echo "Nothing selected, keeping everything."
    echo
    return 0
  fi

  # a typo in the cleanup selection would be silently ignored, i.e. cleaning
  # frees nothing and the next build dies disk-full 40 minutes in
  local known=" containers logs source docker cache image " k
  for k in "${keys[@]}"; do
    [[ -z "$k" ]] && continue
    if [[ "$known" != *" $k "* ]]; then
      print_warning "unknown cleanup target '$k' (known: containers, logs, source, docker, cache, image)"
    fi
  done

  if printf '%s\n' "${keys[@]}" | grep -qx "cache"; then
    print_warning "docker builder prune removes the build cache of EVERY project on this host, not just this migration."
  fi

  echo
  echo "Cleaning up..."
  if printf '%s\n' "${keys[@]}" | grep -qx "containers"; then
    COMPOSE_PROJECT_NAME=openupgrade docker compose -f "$PATH_DOCKER/docker-compose.yml" \
      down -v --remove-orphans >/dev/null 2>&1 || true
    echo "  - helper containers and volumes"
  fi
  if printf '%s\n' "${keys[@]}" | grep -qx "logs"; then
    rm -rf "${PATH_LOGS:?}"
    echo "  - $PATH_LOGS/"
  fi
  if printf '%s\n' "${keys[@]}" | grep -qx "source"; then
    rm -rf "${PATH_SOURCE:?}"
    echo "  - $PATH_SOURCE/"
  fi
  if printf '%s\n' "${keys[@]}" | grep -qx "docker"; then
    # the generated compose file lives in there and the helper containers read
    # from it, so stop them first rather than leaving dangling containers
    COMPOSE_PROJECT_NAME=openupgrade docker compose -f "$PATH_DOCKER/docker-compose.yml" \
      down --remove-orphans >/dev/null 2>&1 || true
    rm -rf "${PATH_DOCKER:?}"
    echo "  - $PATH_DOCKER/ (next run re-clones the OpenUpgrade repos)"
  fi
  if printf '%s\n' "${keys[@]}" | grep -qx "cache"; then
    docker builder prune -f >/dev/null 2>&1 || true
    echo "  - docker build cache (all projects)"
  fi
  if printf '%s\n' "${keys[@]}" | grep -qx "image"; then
    # an image cannot be removed while a container still uses it, so the
    # containers go first unless they were selected already
    if ! printf '%s\n' "${keys[@]}" | grep -qx "containers"; then
      COMPOSE_PROJECT_NAME=openupgrade docker compose -f "$PATH_DOCKER/docker-compose.yml" \
        down --remove-orphans >/dev/null 2>&1 || true
    fi
    local img found=0
    while IFS= read -r img; do
      [[ -z "$img" ]] && continue
      found=1
      if docker image rm "$img" >/dev/null 2>&1; then
        echo "  - $img image (next run rebuilds it)"
      else
        print_warning "could not remove image $img - still in use?"
      fi
    done < <(docker images --format '{{.Repository}}' 2>/dev/null | grep '^openupgrade-' | sort -u)
    if ((found == 0)); then
      echo "  - no openupgrade-* image present, nothing to remove"
    fi
  fi

  df -h . | awk 'NR==2 {printf "\nDisk now: %s used, %s free\n", $3, $4}'
  local archive="$ODOO_DB_CURRENT_NAME-migrated-$version.zip"
  if [[ -f "$archive" ]]; then
    echo "Your result is untouched: $PWD/$archive"
  fi
  echo
}

main_migration() {
  local version docker_compose
  mkdir -p "$PATH_LOGS"
  mkdir -p "$PATH_DOCKER"
  # logs are appended, so a rerun does not erase what the previous run said
  echo "Logs are appended to $PWD/$PATH_LOGS/"

  docker_compose=$(generate_odoo_compose)
  for version in "${ODOO_MIGRATION_VERSION_TO_RUN[@]}"; do
    docker_compose+=$'\n'$(generate_odoo_service "$version")
  done
  echo "$docker_compose" > "$PATH_DOCKER/docker-compose.yml"

  # order matters: the OCA repository list is read out of the restored database
  # and has to land in each helper's repos.yml before its image is built
  restore_db
  detect_oca_repos

  for version in "${ODOO_MIGRATION_VERSION_TO_RUN[@]}"; do
    create_helper_docker "$version"
    # Upstream only applies PRs on the experimental path. That makes the
    # mechanism unreachable once a major is released, which is exactly when a
    # user needs it: an unmerged-but-landed-on-your-DB fix. ODOO_PRS therefore
    # gates on its own, and the experimental path keeps the milestone sweep.
    if [[ -n "${ODOO_PRS//[[:space:],]/}" ]]; then
      apply_prs_from_github "$version"
    elif [[ "${ODOO_ALLOW_EXPERIMENTAL:-}" == "yes" ]] && printf '%s\n' "${ODOO_VERSIONS_EXPERIMENTAL[@]}" | grep -qx "$version"; then
      apply_prs_from_github "$version"
    fi
    build_containers "$version"

    run_migration "$version"
    export_backup "$version"
  done

  docker_compose down --volumes --remove-orphans --logfile False
}

# --- Helper Odoo --------------------------------------------------------------

select_and_extract_backup() {
  local backup_file="${BACKUP_FILE:-}"
  if [[ -z "$backup_file" ]]; then
    backup_file=$(find . -maxdepth 1 -type f -name "*.zip" | fzf --prompt="Select backup file: ")
  fi
  [[ -z "$backup_file" ]] && print_error "No backup file selected. Exiting."
  extract_backup "$backup_file"
}

extract_backup() {
  local backup_file="$1"

  if ! unzip -t "$backup_file" >/dev/null 2>&1; then
    print_error "$backup_file does not seem to be a valid ZIP backup made with the Odoo database manager! Note: You need to choose format 'zip'."
  fi

  # remember the file so the closing instructions can name it next to the result
  ODOO_BACKUP_SOURCE="$(cd "$(dirname "$backup_file")" && pwd)/$(basename "$backup_file")"

  mkdir -p "$PATH_SOURCE"
  echo "Extracting backup..."
  unzip -q -o "$backup_file" -d "$PATH_SOURCE"

  if [[ ! -f "$PATH_SOURCE/manifest.json" ]]; then
    print_error "manifest.json not found in the backup."
  fi
  if [[ ! -f "$PATH_SOURCE/dump.sql" ]]; then
    print_error "dump.sql not found in the backup."
  fi

  ODOO_DB_CURRENT_NAME=$(jq -r '.db_name' "$PATH_SOURCE/manifest.json")
  ODOO_DB_CURRENT_VERSION=$(jq -r 'if .major_version then .major_version else .version end' "$PATH_SOURCE/manifest.json")

  local file_store_link="$PATH_SOURCE/$ODOO_DB_CURRENT_NAME"
  [[ -L "$file_store_link" ]] && rm "$file_store_link"
  ln -s filestore "$file_store_link"
}

check_to_run_versions() {
  local source_index=-1 target_index=-1

  if ! printf '%s\n' "${ODOO_VERSIONS[@]}" | grep -qx "$ODOO_DB_CURRENT_VERSION"; then
    print_error "Version '$ODOO_DB_CURRENT_VERSION' is not supported (supported: ${ODOO_VERSIONS[*]})"
  fi

  for i in "${!ODOO_VERSIONS[@]}"; do
    if [[ "${ODOO_VERSIONS[$i]}" == "$ODOO_DB_CURRENT_VERSION" ]]; then
      source_index=$i
    fi
    if [[ "${ODOO_VERSIONS[$i]}" == "$ODOO_VERSION_SELECTED" ]]; then
      target_index=$i
    fi
  done

  if [[ $source_index -eq -1 || $target_index -eq -1 ]]; then
    print_error "Could not find source or target version in supported versions."
  fi
  if [[ $source_index -ge $target_index ]]; then
    print_error "Cannot migrate your database any further than $ODOO_DB_CURRENT_VERSION."
  fi

  for ((i=source_index+1; i<=target_index; i++)); do
    ODOO_MIGRATION_VERSION_TO_RUN+=("${ODOO_VERSIONS[$i]}")
  done

  echo "Will download and run migrations for version(s): ${ODOO_MIGRATION_VERSION_TO_RUN[*]}"
}

create_helper_docker(){
  local version="$1"
  mkdir -p "$PATH_DOCKER/$version/src"

  echo 'src/*/*' > "$PATH_DOCKER/$version/.dockerignore"

  # The image patches openupgradelib during the build, so the patch directory
  # has to sit inside the build context (docker/$version/).
  rm -rf "${PATH_DOCKER:?}/$version/${PATH_PATCHES:?}"
  mkdir -p "$PATH_DOCKER/$version/$PATH_PATCHES"
  cp "$PATH_PATCHES"/*.py "$PATH_DOCKER/$version/$PATH_PATCHES/"

  if [[ -v ODOO_VT_DOCKERFILE["$version"] ]]; then
    local packages
    IFS=' ' read -ra packages <<< "${ODOO_VT_DOCKERFILE[$version]}"
    generate_dockerfile "${packages[0]}" > "$PATH_DOCKER/$version/Dockerfile"
  else
    print_error "No python base image mapped for $version (ODOO_VT_DOCKERFILE)."
  fi

  if [[ -v ODOO_VT_REQUIREMENTS["$version"] ]]; then
    echo "${ODOO_VT_REQUIREMENTS[$version]}" > "$PATH_DOCKER/$version/src/requirements.txt"
  else
    echo "" > "$PATH_DOCKER/$version/src/requirements.txt"
  fi

  if [[ -v ODOO_VT_CONSTRAINTS["$version"] ]]; then
    echo "${ODOO_VT_CONSTRAINTS[$version]}" > "$PATH_DOCKER/$version/src/pip.constraint"
  else
    echo "" > "$PATH_DOCKER/$version/src/pip.constraint"
  fi

  # This is the file the image build actually consumes. It used to be written
  # empty, which made the Dockerfile's `for yml_file in *.yml` loop a no-op and
  # left the helper container without odoo or openupgrade sources at all.
  generate_odoo_gitaggregate "$version" > "$PATH_DOCKER/$version/src/repos.yml"
}

apply_prs_from_github() {
  local version="$1"
  local response git_aggregate
  local prs=()

  # Explicit ODOO_PRS win over the milestone sweep, mirroring upstream
  # run-migration.py where --prs takes precedence over auto-detection. This is
  # the reachable path for a released version: the auto-sweep below is keyed on
  # the milestone, which for 19.0 also collects fixes you did not ask for.
  if [[ -n "${ODOO_PRS//[[:space:],]/}" ]]; then
    read -r -a prs <<<"${ODOO_PRS//,/ }"
    for pr in "${prs[@]}"; do
      if [[ ! "$pr" =~ ^[0-9]+$ ]]; then
        print_error "ODOO_PRS must be bare PR numbers, got '$pr'"
      fi
    done
    echo "Using PR(s) from ODOO_PRS: ${prs[*]}"
  else
    response=$(curl -s -H "Accept: application/vnd.github.v3+json" -H "User-Agent: $USER_AGENT" "$ODOO_GITHUB_API")
    mapfile -t prs < <(echo "$response" | jq -r --arg ver "$version" '.[] | select(.milestone?.title == $ver) | .number')

    if [[ ${#prs[@]} -eq 0 ]]; then
      echo "WARN: no prs given and none found" >&2
    fi
  fi

  git_aggregate=$(generate_odoo_gitaggregate "$version")
  git_aggregate=${git_aggregate//$'openupgrade:\n  defaults:\n    depth: 1'/openupgrade:}
  for pr in "${prs[@]}"; do
    git_aggregate+=$'\n    - oca refs/pull/'$pr'/head'
  done
  echo "$git_aggregate" > "$PATH_DOCKER/$version/src/repos.yml"
}

# --- Helper Odoo Docker -------------------------------------------------------

restore_db() {
  local source_dir="$PWD/$PATH_SOURCE"

  echo "Starting db container..."
  docker_compose up db "" --dockercommand-arg -d --logname "docker-db-up"

  echo "Waiting for PostgreSQL to be ready..."
  until docker_compose_run db pg_isready -h db -U "$ODOO_DB_USERNAME" --logfile False; do
    sleep 1
  done

  echo "Restoring database $ODOO_DB_CURRENT_NAME..."
  # Drop DB
  docker_compose_run db dropdb \
    --if-exists -h db -U "$ODOO_DB_USERNAME" "$ODOO_DB_CURRENT_NAME"
  # Create DB
  docker_compose_run db createdb \
    -h db -U "$ODOO_DB_USERNAME" "$ODOO_DB_CURRENT_NAME"

  echo "Restoring from $source_dir..."
  docker_compose_run db psql \
    --logname "db-restore" \
    --dockercommand-args -v "$source_dir:/tmp" \
    --dockercommand-arg -T \
    -h db -U "$ODOO_DB_USERNAME" --file /tmp/dump.sql "$ODOO_DB_CURRENT_NAME"

  echo "Database $ODOO_DB_CURRENT_NAME restored successfully."
}

detect_oca_repos() {
  local url process

  echo "Estimate used OCA repositories from installed modules..."
  process=$(docker_compose_run db psql \
    --logfile False \
    -h db -U "$ODOO_DB_USERNAME" -d "$ODOO_DB_CURRENT_NAME" \
    --tuples-only --no-align \
    -c "select website from ir_module_module where state='installed'")

  declare -a oca_repos=()
  while IFS= read -r url; do
    [[ -z "$url" ]] && continue
    if [[ "$url" =~ ^https://github\.com/oca/([^/]+) ]]; then
      oca_repos+=("${BASH_REMATCH[1]}")
    fi
  done <<< "$process"

  OCA_REPOS_DETECTED=()
  local repo
  for repo in $(printf "%s\n" "${oca_repos[@]}" | sort -u); do
    OCA_REPOS_DETECTED+=("$repo")
  done

  if [[ ${#OCA_REPOS_DETECTED[@]} -gt 0 ]]; then
    echo "Detected OCA repositories: ${OCA_REPOS_DETECTED[*]}"
  else
    echo "No OCA repositories detected. Private addons have to be added to ODOO_EXTRA_REPOS in migration.sh."
  fi
}

build_containers() {
  local version="$1"
  local logfile="$PWD/$PATH_LOGS/docker-$version-build.log"

  # Check before starting, not after 40 minutes. The image already present does
  # not need the layers rebuilt, so a warm image is only a warning.
  check_disk_space "$version"

  echo "Downloading & installing $version..."
  echo "  Compiles Odoo from source (~40 min cold). Progress streams below."

  # Streamed output is what tells a stuck build apart from a running one; the
  # logfile keeps the full detail including everything scrolled away.
  if ! docker_compose build "$version" "" --stream --logname "docker-$version-build"; then
    print_error "Build of $version failed. Last lines of $logfile:"$'\n'"$(tail -n 15 "$logfile")"
  fi

  docker_compose up "$version" "" --dockercommand-arg -d --logfile False \
    || print_error "Could not start helper container $version."
}

run_migration() {
  local version="$1"
  echo "Running migration for $version..."

  # --- Run pre-migration SQL ---
  run_extra_sql "$version" "pre"

  # --- Find module manifests ---
  local module_manifests
  module_manifests=$(docker_compose_exec "$version" find \
    --logfile False \
    /odoo -maxdepth 3 -mindepth 3 \( -name __manifest__.py -o -name __openerp__.py \) -type f 2>/dev/null | tr '\n' ' ')

  # --- Build extra paths ---
  local extra_paths=()
  if [[ -n "$module_manifests" ]]; then
    local manifest
    for manifest in $module_manifests; do
      extra_paths+=("$(dirname "$(dirname "$manifest")")")
    done
  fi
  # Remove duplicates
  local unique_extra_paths addons_path
  unique_extra_paths=$(printf "%s\n" ${extra_paths[@]+"${extra_paths[@]}"} | sort -u | tr '\n' ',' | sed 's/,$//')
  # Build addons_path; git-aggregate clones one repo per block into /odoo/<block>,
  # so every /odoo/<block> holding a module is an addon directory
  addons_path="/odoo/odoo/odoo/addons,/odoo/odoo/addons"
  [[ -n "$unique_extra_paths" ]] && addons_path+=",$unique_extra_paths"

  # --- Check for openupgrade_framework ---
  local server_wide_modules=()
  if docker_compose_exec "$version" ls --logfile False /odoo/openupgrade/openupgrade_framework >/dev/null 2>&1; then
    server_wide_modules=(--load openupgrade_framework)
  fi

  # --- Run Odoo migration ---
  # streamed: this is the step that takes minutes and otherwise stops talking
  local migration_log="$PWD/$PATH_LOGS/$version-migration.log"
  if ! docker_compose_exec "$version" odoo/odoo-bin \
    "${server_wide_modules[@]}" \
    --stream \
    --logname "$version-migration" \
    --addons-path "$addons_path" \
    --db_host db --db_user "$ODOO_DB_USERNAME" --db_password "$ODOO_DB_PASSWORD" \
    --max-cron-threads 0 -d "$ODOO_DB_CURRENT_NAME" -u all --stop-after-init; then
    print_error "Migration for $version failed. Last lines of $migration_log:"$'\n'"$(tail -n 15 "$migration_log" 2>/dev/null)"
  fi

  # --- Run post-migration SQL ---
  run_extra_sql "$version" "post"
}

run_extra_sql() {
  local version="$1"
  local stage="$2"
  local sql_dir="$PWD/$PATH_DOCKER/$version"
  local sql_file

  while IFS= read -r -d '' sql_file; do
    local filename
    filename=$(basename "$sql_file")
    echo "Running $version $stage migration SQL file: $filename"
    docker_compose_run db psql \
      --logname "$version-migration-$filename" \
      --dockercommand-args -v "$sql_dir:/tmp" \
      -h db -U "$ODOO_DB_USERNAME" --file "/tmp/$filename" "$ODOO_DB_CURRENT_NAME"
  done < <(find "$sql_dir" -maxdepth 1 -type f -name "${stage}*.sql" -print0 2>/dev/null)
}

run_anonymize_sql() {
  local sql_file="$PWD/config/anonymize.sql"

  [[ -f "$sql_file" ]] || print_error "config/anonymize.sql not found (the anonymize command needs it)"
  echo "Anonymizing database $ODOO_DB_CURRENT_NAME..."
  docker_compose_run db psql \
    --logname "anonymize" \
    --dockercommand-args -v "$PWD/config:/tmp" \
    -h db -U "$ODOO_DB_USERNAME" --file /tmp/anonymize.sql "$ODOO_DB_CURRENT_NAME"
}

export_backup() {
  local version="$1"
  local backup_filename="$ODOO_DB_CURRENT_NAME-migrated-$version.zip"

  [[ "${ANONYMIZE:-false}" == "true" ]] && run_anonymize_sql
  local export_script

  # Create the Python script for dumping the database
  export_script=$(cat <<EOF
from odoo.tools import config
from odoo.service import db
config['db_host'] = 'db'
config['db_user'] = '$ODOO_DB_USERNAME'
config['db_password'] = '$ODOO_DB_PASSWORD'
db.dump_db(
    '$ODOO_DB_CURRENT_NAME',
    open(config['data_dir'] + '/filestore/$backup_filename', 'wb+')
)
EOF
  )

  # Run the script inside the version container
  echo "Exporting migrated database to $backup_filename..."
  if ! docker_compose_exec "$version" odoo/odoo-bin \
    --logname "db-export" \
    --dockercommand-arg -i \
    shell <<< "$export_script"; then
    print_error "Export failed, see $PWD/$PATH_LOGS/db-export.log"
  fi

  mv "$PATH_SOURCE/$backup_filename" "$backup_filename"
  echo "Exported migrated database to $PWD/$backup_filename"
}

# --- Helper Docker ---------------------------------------------------------

docker_compose_run() {
  local service="$1"
  local command="$2"
  shift 2
  docker_compose_exec_run run "$service" "$command" \
    --dockercommand-arg --rm \
    "${@}"
}

docker_compose_exec() {
  local service="$1"
  local command="$2"
  shift 2
  docker_compose_exec_run exec "$service" "$command" \
    --dockercommand-arg -T \
    "${@}"
}

docker_compose_exec_run() {
  local docker_command="$1"    # "run" or "exec"
  local service="$2"
  local command="$3"
  shift 3
  docker_compose "$docker_command" "$service" "$command" \
    --dockercommand-args -e "PGPASSWORD=$ODOO_DB_PASSWORD" \
    --dockercommand-args -w "/odoo" \
    "${@}"
}

docker_compose() {
  local docker_command="$1"    # "run" or "exec"
  local service="$2"
  local command="$3"
  local logname=""
  local logfile=""
  local stream="no"
  local -a docker_command_args=()
  local -a command_args=()

  # Parse optional arguments
  shift 3
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --stream)
        # mirror the logfile to the terminal as well; for steps that take long
        # enough that a silent terminal reads like a hang (image build, the
        # migration itself). Always pair it with --logname.
        shift
        stream="yes"
        ;;
      --dockercommand-args)
        shift
        docker_command_args+=("$1")
        docker_command_args+=("$2")
        shift 2
        ;;
      --dockercommand-arg)
        shift
        docker_command_args+=("$1")
        shift
        ;;
      --logname)
        shift
        logname="$1"
        shift
        ;;
      --logfile)
        shift
        logfile="$1"
        shift
        ;;
      --)
        shift
        command_args+=("$@")
        break
        ;;
      *)
        command_args+=("$1")
        shift
        ;;
    esac
  done

  # Set default logname/logfile if not provided
  if [[ "$logfile" != "False" ]]; then
    if [[ -z "$logfile" && -z "$logname" ]]; then
        logname="${service}-${command}"
        logname="${logname//\//-}"
        logfile="$PWD/$PATH_LOGS/${logname}.log"
    elif [[ -n "$logname" && -z "$logfile" ]]; then
        logname="${logname//\//-}"
        logfile="$PWD/$PATH_LOGS/${logname}.log"
    fi
  fi

  # Build the docker compose command
  local cmd=(
      docker
      compose
      -f
      "./docker-compose.yml"
      "$docker_command"
  )
  [[ ${#docker_command_args[@]} -gt 0 ]] && cmd+=("${docker_command_args[@]}")
  [[ -n "$service" ]] && cmd+=("$service")
  [[ -n "$command" ]] && cmd+=("$command")
  [[ ${#command_args[@]} -gt 0 ]] && cmd+=("${command_args[@]}")

  # Change to docker directory
  pushd "$PATH_DOCKER" > /dev/null || {
    echo "Error: Could not change to directory $PATH_DOCKER" >&2
    exit 1
  }

  # Output that lands in a file is otherwise invisible - the terminal just
  # stops, which is indistinguishable from a hang. Always say where it went.
  [[ -n "$logfile" && "$logfile" != "False" ]] && echo "  log -> $logfile"

  local status=0
  if [[ -n "$logfile" && "$logfile" != "False" ]]; then
    if [[ "$stream" == "yes" ]]; then
      COMPOSE_PROJECT_NAME=openupgrade "${cmd[@]}" 2>&1 | tee -a "$logfile" || status=$?
    else
      COMPOSE_PROJECT_NAME=openupgrade "${cmd[@]}" >> "$logfile" 2>&1 || status=$?
    fi
  else
    COMPOSE_PROJECT_NAME=openupgrade "${cmd[@]}" || status=$?
  fi

  popd > /dev/null
  return $status
}

# --- Helper Templates ---------------------------------------------------------
generate_dockerfile() {
  local python_version="$1"
  local uid gid db_major
  uid="$(id -u)"
  gid="$(id -g)"
  # The distro's unversioned postgresql-client is older than the database we are
  # asked to dump, and pg_dump refuses a newer server ("aborting because of
  # server version mismatch"). export_backup runs pg_dump from THIS image, so
  # take the client from PGDG at the same major as the source database.
  db_major="${ODOO_DB_VERSION%%-*}"

  cat <<EOF
FROM python:${python_version}
RUN groupadd -g ${gid} -o openupgrade
RUN useradd -m -u ${uid} -g ${gid} -o -s /bin/bash openupgrade --groups root
RUN apt-get update && apt-get install -y --no-install-recommends \\
    ca-certificates \\
    curl \\
    gnupg &&\\
    install -d /usr/share/postgresql-common/pgdg &&\\
    curl -fsSL -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc \\
    https://www.postgresql.org/media/keys/ACCC4CF8.asc &&\\
    . /etc/os-release &&\\
    echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] \\
https://apt.postgresql.org/pub/repos/apt \${VERSION_CODENAME}-pgdg main" \\
    > /etc/apt/sources.list.d/pgdg.list &&\\
    apt-get update &&\\
    apt-get install -y --no-install-recommends postgresql-client-${db_major} &&\\
    pg_dump --version
RUN apt update && apt -yq install \\
    build-essential \\
    libfreetype6-dev \\
    libfribidi-dev \\
    libghc-zlib-dev \\
    libharfbuzz-dev \\
    libjpeg-dev \\
    liblcms2-dev \\
    libldap2-dev \\
    libopenjp2-7-dev \\
    libpq-dev \\
    libsasl2-dev \\
    libtiff5-dev \\
    libwebp-dev \\
    libxml2-dev \\
    libxslt-dev \\
    tcl-dev \\
    tk-dev \\
    zlib1g-dev
RUN pip install git-aggregator
COPY src /odoo
COPY patches /odoo-patches
RUN git config --global --add user.name openupgrade &&\\
    git config --global --add user.email openupgrade@oca &&\\
    git config --global init.defaultBranch main
ENV PIP_CONSTRAINT=/odoo/pip.constraint
RUN cd /odoo && for yml_file in *.yml; do \\
        gitaggregate -c \$yml_file --no-color --jobs 4;\\
    done &&\\
    for requirement in */requirements.txt *.txt; do \\
        if [ -f \$requirement ]; then pip install -U -r \$requirement; fi;\\
    done &&\\
    pip install phonenumbers &&\\
    pip install ./odoo &&\\
    python3 /odoo-patches/openupgradelib-lift-constraints-pg17.py
# upstream run-migration.py execs the relative path "odoo/odoo-bin", which only
# resolves when the working dir is /odoo (their image sets it; ours must too)
WORKDIR /odoo
USER openupgrade
CMD sleep infinity
EOF
}

generate_odoo_compose(){
  cat <<EOF
networks:
  openupgrade:
    driver: bridge
    driver_opts:
      com.docker.network.bridge.enable_ip_masquerade: 0
    internal: true
services:
  db:
    image: postgres:${ODOO_DB_VERSION}
    environment:
      POSTGRES_USER: ${ODOO_DB_USERNAME}
      POSTGRES_PASSWORD: ${ODOO_DB_PASSWORD}
      POSTGRES_DB: ${ODOO_DB_CURRENT_NAME}
    networks:
      - openupgrade
EOF
}

generate_odoo_service() {
  local version="$1"
  cat <<EOF
  '${version}':
    build:
      context: ./${version}
    depends_on:
      - db
    volumes:
      - type: bind
        source: ../source
        target: /home/openupgrade/.local/share/Odoo/filestore
    networks:
      - openupgrade
EOF
}

generate_odoo_gitaggregate() {
  local version="$1"
  local out

  out=$(
    cat <<EOF
odoo:
  defaults:
    depth: 1
  remotes:
    oca: https://github.com/oca/ocb
  merges:
    - oca $version
openupgrade:
  defaults:
    depth: 1
  remotes:
    oca: https://github.com/oca/openupgrade
  merges:
    - oca $version
EOF
  )

  # one git-aggregate block per additional repository, same shape as the two
  # defaults above; this is what upstream run-migration.py emits
  local repo
  for repo in "${OCA_REPOS_DETECTED[@]}"; do
    [[ -z "$repo" ]] && continue
    out+=$(printf '\n%s:\n  defaults:\n    depth: 1\n  remotes:\n    oca: https://github.com/oca/%s\n  merges:\n    - oca %s' "$repo" "$repo" "$version")
  done

  # ODOO_EXTRA_REPOS entries are "<name> <url>" for private/custom addons or a
  # bare OCA repository name that the database does not identify
  local entry
  for entry in "${ODOO_EXTRA_REPOS[@]}"; do
    [[ -z "$entry" ]] && continue
    local -a parts
    read -ra parts <<< "$entry"
    local name url
    if [[ ${#parts[@]} -ge 2 ]]; then
      name="${parts[0]}"
      url="${parts[1]}"
    else
      name="${parts[0]}"
      url="https://github.com/oca/${parts[0]}"
    fi
    out+=$(printf '\n%s:\n  defaults:\n    depth: 1\n  remotes:\n    oca: %s\n  merges:\n    - oca %s' "$name" "$url" "$version")
  done

  printf '%s\n' "$out"
}

declare -A ODOO_VT_DOCKERFILE=(
  ["14.0"]="3.8"
  ["15.0"]="3.8"
  ["16.0"]="3.11"
  ["17.0"]="3.11"
  ["18.0"]="3.12"
  ["19.0"]="3.12"
)

declare -A ODOO_VT_CONSTRAINTS=(
  ["14.0"]="Werkzeug<0.17 pyOpenSSL<23 cryptography<23.2.0 pypdf<5.0 lxml<5.0"
  ["15.0"]="lxml<5.0 pyOpenSSL<23 cryptography<23.2.0"
  ["16.0"]="lxml<5.0 pyOpenSSL<23 cryptography<23.2.0"
  ["17.0"]="lxml<5.0 pyOpenSSL<23 cryptography<23.2.0"
)

# openupgradelib is published on PyPI; the git URL that used to be pinned here
# stopped resolving and is no longer needed.
declare -A ODOO_VT_REQUIREMENTS=()

# --- Helper Default -----------------------------------------------------------

print_error() {
  echo "Error: $1" >&2
  exit 1
}

print_warning() {
  echo "Warning: $1" >&2
}

check_dependencies() {
  local deps=(docker git unzip jq fzf curl numfmt tee)
  for dep in "${deps[@]}"; do
    if ! command -v "$dep" &>/dev/null; then
      print_error "Missing dependency: '$dep'. Install it or add to PATH."
    fi
  done
}

# --- Entry Point --------------------------------------------------------------

usage() {
  cat <<USAGE
Usage: ./migration.sh [backup.zip] [command] [--anonymize]

  (no command)  run the migration - every step is asked with fzf, nothing
                needs to be set beforehand
  anonymize     run the migration and scrub the export (mail/SMTP removed,
                e-mail/name rewritten, phone/address/bank nulled, 2FA + API
                keys removed, passwords reset to "test", login "admin") so
                the resulting .zip is safe for a test instance
  cleanup       only pick what to reclaim, run no migration
  help          this text

Options (all optional, each one otherwise asked with fzf):
  backup.zip    the source backup, skips the file picker
  --anonymize   same as the anonymize command

Examples:
  ./migration.sh                            full migration, asks for everything
  ./migration.sh ./odoo-18.0.zip            migration with a preset backup file
  ./migration.sh anonymize                  migration + anonymized export
  ./migration.sh cleanup                    free disk after a run
  ./migration.sh help
USAGE
}

# --- Entry Point --------------------------------------------------------------
BACKUP_FILE=""
action=""
for arg in "$@"; do
  case "$arg" in
    anonymize | --anonymize)
      ANONYMIZE=true
      ;;
    cleanup)
      action="cleanup"
      ;;
    help | -h | --help)
      action="help"
      ;;
    *.zip)
      BACKUP_FILE="$arg"
      ;;
    *)
      printf 'Unknown argument: %s\n\n' "$arg" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$action" in
  cleanup)
    check_dependencies
    cleanup_menu
    ;;
  help)
    usage
    ;;
  *)
    main
    ;;
esac
