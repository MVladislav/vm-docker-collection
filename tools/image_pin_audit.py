#!/usr/bin/env python3
"""Guard the image pins Renovate has to look up.

Renovate resolves a Compose pin by asking the registry for its tag list. Two
classes of pin make that fail, and both fail *quietly enough* to be missed:

TOKEN-REQUIRED   the registry answers `/v2/` with 401 plus a
                 `www-authenticate: Bearer ...` challenge, so every lookup needs
                 a token round-trip first. When that token call fails Renovate's
                 `getAuthHeaders()` returns undefined, `getTags()` returns
                 undefined, `_getReleases()` returns null and the dependency is
                 reported as `Failed to look up docker package <x>: no-result`
                 preceded by `Error obtaining docker token`.
UNLOOKABLE       the image is a placeholder (a private/localhost registry, a
                 `...` path, a missing tag). Renovate either skips it or reports
                 it as a lookup failure on every run.

Default mode is offline and only applies the two static rules above, so it is
fast enough to gate a commit. `--online` additionally asks each registry whether
the pinned tag itself exists; when it does, Renovate treats the pin as already
satisfied and can never propose an update (a silent no-op, not a warning).

The audited file set is read from `.github/renovate.json` (`customManagers[0].managerFilePatterns`
plus `ignorePaths`) so the guard and Renovate always see the same files.

Exit code is 1 while any finding is open, so the tool can gate a commit.
"""

import argparse
import concurrent.futures
import json
import re
import sys
import urllib.error
import urllib.parse
import urllib.request
from collections import defaultdict
from pathlib import Path

# Fallbacks, used only when `.github/renovate.json` cannot be read. They mirror
# the values that file ships today.
DEFAULT_FILE_PATTERNS = [r"(^|/)(?:docker-)?compose[^/]*\.ya?ml$"]
DEFAULT_IGNORE_PATHS = [
    "**/config/**",
    "**/docker-hwaccel.yaml",
    "composer/other/focalboard/Dockerfile",
]

# Deliberate exceptions, keyed by `dep:value`, with the reason they are accepted.
#
# The house rule is: pin the *service* version, and let the vendor pick the
# underlying OS variant it builds and tests against. `postgres:18.6-alpine3.24`
# would be trackable by Renovate but it hardcodes an alpine build that upstream
# chooses, so postgres bumps have to be done by hand instead. Anything listed
# here is reported as ACCEPTED rather than FLOATING.
ACCEPTED_ROLLING_PINS = {
    "postgres:18.6-alpine": (
        "vendor picks the alpine base for the postgres line; pinning "
        "18.6-alpine3.24 would couple the service version to an OS build the "
        "vendor chooses, so postgres bumps stay manual"
    ),
    "odoo:19.0": (
        "Odoo has no patch releases: upstream tags are `17.0`, `18.0`, `19.0`, "
        "`20.0` plus dated nightlies (`19.0-20260926`), so `19.0` is the "
        "complete version, not a rolling minor of a `19.0.x` line. Renovate "
        "still proposes `20.0` because the tag string changes. The three-part "
        "rule in `is_trackable_pin` targets semver-style rolling tags and does "
        "not apply to this scheme"
    ),
}

# Image lines Renovate's `matchStrings` cannot parse at all, keyed by the exact
# `image:` value, with the reason the line is accepted. Everything else that fails
# to match is reported as UNMATCHED, because an unparsable line is worse than a
# floating one: Renovate never sees the dependency at all, so no version of that
# stack's image can ever be proposed.
ACCEPTED_UNMATCHED = {
    # deliberate local build tag: the service has a `build:` section pointing at
    # the upstream git repo, so the name is a local alias rather than something to
    # pull. The official image is the commented alternative. Also listed in
    # `.github/renovate.json` `ignoreDeps` for the same reason.
    "snipe-it": (
        "local build tag for a service with a `build:` section, not a pullable "
        "image; the official `snipe/snipe-it` is the commented alternative"
    ),
}

# Mirrors the regex manager's `matchStrings`: only `${VAR:-default}` pins are
# visible to it, so only those can be updated by Renovate. There are two
# `matchStrings` and the second one also accepts a tag *suffix* outside the
# interpolation (`docker:${VERSION_DIND:-29.8.1}-dind`), which the manager
# recombines via `currentValueTemplate: "{{currentValue}}{{currentValueSuffix}}"`
# — so the suffix is optional here and appended to the value.
PIN_RE = re.compile(
    r"^[ \t]*image:\s*[\"']?(?P<dep>[^\s\"'$]+):"
    r"\$\{[A-Za-z_][A-Za-z0-9_]*:-\s*(?P<val>[^}\s\"']+)\}"
    r"(?P<suffix>[-\w.]*)[^\s\"']*[\"']?[ \t]*$"
)
ANY_IMAGE_RE = re.compile(r"^[ \t-]*image:\s*[\"']?(?P<img>[^\s\"'#$]+)")
COMMENT_RE = re.compile(r"^[ \t]*#")

# Mirrors `tools/sync_readme_versions.py`. Renovate classifies these as an
# "unsupported/unversioned value" and skips them *before* it reaches the
# registry, so a placeholder pin like `localhost:5000/...:${VERSION:-latest}` is
# never looked up and is not a finding.
ROLLING_VALUES = {
    "latest",
    "master",
    "main",
    "edge",
    "rolling",
    "nightly",
    "continuous",
    "dev",
    "beta",
    "stable",
}

DOCKER_HUB = "https://index.docker.io"

# Registries that gate every request behind a bearer token. Renovate supports the
# standard `realm=`/`service=`/`scope=` challenge, but a failure there is silent
# (see the module docstring), so these hosts are reported rather than trusted.
#   ghcr.io / registry.k8s.io  - standard challenge, needed by most stacks, kept
#                                out of this list; only unverifiable hosts land here.
TOKEN_REQUIRED = {
    # the forge's own Forgejo *package* registry: challenge carries
    # service="container_registry" and scope="*", and /v2/ is 401 as well
    "codeberg.org": "data.forgejo.org",
    # the docs' mirror of the above, same token requirement
    "code.forgejo.org": "data.forgejo.org",
}

# Registry hosts that are placeholders rather than real registries.
LOCAL_HOST_RE = re.compile(
    r"^(localhost|127\.0\.0\.1|0\.0\.0\.0|\[::1\]|host\.docker\.internal)(:\d+)?$"
)


def js_regex(source):
    """Compile a Renovate `managerFilePatterns` entry, written as `/regex/`."""
    source = source.strip()
    if len(source) > 1 and source.startswith("/") and source.endswith("/"):
        source = source[1:-1]
    return re.compile(source)


def glob_regex(pattern):
    """Compile a Renovate `ignorePaths` glob, matching how minimatch behaves."""
    out, index = "", 0
    while index < len(pattern):
        char = pattern[index]
        if pattern.startswith("**/", index):
            out += "(?:.*/)?"
            index += 3
            continue
        if pattern.startswith("**", index):
            out += ".*"
            index += 2
            continue
        if char == "*":
            out += "[^/]*"
        elif char == "?":
            out += "[^/]"
        else:
            out += re.escape(char)
        index += 1
    return re.compile("(?:%s)$" % out)


def renovate_scope(root):
    """Return the file matcher and ignore matcher Renovate's regex manager uses."""
    config = root / ".github" / "renovate.json"
    patterns, ignored = DEFAULT_FILE_PATTERNS, DEFAULT_IGNORE_PATHS
    if config.is_file():
        try:
            data = json.loads(config.read_text(encoding="utf-8"))
        except ValueError:
            data = {}
        managers = data.get("customManagers") or []
        regex_manager = next(
            (m for m in managers if m.get("customType") == "regex"), None
        )
        if regex_manager and regex_manager.get("managerFilePatterns"):
            patterns = regex_manager["managerFilePatterns"]
        if data.get("ignorePaths"):
            ignored = data["ignorePaths"]
    return [js_regex(p) for p in patterns], [glob_regex(p) for p in ignored]


def compose_files(root):
    matchers, ignores = renovate_scope(root)
    selected = []
    for path in sorted(root.rglob("*.y*ml")):
        relative = path.relative_to(root).as_posix()
        if any(matcher.search(relative) for matcher in matchers):
            if not any(
                ignore.search("/" + relative) or ignore.search(relative)
                for ignore in ignores
            ):
                selected.append(path)
    return selected


def registry_of(dep):
    """Split a dep into (registry, repository) the way a registry expects it.

    Docker Hub's official images live under `library/`, so a single-segment name
    such as `postgres` has to become `library/postgres` before any `/v2/...`
    request. Renovate does the same in `getRegistryRepository()`.
    """
    parts = dep.split("/")
    if len(parts) > 1 and ("." in parts[0] or ":" in parts[0]):
        return "https://" + parts[0], "/".join(parts[1:])
    if len(parts) == 1:
        return DOCKER_HUB, "library/" + dep
    return DOCKER_HUB, dep


def collect(root):
    """Return (pinned deps keyed by (project, dep, value), unparsed image lines)."""
    found = defaultdict(list)
    unparsed = []
    for path in compose_files(root):
        text = path.read_text(encoding="utf-8", errors="replace")
        for no, line in enumerate(text.splitlines(), 1):
            if COMMENT_RE.match(line):
                continue
            match = PIN_RE.match(line)
            if match:
                dep, val = match["dep"], match["val"] + (match["suffix"] or "")
            else:
                match = ANY_IMAGE_RE.match(line)
                if not match:
                    continue
                img = match["img"].strip()
                where = "%s:%d" % (path.relative_to(root), no)
                if "${" in img:
                    # a variable in the repository part, or a pin with no default.
                    # `depName` cannot contain `$`, so Renovate's regex can never
                    # match this line and the dependency is invisible to it.
                    unparsed.append(
                        (
                            img,
                            where,
                            "a variable in the image reference cannot be a Renovate "
                            "`depName`; use an explicit repository and a commented "
                            "sibling `image:` line for the variant (AGENTS.md 12.3)",
                        )
                    )
                    continue
                dep, _, val = img.rpartition(":")
                if not dep or "/" not in dep:
                    # no registry and no tag: a bare name, nothing to look up
                    unparsed.append(
                        (
                            img,
                            where,
                            "untagged local image name; Renovate has no repository "
                            "and no version to track, so it is listed in "
                            "`renovate.json` `ignoreDeps` instead",
                        )
                    )
                    continue
            if val in ROLLING_VALUES:
                # Renovate skips these before the registry is ever contacted
                continue
            if not val:
                # a nested default such as `${VERSION_X:-${OTHER:-}}` leaves no
                # pinnable value here, so there is nothing to audit
                unparsed.append(
                    (
                        line.strip().split("image:", 1)[-1].strip(),
                        "%s:%d" % (path.relative_to(root), no),
                        "a nested `${VAR:-${OTHER:-}x}` default is not pinnable and "
                        "hides the pin from Renovate; collapse it to one variable "
                        "(AGENTS.md 12.3)",
                    )
                )
                continue
            found[(dep, val)].append("%s:%d" % (path.relative_to(root), no))
    return found, unparsed


def http(url, headers=None, timeout=45):
    request = urllib.request.Request(
        url, headers=headers or {"User-Agent": "image-pin-audit"}
    )
    try:
        with urllib.request.urlopen(request, timeout=timeout) as response:
            return response.status, response.headers, response.read()
    except urllib.error.HTTPError as err:
        return err.code, err.headers, err.read()
    except Exception as err:  # noqa: BLE001 - network errors are a finding, not a crash
        return None, None, str(err).encode()


def registry_token(host, repository):
    status, headers, _ = http(host + "/v2/")
    if status == 200:
        return "none", None
    if status != 401 or headers is None:
        return "probe:%s" % status, None
    challenge = headers.get("www-authenticate") or headers.get("WWW-Authenticate") or ""
    realm = re.search(r'realm="([^"]+)"', challenge)
    if not realm:
        return "no-realm", None
    params = [("scope", "repository:%s:pull" % repository)]
    service = re.search(r'service="([^"]+)"', challenge)
    if service:
        params.append(("service", service.group(1)))
    url = realm.group(1).split("?", 1)[0] + "?" + urllib.parse.urlencode(params)
    status, _, body = http(url)
    if status != 200:
        return "token:%s" % status, None
    try:
        token = json.loads(body).get("token") or json.loads(body).get("access_token")
    except ValueError:
        return "bad-json", None
    return ("none" if not token else "ok"), token


def registry_tags(host, repository):
    """Full paginated tag list, or a short string describing why it failed."""
    state, token = registry_token(host, repository)
    if token is None and state not in ("none", "ok"):
        return state
    headers = {"Authorization": "Bearer " + token} if token else {}
    tags = []
    url = host + "/v2/%s/tags/list?n=10000" % repository
    for _ in range(50):
        status, response_headers, body = http(url, headers)
        if status != 200:
            return "tags:%s" % status
        try:
            tags += json.loads(body)["tags"]
        except (ValueError, KeyError):
            return "tags:bad-json"
        link = response_headers.get("link") if response_headers else None
        match = re.match(r'<([^>]+)>;\s*rel="next"', link or "")
        if not match:
            break
        url = (
            host + match.group(1) if match.group(1).startswith("/") else match.group(1)
        )
    return tags


def is_trackable_pin(value):
    """True when Renovate can propose an update for a pin of this shape.

    A major-only or major.minor-only tag is a *rolling* tag: upstream moves it,
    the string never changes, and Renovate treats the dependency as satisfied as
    soon as any tag matches. Measured on `data.forgejo.org/forgejo/forgejo`:

        16      -> no update offered      (rolling major tag)
        16.0    -> no update offered      (rolling minor tag)
        16.0.0  -> 16.0.5
        16.0.4  -> 16.0.5
        15.0.9  -> 16.0.5

    So three numeric components are what makes a pin trackable.
    """
    core = value.split("-", 1)[0].lstrip("vV")
    parts = core.split(".")
    return all(part.isdigit() for part in parts) and len(parts) >= 3


def static_findings(pins, unparsed=()):
    findings = []
    for img, where, message in unparsed:
        if img in ACCEPTED_UNMATCHED:
            findings.append(("ACCEPTED", img, where, ACCEPTED_UNMATCHED[img]))
        else:
            findings.append(("UNMATCHED", img, where, message))
    for (dep, val), places in sorted(pins.items()):
        host, repository = registry_of(dep)
        bare_host = host.removeprefix("https://")
        where = places[0]
        if bare_host in TOKEN_REQUIRED:
            findings.append(
                (
                    "TOKEN-REQUIRED",
                    dep,
                    where,
                    "%s answers /v2/ with 401 and needs a bearer token for every "
                    "lookup; use %s" % (bare_host, TOKEN_REQUIRED[bare_host]),
                )
            )
        elif LOCAL_HOST_RE.match(bare_host):
            findings.append(
                (
                    "UNLOOKABLE",
                    dep,
                    where,
                    "%s is not a public registry, Renovate cannot resolve it"
                    % bare_host,
                )
            )
        elif "..." in repository or repository.endswith("/"):
            findings.append(
                ("UNLOOKABLE", dep, where, "placeholder image path, not a real image")
            )
    return findings


def online_findings(pins):
    findings = []
    hosts = {}
    for dep, _ in pins:
        host, repository = registry_of(dep)
        hosts.setdefault((host, repository), dep)

    def probe(item):
        (host, repository), dep = item
        try:
            return host, repository, dep, registry_tags(host, repository)
        except Exception as err:  # noqa: BLE001
            return host, repository, dep, "exc:%s" % err

    with concurrent.futures.ThreadPoolExecutor(max_workers=12) as pool:
        for host, repository, dep, tags in pool.map(probe, sorted(hosts.items())):
            if not isinstance(tags, list):
                findings.append(
                    (
                        "LOOKUP-FAILED",
                        dep,
                        "-",
                        "%s: tag list unavailable (%s)" % (host, tags),
                    )
                )
                continue
            for (candidate, value), places in sorted(pins.items()):
                if candidate != dep or is_trackable_pin(value):
                    continue
                if value not in tags:
                    continue
                accepted = ACCEPTED_ROLLING_PINS.get(f"{dep}:{value}")
                if accepted:
                    findings.append(
                        (
                            "ACCEPTED",
                            dep,
                            places[0],
                            "`%s` stays a rolling pin on purpose: %s"
                            % (value, accepted),
                        )
                    )
                    continue
                findings.append(
                    (
                        "FLOATING",
                        dep,
                        places[0],
                        "tag `%s` is a rolling tag in %s: it exists, so Renovate "
                        "treats the pin as satisfied and never proposes an update "
                        "(verified: 16 and 16.0 yield nothing, 16.0.0 yields "
                        "16.0.5); pin a full three-part version" % (value, host),
                    )
                )
    return findings


def main():
    parser = argparse.ArgumentParser(
        description="Audit Compose image pins Renovate has to look up",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("root", nargs="?", default=".", help="repository root")
    parser.add_argument(
        "--online",
        action="store_true",
        help="also query every registry (slow, needs network) to detect pins "
        "Renovate can never bump",
    )
    parser.add_argument("--verbose", action="store_true", help="show every audited pin")
    args = parser.parse_args()
    root = Path(args.root).resolve()
    pins, unparsed = collect(root)

    print(
        "audited %d pinned images in %d Compose files"
        % (len(pins), len(compose_files(root)))
    )
    if args.verbose:
        for (dep, val), places in sorted(pins.items()):
            print("  %-58s %-20s %s" % (dep, val, places[0]))

    findings = static_findings(pins, unparsed)
    if args.online:
        findings += online_findings(pins)

    if not findings:
        print("no findings")
        return 0

    order = {
        "UNMATCHED": 0,
        "TOKEN-REQUIRED": 1,
        "UNLOOKABLE": 2,
        "LOOKUP-FAILED": 3,
        "FLOATING": 4,
        "ACCEPTED": 5,
    }
    # FLOATING and ACCEPTED are advisory: a rolling pin is a deliberate choice
    # in several stacks, so it is reported but does not gate the run.
    advisory = {"FLOATING", "ACCEPTED"}
    for level, dep, where, message in sorted(
        findings, key=lambda f: order.get(f[0], 9)
    ):
        print("%-15s %-58s %s" % (level, dep, where))
        print("%15s %s" % ("", message))
    blocking = [f for f in findings if f[0] not in advisory]
    print("\n%d finding(s), %d blocking" % (len(findings), len(blocking)))
    return 1 if blocking else 0


if __name__ == "__main__":
    sys.exit(main())
