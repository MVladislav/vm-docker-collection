#!/usr/bin/env python3
"""
README.md + MAINTENANCE.md generator for vm-docker-collection.

Reads composer/ folder structure and git history to generate the collection index
with two-table split (current/maintained vs older/stale), POSSIBLE LATER table,
and carries over Backlog/Quick PenTest/Best Practice/References sections.

Usage:
    python tools/readme_gen.py --write          # regenerate README.md + MAINTENANCE.md
    python tools/readme_gen.py --check          # verify index↔composer sync
"""

import argparse
import collections
import datetime
import glob
import os
import re
import subprocess
import sys

# ----- configuration -----
REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
COMPOSER_DIR = os.path.join(REPO_ROOT, "composer")
README_PATH = os.path.join(REPO_ROOT, "README.md")
MAINT_PATH = os.path.join(REPO_ROOT, "MAINTENANCE.md")
TODAY = datetime.date.today()

# Emoji & display
EMOJI = {
    "up-to-date": "\U0001f7e2",
    "older": "\U0001f7e1",
    "stale": "\U0001f534",
    "bulk-only": "\U0001f7e0",
    "archived": "⚫",
    "new": "\U0001f195",
}
UPSTREAM_ALERTS = {}
STATUS_OVERRIDES = {}
TPL_DISP = {"yes": "yes", "partial": "\u00b1", "no": "no", "custom": "custom"}
PIN_MARK = "\U0001f512"  # lock: stack held back in the second table by UNFEATURED
NOTE_INDEX = (
    "Stack folders are grouped by **topic** (own title rows). `type` = stack kind, "
    "`ver` = image tag pinned in the compose default "
    "(see [Collection Status](#collection-status))."
)

# Template class per app (from tpl_class.txt + overrides)
TPL_CLS = {
    "ollama": "template",
    "opencode": "semi",
    "cms_typo3": "template",
    "coder": "template",
    "code-server": "template",
    "compiler-explorer": "template",
    "acme": "semi",
    "dashy": "template",
    "diun": "semi",
    "dockhand": "template",
    "glance": "template",
    "heimdall": "scratch",
    "homepage": "template",
    "kestra": "template",
    "n8n": "template",
    "portainer": "template",
    "traefik": "template",
    "beszel": "template",
    "checkmate": "template",
    "checkmk": "scratch",
    "dependencytrack": "template",
    "gotify": "template",
    "librenms": "template",
    "observium": "template",
    "pandorafms": "scratch",
    "patchmon": "template",
    "prometheus": "template",
    "pulse": "template",
    "speedtest-tracker": "template",
    "uptime_kuma": "template",
    "zabbix": "template",
    "automatic-ripping-machine": "template",
    "dawarich": "template",
    "focalboard": "scratch",
    "github-stats": "template",
    "intercept": "template",
    "mirotalk-p2p": "template",
    "paperless-ngx": "template",
    "yamtrack": "template",
    "cloudflare-ddns": "semi",
    "cloudflare-tunnel": "semi",
    "netmaker": "template",
    "openvpn": "semi",
    "pangolin": "semi",
    "snowflake-proxy": "semi",
    "teleport": "template",
    "wireguard-easy": "template",
    "wireguard-ui": "template",
    "faraday": "template",
    "linux-malware-detect": "semi",
    "nessus": "template",
    "nexpose": "template",
    "ngrok": "scratch",
    "openvas": "template",
    "portspoof": "scratch",
    "suricata": "semi",
    "bounty-collection": "semi",
    "docker-bench-security": "semi",
    "evilginx2": "template",
    "hashcat": "semi",
    "metasploit": "semi",
    "netexec": "semi",
    "nuclei": "semi",
    "set": "scratch",
    "villain": "semi",
    "zeek": "semi",
    "attack-navigator": "semi",
    "caido": "template",
    "gophish": "template",
    "gowitness": "template",
    "opencti": "template",
    "so-crates": "template",
    "spiderfoot": "template",
    "velociraptor": "template",
    "web-check": "template",
    "crowdsec": "scratch",
    "grafana": "template",
    "graylog": "template",
    "influxdb": "template",
    "rootprint": "template",
    "sophos": "scratch",
    "splunk": "template",
    "telegraf": "scratch",
    "thehive4": "scratch",
    "wazuh": "template",
    "akkudoktor": "template",
    "evcc": "template",
    "grocy": "template",
    "mealie": "template",
    "netboot": "template",
    "netbox": "template",
    "semaphore": "template",
    "snipe-it": "template",
    "forgejo": "template",
    "open-archiver": "template",
    "syncthing": "template",
    "zerobyte": "template",
    "drawio": "template",
    "excalidraw": "template",
    "penpot": "template",
    "actualbudget": "template",
    "erpnext": "template",
    "firefly-iii": "template",
    "InvoiceShelf": "template",
    "affine": "template",
    "calcom": "template",
    "docmost": "template",
    "easyappointments": "template",
    "filebrowser": "template",
    "ghost": "template",
    "immich": "template",
    "kimai": "template",
    "listmonk": "template",
    "nextcloud": "template",
    "nextcloud-aio": "semi",
    "odoo": "template",
    "openproject": "template",
    "owncloud": "template",
    "plane": "template",
    "plane-com": "template",
    "bitwarden": "template",
    "goauthentik": "template",
    "infisical": "template",
    "keycloak": "template",
    "passbolt": "template",
    "freshrss": "template",
    "ittools": "template",
    "omni-tools": "template",
    "openspeedtest": "template",
    "rxresu": "template",
    "searxng": "template",
    "shlink": "scratch",
    "stirling-pdf": "template",
}

# New/uncommitted stacks not yet in README index
EXTRA = {
    "keycloak": (
        "Identity Management",
        "[keycloak](https://github.com/keycloak/keycloak)",
        "Open-source identity and access management.",
    ),
    "rootprint": (
        "Digital Footprint",
        "[rootprint](https://github.com/rootprint/rootprint)",
        "Tool for analyzing and visualizing digital footprints.",
    ),
}
LINK_OVERRIDES = {
    "rootprint": "[rootprint](https://github.com/rootprint/rootprint)",
}
# Stacks forced into the "Current & Maintained" table even when their git-derived
# status would place them in the second one (deliberate exceptions, not stale ones).
FEATURED = {
    "ittools",
    "omni-tools",
    "openspeedtest",
    "stirling-pdf",
    "InvoiceShelf",
    "drawio",
}

# Stacks pinned to the "Bulk-only / Older / Archived" table even when git history
# says they are focused-recent. The usual reason: the last touch was a pure
# `chore(deps): update <app> to version <X>` bump whose configs, anchors, probe
# and README were never re-verified afterwards, so it is not real maintenance.
#
# Remove an entry once the stack got a proper review (compose re-read, anchor
# alignment, healthcheck validated, README `.env` example checked) - the
# generator then places it by git status alone.
#
# `python tools/readme_gen.py --check` reports green stacks that are not pinned
# here yet, so this list cannot silently rot.
UNFEATURED = {
    "kestra",
    "n8n",
    "checkmate",
    "dawarich",
    "netmaker",
    "opencti",
    "crowdsec",
    "graylog",
    "wazuh",
    "netbox",
    "zerobyte",
    "calcom",
    "docmost",
}

# Infrastructure images to ignore in version detection
INFRA = re.compile(
    r"^(postgres|postgis|mariadb|mysql|redis|valkey|memcached|mongo|mongodb|rabbitmq|elasticsearch|nginx|caddy|alpine|debian|ubuntu|busybox|coredns|minio|mc|adminer|phpmyadmin|solr|clickhouse)$"
)


# ----- helpers -----
def run(cmd, cwd=None):
    return subprocess.run(
        cmd, cwd=cwd or REPO_ROOT, capture_output=True, text=True
    ).stdout.strip()


def git_history():
    output = run(
        [
            "git",
            "log",
            "--format=@@@%ad%x01%s",
            "--date=short",
            "--name-only",
            "--",
            "composer",
        ]
    )
    commits = []
    date = None
    subject = None
    paths = []
    for line in output.splitlines():
        if line.startswith("@@@"):
            if date:
                commits.append((date, subject, paths))
            date, _, subject = line[3:].partition("\x01")
            paths = []
        elif line:
            paths.append(line)
    if date:
        commits.append((date, subject, paths))
    stack_path = re.compile(r"^composer/[^/]+/([^/]+)/")
    history = collections.defaultdict(
        lambda: {"any": None, "focused": None, "focused_subject": ""}
    )
    for date, subject, paths in commits:
        stacks = {match.group(1) for path in paths if (match := stack_path.match(path))}
        bulk = len(stacks) >= 6
        for stack in stacks:
            row = history[stack]
            row["any"] = max(filter(None, [row["any"], date]), default=None)
            stack_paths = []
            for path in paths:
                match = stack_path.match(path)
                if match and match.group(1) == stack:
                    stack_paths.append(path)
            meaningful = any(
                path.rsplit("/", 1)[-1].startswith("docker-compose")
                or path.endswith("/README.md")
                or "/config/" in path
                for path in stack_paths
            )
            if not bulk and meaningful:
                if row["focused"] is None or date > row["focused"]:
                    row["focused"] = date
                    row["focused_subject"] = subject or ""
    return history


# A `chore(deps): update <app> to version <X>` commit with no `+ <what else>`
# suffix is a pure version bump: it proves the tag was picked, not that the
# configs still line up with the new image. Per AGENTS.md the repo convention is
# that real work is spelled out in that `+ ...` tail, so its absence is a usable
# signal for "bump only, not re-verified".
BUMP_ONLY_RE = re.compile(r"^(chore\(deps\)|build\(deps\)|fix\(deps\)):")
BUMP_DETAIL_RE = re.compile(r"\s\+\s")


def is_bump_only(subject):
    if not BUMP_ONLY_RE.match(subject):
        return False
    return not BUMP_DETAIL_RE.search(subject)


def resolve_tag(tag):
    for _ in range(6):
        new = re.sub(
            r"\$\{([A-Za-z_][A-Za-z0-9_]*):-(?P<d>[^$]*)}", lambda m: m.group("d"), tag
        )
        new = re.sub(r"\$\{([A-Za-z_][A-Za-z0-9_]*)\}", "", new)
        if new == tag:
            break
        tag = new
    return tag.strip()


def interp(s, depth=0):
    if depth > 8 or "${" not in s:
        return s
    i = s.index("${")
    j = i + 2
    bra = 1
    while bra and j < len(s):
        if s[j] == "{":
            bra += 1
        elif s[j] == "}":
            bra -= 1
        j += 1
    inner = s[i + 2 : j - 1]
    if ":-" in inner:
        name, _, d = inner.partition(":-")
        s = s[:i] + interp(d, depth + 1) + s[j:]
    else:
        s = s[:i] + "" + s[j:]
    return interp(s, depth + 1)


def image_basename(img):
    name = img.split("@")[0]
    if ":" in name.split("/")[-1]:
        name = name.rsplit(":", 1)[0]
    return name.split("/")[-1]


def version_of(appdir, foldername):
    folder = foldername.lower()
    cands = []
    for f in sorted(glob.glob(os.path.join(appdir, "docker-compose*.yaml"))):
        try:
            txt = open(f).read()
        except OSError:
            continue
        for m in re.finditer(r"image:\s*[\"']?([^\"'\s]+)", txt):
            img = m.group(1).strip("'\"")
            res_img = interp(img)
            base = image_basename(res_img)
            if not base or INFRA.match(base):
                continue
            tail = res_img.split("/")[-1]
            res = tail.split(":", 1)[1] if ":" in tail else ""
            if not res:
                continue
            repo = "/".join(img.split("/")[:-1]).lower()
            base_l = base.lower()
            match = 0
            if base_l == folder:
                match = 6
            elif folder in base_l:
                match = 5
            elif base_l in folder and len(base_l) >= 3:
                match = 4
            elif folder in repo:
                match = 3
            envdef = "${" in img
            versionlike = 1 if re.match(r"^[0-9v]", res) else 0
            score = (1 if envdef else 0) + (1 if res != "latest" else 0) + versionlike
            cands.append((match, score, res))
    if not cands:
        return ""
    cands.sort(key=lambda c: (-c[0], -c[1]))
    top = [c for c in cands if c[0] == cands[0][0]]
    top.sort(key=lambda c: -c[1])
    res = top[0][2]
    return "" if res == "latest" else res


# ----- scan composer -----
def scan_composer():
    apps = {}
    history = git_history()
    for cat in sorted(os.listdir(COMPOSER_DIR)):
        cp = os.path.join(COMPOSER_DIR, cat)
        if not os.path.isdir(cp):
            continue
        for app in sorted(os.listdir(cp)):
            p = os.path.join(cp, app)
            if not os.path.isdir(p):
                continue
            stack_history = history.get(
                app, {"any": None, "focused": None, "focused_subject": ""}
            )
            d = stack_history["focused"]
            if d is None:
                age = "bulk-only" if stack_history["any"] else "new"
            else:
                delta = (TODAY - datetime.date.fromisoformat(d)).days
                age = (
                    "up-to-date"
                    if delta <= 120
                    else ("older" if delta <= 365 else "stale")
                )
            age = STATUS_OVERRIDES.get(app, age)
            cls_raw = TPL_CLS.get(app, "scratch")
            cls = {"template": "yes", "semi": "partial", "scratch": "no"}.get(
                cls_raw, "custom"
            )
            if app == "pangolin":
                cls = "custom"
            ver = version_of(p, app)
            bump_only = is_bump_only(stack_history["focused_subject"])
            apps[app] = (cat, d, age, cls, ver, bump_only)
    # EXTRA additions - only display info, not full tuple
    for name, (typ, ncell, desc) in EXTRA.items():
        if name not in apps:
            apps[name] = (
                "sys-security" if name == "keycloak" else "siem",
                None,
                "new",
                "yes",
                "",
                False,
            )
    return apps


# ----- README parsing -----
def cells_of(line):
    s = line.rstrip("\n")
    if not s.lstrip().startswith("|"):
        return None
    return [c.strip() for c in s.strip().strip("|").split("|")]


link_re = re.compile(r"^(~*)\[([^\]]+)\]\(([^)]*)\)(~*)$")

PL_HEADER = ("type", "name", "ver", "description", "last", "status", "tpl")


def parse_possible_later(lines):
    """Return the hand-maintained POSSIBLE LATER rows as (type, name, description).

    These rows are owned by hand in README.md and must survive a regeneration
    untouched, so the parser anchors on the `### POSSIBLE LATER` *heading*. The
    previous matcher looked for a table row containing the text - only the
    heading matches, and it does not start with `|`, so the section was found
    never and got wiped on every run.
    """
    out = []
    head = next(
        (
            n
            for n, l in enumerate(lines)
            if l.lstrip().startswith("#") and "POSSIBLE LATER" in l
        ),
        None,
    )
    if head is None:
        return out
    for l in lines[head + 1 :]:
        if l.lstrip().startswith("#"):
            break  # next heading ends the table
        if re.fullmatch(r"\|[\s:|-]+\|", l.strip()):
            continue  # separator row
        c = cells_of(l)
        if not c or len(c) < 4:
            continue
        if [x.lower() for x in c[:4]] == list(PL_HEADER[:4]):
            continue  # column header, not data
        typ, ncell, desc = c[0], c[1], c[3]
        if not (typ or ncell or desc):
            continue  # blank spacer row, nothing to preserve
        out.append((typ, ncell, desc))
    return out


def parse_old_readme(old_lines, apps):
    # find index table start - look for the header row with "type | name | ver | description | last | status | tpl"
    start = next(
        (
            n
            for n, l in enumerate(old_lines)
            if l.strip().startswith("| type") and "name" in l and "ver" in l
        ),
        None,
    )
    if start is None:
        return [], [], "", "", "", "", old_lines
    header = old_lines[:start]
    while header and header[-1].strip() == "":
        header.pop()

    # Keep only the title/description part (up to first ---), exclude the ---
    filtered_header = []
    for line in header:
        if line.strip() == "---":
            break
        filtered_header.append(line)
    header = filtered_header

    # Remove old "## Index" if present
    header = [l for l in header if not l.lstrip().startswith("## Index")]

    # parse app rows from index (skip header and separator rows)
    app_rows = []
    i = start + 2  # skip header and separator
    while i < len(old_lines):
        l = old_lines[i]
        if l.lstrip().startswith("### "):
            break
        c = cells_of(l)
        if c and len(c) >= 4 and not l.strip().startswith("|---"):
            # name link is in column 1 (index 1)
            lm = link_re.match(c[1])
            if lm and lm.group(2) in apps:
                app_rows.append((lm.group(2), c[0], c[1], c[3]))
        i += 1

    PL = parse_possible_later(old_lines)
    if not PL:
        # Working-tree section missing or empty (e.g. clobbered by a previous
        # broken regen): recover the backlog from the committed README.
        head = run(["git", "show", "HEAD:README.md"])
        if head:
            PL = parse_possible_later(head.splitlines())

    # Backlog, Quick PenTest, Best Practice, References verbatim
    # Stop QUICK at Collection Status/Guides if they appear before Best Practice
    jc = "\n".join(old_lines)
    qb = jc.find("### Backlog / not added")
    qp = jc.find("### Quick PenTest", qb)
    cs = jc.find("## Collection Status", qp)
    gr = jc.find("## Guides & Runbooks", qp)
    bp = jc.find("## Best Practice Start-Up", qp)
    # Use the earliest section marker after Quick PenTest
    quick_end = min(x for x in [cs, gr, bp] if x >= 0)
    rf = jc.find("## References", quick_end)
    BACKLOG = jc[qb:qp].rstrip() + "\n\n" if qb >= 0 else ""
    QUICK = jc[qp:quick_end].rstrip() if qp >= 0 and quick_end >= 0 else ""
    QUICK = QUICK.replace(
        "[README](./composer/sys-tools/termix/README.md)", "- (not added yet)"
    )
    BEST = jc[bp:rf].rstrip() if bp >= 0 and rf >= 0 else ""
    REF = jc[rf:].rstrip() if rf >= 0 else ""

    return app_rows, PL, BACKLOG, QUICK, BEST, REF, header


# ----- table formatting -----
# Tables are emitted unpadded (`| a | b |`). The repo runs prettier over
# markdown, which re-pads every table cell to align the columns - so any width
# computed here is thrown away on the next pre-commit run, and a padded writer
# guarantees a large cosmetic diff on every regeneration. Compact output makes
# the generator idempotent modulo prettier.
DASH = "-"  # the "no value" marker


def md_row(*cells):
    return "| " + " | ".join(str(c) for c in cells) + " |"


def md_table(headers, rows):
    out = [md_row(*headers), md_row(*["---"] * len(headers))]
    out.extend(md_row(*r) for r in rows)
    return out


def fmt_last(d):
    return d[:7] if d else DASH


def fmt_status(v, name=None):
    s = f"{EMOJI[v[2]]} {v[2]}"
    if name in UNFEATURED:
        s += " " + PIN_MARK
    return s


def fmt_tpl(v):
    return TPL_DISP[v[3]]


def build_table(app_rows, apps, title, note, include_template=True):
    headers = PL_HEADER
    rows = []
    # The template itself is a live, maintained artifact - it only belongs in
    # the "Current & Maintained" table, not repeated in the second one.
    if include_template:
        rows.append(
            [
                "**\\_\\_template**",
                "",
                "",
                "",
                "",
                "",
                "",
            ]
        )
        rows.append(
            [
                "Configuration",
                "[README](./__template/README.md)",
                DASH,
                "Base configuration and templates for Docker Swarm with Traefik.",
                DASH,
                DASH,
                DASH,
            ]
        )
    cur = None
    for name, typ, ncell, desc in app_rows:
        v = apps[name]
        if v[0] != cur:
            rows.append([f"**{v[0]}**", "", "", "", "", "", ""])
            cur = v[0]
        rows.append(
            [
                typ,
                ncell,
                v[4] or DASH,
                desc,
                fmt_last(v[1]),
                fmt_status(v, name),
                fmt_tpl(v),
            ]
        )
    return [title, "", note, ""] + md_table(headers, rows)


# ----- MAINTENANCE generation -----
def generate_maintenance(apps):
    def by_cat(cond):
        d = collections.defaultdict(list)
        for app, v in apps.items():
            if cond(app, v):
                d[v[0]].append(app)
        return d

    def total(d):
        return sum(len(v) for v in d.values())

    def lines_by(bucket):
        out = []
        for cat in sorted(bucket):
            out.append(
                f"- **{cat}** ({len(bucket[cat])}) - "
                + ", ".join(f"`{n}`" for n in bucket[cat])
            )
        return out

    active = by_cat(lambda a, v: v[2] == "up-to-date")
    stale_ = by_cat(lambda a, v: v[2] == "stale")
    older_ = by_cat(lambda a, v: v[2] == "older")
    bulk_only = by_cat(lambda a, v: v[2] == "bulk-only")
    archived = by_cat(lambda a, v: v[2] == "archived")
    no_tpl = by_cat(lambda a, v: v[3] == "no")
    part_tpl = by_cat(lambda a, v: v[3] == "partial")
    new_ = sorted(a for a, v in apps.items() if v[2] == "new")

    M = []
    M.append("# Maintenance & Stack Status")
    M.append("")
    M.append(
        "> Derived data (focused git history + compose anchor/image scan) - regenerate together with `README.md` via the generator script. Dockerfile-only changes and repository-wide sweeps touching at least six stacks do not count as focused maintenance."
    )
    M.append("")
    M.append("| status | meaning |")
    M.append(
        "| ------ | ----------------------------------------------------------------- |"
    )
    M.append("| \U0001f7e2 `up-to-date` | focused stack change ≤ ~4 months ago |")
    M.append("| \U0001f7e1 `older` | focused stack change ~4–12 months ago |")
    M.append("| \U0001f534 `stale` | no focused stack change for > ~1 year |")
    M.append("| \U0001f7e0 `bulk-only` | only touched by repository-wide sweeps |")
    M.append("| ⚫ `archived` | upstream repository archived |")
    M.append("| \U0001f195 `new` | folder exists, not yet committed |")
    M.append("")
    M.append("## Unfeatured pins")
    M.append("")
    M.append(
        f"`{PIN_MARK}` stacks sit in the README's second table on purpose, although their git history says focused. `UNFEATURED` in `tools/readme_gen.py` holds them back: the newest focused commit was a bare `chore(deps): update <app> to version <X>` bump, which proves the tag was picked but not that the configs, anchors, probe and README still line up. Remove the entry after that review."
    )
    M.append("")
    if UNFEATURED:
        M.append("| stack | last focused change |")
        M.append("| ------ | -------------------- |")
        for app in sorted(UNFEATURED):
            M.append(f"| `{app}` | {apps[app][1] or '-'} |")
        M.append("")
    M.append("## At a glance")
    M.append("")
    M.append(f"### \U0001f7e2 {total(active)} stacks with focused maintenance")
    M.append("")
    M.extend(lines_by(active))
    M.append("")
    M.append(f"### \U0001f7e0 {total(bulk_only)} bulk-only - no focused commit")
    M.append("")
    M.extend(lines_by(bulk_only))
    M.append("")
    M.append(f"### ⚫ {total(archived)} archived upstream")
    M.append("")
    M.extend(lines_by(archived))
    M.append("")
    M.append(f"### \U0001f195 {len(new_)} new / in progress")
    M.append("")
    M.append(", ".join(f"`{n}`" for n in new_))
    M.append("")
    M.append(
        f"### \U0001f7e1 {total(older_)} older - still fine, bump versions next time you touch them"
    )
    M.append("")
    M.extend(lines_by(older_))
    M.append("")
    M.append(f"### \U0001f534 {total(stale_)} stale - review before (re)deploying")
    M.append("")
    M.extend(lines_by(stale_))
    M.append("")
    M.append("## Template alignment - needs attention")
    M.append("")
    M.append(
        "Stacks that deviate from the current `__template/` structure. Migrate when next touched: `no` = hand-rolled compose, `\u00b1` = older anchor style, `custom` = intentional documented deviation (pangolin)."
    )
    M.append("")
    M.append(f"### `no` (no __template anchors) - {total(no_tpl)} stacks")
    M.append("")
    M.extend(lines_by(no_tpl))
    M.append("")
    M.append(f"### `\u00b1` (partial, older 2-anchor style) - {total(part_tpl)} stacks")
    M.append("")
    M.extend(lines_by(part_tpl))
    M.append("")
    if UPSTREAM_ALERTS:
        M.append("## Upstream alerts")
        M.append("")
        for app, note in sorted(UPSTREAM_ALERTS.items()):
            M.append(f"- `{app}` - {note}")
        M.append("")
    M.append("## Version pins")
    M.append("")
    M.append(
        "`ver` in the index = the image tag pinned as the default in `docker-compose.yaml` (`${VERSION:-x}` or a literal tag). It is *not* a live upstream check; `-` means the stack pins `latest` or has no single app image."
    )
    M.append("")
    M.append("## Ideas / candidate bundles")
    M.append("")
    M.append(
        "- **Small-company base** (from existing stacks): pangolin (remote access) + goauthentik (SSO/2FA) + forgejo (git) + vaultwarden/bitwarden (passwords) + n8n (automation) + kestra/semaphore (CI) + beszel (monitoring) + paperless-ngx/nextcloud (docs) + freshrss/searxng (info)."
    )
    M.append("")
    M.append("## Regeneration")
    M.append("")
    M.append(
        "Run the generator after any stack change to refresh both `README.md` and this file:"
    )
    M.append("")
    M.append("```sh")
    M.append("python tools/readme_gen.py --write")
    M.append("```")
    M.append("")
    return "\n".join(M) + "\n"


# ----- main generation -----
def generate(apps, old_readme_path=None):
    if old_readme_path and os.path.exists(old_readme_path):
        old_lines = open(old_readme_path).read().splitlines()
    else:
        old_lines = open(README_PATH).read().splitlines()

    app_rows, PL, BACKLOG, QUICK, BEST, REF, header = parse_old_readme(old_lines, apps)

    # add EXTRA new stacks not in old index
    seen = {r[0] for r in app_rows}
    for name in sorted(apps):
        if name in seen or name not in EXTRA:
            continue
        typ, ncell, desc = EXTRA[name]
        cat = apps[name][0]
        app_rows.append((name, typ, ncell, desc))
    app_rows = [
        (name, typ, LINK_OVERRIDES.get(name, ncell), desc)
        for name, typ, ncell, desc in app_rows
    ]
    category_order = {
        category: index
        for index, category in enumerate(sorted(os.listdir(COMPOSER_DIR)))
    }
    app_rows.sort(key=lambda r: category_order.get(apps[r[0]][0], 999))

    # SPLIT by status: focused/new vs bulk-only/older/stale/archived.
    # FEATURED forces a stack up, UNFEATURED pins it down - the pins win, so a
    # stale FEATURED entry can never fight an explicit UNFEATURED one.
    table_a_rows = []  # up-to-date + new (+ featured)
    table_b_rows = []  # everything else (+ unfeatured)
    for name, typ, ncell, desc in app_rows:
        v = apps[name]
        if name in UNFEATURED:
            table_b_rows.append((name, typ, ncell, desc))
        elif v[2] in ("up-to-date", "new") or name in FEATURED:
            table_a_rows.append((name, typ, ncell, desc))
        else:
            table_b_rows.append((name, typ, ncell, desc))

    # Table A: Current & Maintained (green + new)
    idx_a = build_table(
        table_a_rows,
        apps,
        "## Index - Current & Maintained (\U0001f7e2 focused, \U0001f195 new)",
        NOTE_INDEX,
    )

    # Table B: Bulk-only / Older / Archived
    idx_b = build_table(
        table_b_rows,
        apps,
        "## Index - Bulk-only / Older / Archived (\U0001f7e0 bulk-only, \U0001f7e1 older, \U0001f534 stale, ⚫ archived)",
        NOTE_INDEX
        + " Rows marked "
        + PIN_MARK
        + " are pinned here by `UNFEATURED` in `tools/readme_gen.py`: their git history says "
        + "*focused*, but the last touch was a version bump without a config/probe re-check.",
        include_template=False,
    )

    # POSSIBLE LATER table - hand-maintained data, carried over verbatim
    pl = [
        "",
        "### POSSIBLE LATER",
        "",
        "Backlog of interesting stacks that are candidates but **not (yet)** added as a full collection folder. To adopt one, cut/paste its row into the right **topic** group above and add the folder under `composer/`. Rows here are preserved verbatim by the generator.",
        "",
    ]
    pl.extend(
        md_table(
            PL_HEADER,
            [[typ, ncell, DASH, desc, DASH, DASH, DASH] for typ, ncell, desc in PL],
        )
    )
    pl.append("")

    # status section
    status_sec = [
        "",
        "## Collection Status",
        "",
        "`up-to-date` means a focused stack change in the last ~4 months. Dockerfile-only changes and repository-wide commits touching at least six stacks are not counted as focused maintenance.",
        "",
        "| column   | meaning |",
        "| -------- | ------------------------------------------------------------ |",
        "| `ver`    | image tag pinned as default in `docker-compose.yaml` (- = `latest`/unpinned) |",
        "| `last`   | `YYYY-MM` of the most recent focused stack change |",
        "| `status` | \U0001f7e2 focused \u2264 ~4 months \u00b7 \U0001f7e1 older ~4\u201312 months \u00b7 \U0001f534 stale > ~1 year \u00b7 \U0001f7e0 bulk-only \u00b7 \u26ab archived \u00b7 \U0001f195 new |",
        "| `tpl`    | matches `__template/`: `yes` \u00b7 `\u00b1` partial \u00b7 `no` hand-rolled \u00b7 `custom` |",
        "",
        f"> {PIN_MARK} **unfeatured** - listed in the second table on purpose. A `chore(deps): update <app> to version <X>` commit counts as a focused change, so a pure version bump promotes a stack even though nothing was re-verified. Add the stack to `UNFEATURED` in [`tools/readme_gen.py`](./tools/readme_gen.py) to hold it back until the configs, anchors, probe and README were re-checked; remove the entry after that review.",
        "",
        "> \U0001f534 `stale` does **not** mean broken - many of these still run fine. It flags stacks without a focused commit for over a year that deserve a review/version bump before (re)use.",
        "",
        "## Guides & Runbooks",
        "",
        "- **Pangolin + Authentik SSO** - [`docs/RUNBOOK-pangolin.md`](./docs/RUNBOOK-pangolin.md): full zero-trust remote-access infra (Pangolin on Hetzner, Authentik + Newt in the company).",
        "- **Base template** - [`__template/`](./__template/README.md) is the canonical skeleton for new stacks (anchors `basic-deploy-labels`, `basic-deploy`, `basic`).",
    ]

    final = list(header)
    final.append("")
    final.append("---")
    final.append("")
    final.extend(idx_a)
    final.append("")
    final.extend(idx_b)
    final.extend(pl)
    final.append(BACKLOG)
    final.append(QUICK)
    final.extend(status_sec)
    final.append("")
    final.append(BEST)
    final.append("")
    final.append(REF)
    final.append("")

    # NOTE: no global character substitutions here. The hand-owned blocks
    # (POSSIBLE LATER rows, Backlog, Quick PenTest, Best Practice, References)
    # are carried over verbatim, so a blanket replace()/sub() would silently
    # rewrite the user's text on every run - exactly the class of bug that used
    # to wipe the POSSIBLE LATER section.
    result = "\n".join(final)
    result = re.sub(r"\n{3,}", "\n\n", result)
    return result


# ----- sync check -----
def check_sync(apps):
    """Verify composer/ folders match README index rows."""
    old_lines = open(README_PATH).read().splitlines()
    app_rows, _, _, _, _, _, _ = parse_old_readme(old_lines, apps)

    # Build set of apps in README index
    readme_apps = {r[0] for r in app_rows}
    composer_apps = set(apps.keys())

    missing_in_readme = composer_apps - readme_apps
    extra_in_readme = readme_apps - composer_apps

    # Print report
    print(f"Composer folders: {len(composer_apps)}")
    print(f"README index rows: {len(readme_apps)}")
    if missing_in_readme:
        print(
            f"MISSING in README (in composer but not in index): {sorted(missing_in_readme)}"
        )
    else:
        print("OK: All composer folders present in README index")
    if extra_in_readme:
        print(
            f"EXTRA in README (in index but no composer folder): {sorted(extra_in_readme)}"
        )
    else:
        print("OK: No extra rows in README index")

    # Green stacks whose newest focused commit was a bare version bump and that
    # are not pinned in UNFEATURED - promoted without a config re-check.
    unpinned = sorted(
        name
        for name, v in apps.items()
        if v[2] in ("up-to-date", "new") and v[5] and name not in UNFEATURED
    )
    if unpinned:
        print()
        print(
            f"UNVERIFIED ({len(unpinned)} promoted by a bare version bump). "
            "Add to UNFEATURED until configs/probe are re-checked:"
        )
        for name in unpinned:
            print(f"  - {name} (last focused change {apps[name][1] or 'n/a'})")
    else:
        print("OK: No bare version bump promoted an unpinned stack")

    ok = not missing_in_readme and not extra_in_readme
    ok = ok and not check_stale_pins(apps)
    ok = ok and not check_possible_later_roundtrip(apps)
    return ok


def check_possible_later_roundtrip(apps):
    """The POSSIBLE LATER section is hand-owned data.

    Regenerating must reproduce it exactly - this is the regression guard for
    the parser that silently dropped the whole section.
    """
    before = open(README_PATH).read().splitlines()
    rows = parse_possible_later(before)
    if not rows:
        head = run(["git", "show", "HEAD:README.md"])
        if head:
            rows = parse_possible_later(head.splitlines())
    if not rows:
        print("POSSIBLE LATER: empty (nothing to preserve)")
        return False
    after = generate(apps, README_PATH).splitlines()
    again = parse_possible_later(after)
    if again == rows:
        print(f"OK: POSSIBLE LATER round-trips ({len(rows)} rows preserved)")
        return False
    print(
        f"POSSIBLE LATER MISMATCH: {len(rows)} rows in README, "
        f"{len(again)} after regeneration"
    )
    for i, (a, b) in enumerate(zip(rows, again)):
        if a != b:
            print(f"  first difference at row {i}: {a!r} != {b!r}")
            break
    return True


def check_stale_pins(apps):
    """Warn about FEATURED/UNFEATURED entries that no longer have a folder."""
    bad = False
    for label, pins in (("FEATURED", FEATURED), ("UNFEATURED", UNFEATURED)):
        unknown = sorted(p for p in pins if p not in apps)
        if unknown:
            print(f"STALE {label} entries (no composer folder): {unknown}")
            bad = True
    overlap = sorted(FEATURED & UNFEATURED)
    if overlap:
        print(f"CONFLICT: listed in both FEATURED and UNFEATURED: {overlap}")
        bad = True
    if not bad:
        print("OK: FEATURED/UNFEATURED pins all resolve to a composer folder")
    return bad


# ----- CLI -----
def main():
    parser = argparse.ArgumentParser(
        description="Generate README.md + MAINTENANCE.md for vm-docker-collection"
    )
    parser.add_argument(
        "--write", action="store_true", help="Write README.md and MAINTENANCE.md"
    )
    parser.add_argument(
        "--check", action="store_true", help="Verify index↔composer sync"
    )
    args = parser.parse_args()

    if not args.write and not args.check:
        parser.print_help()
        return 1

    apps = scan_composer()

    if args.check:
        ok = check_sync(apps)
        sys.exit(0 if ok else 1)

    if args.write:
        readme_content = generate(apps, README_PATH)
        maint_content = generate_maintenance(apps)
        open(README_PATH, "w").write(readme_content)
        open(MAINT_PATH, "w").write(maint_content)
        print(f"Wrote {README_PATH} ({readme_content.count(chr(10))} lines)")
        print(f"Wrote {MAINT_PATH} ({maint_content.count(chr(10))} lines)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
