#!/usr/bin/env python3
"""Freeze the Compose `VERSION*` image pins into each stack's local `.env`.

For every project (a folder holding `docker-compose*.y*ml`) that already has a
`.env` file, this tool collects the `VERSION*` variables used in an *active*
`image:` pin, takes the current Compose default and writes it as an assignment
into that project's `.env`:

    image: app:${VERSION:-1.2.3}   ->   VERSION=1.2.3

Why: a `.env` assignment outranks the Compose default, so once the value is
written there a newer default pulled from upstream no longer changes the
deployed version. The stack stays frozen at the value captured here until the
assignment is edited by hand. This is deliberately a *manual* tool - it is not
wired into pre-commit and should not be, otherwise it would silently adopt every
upstream bump (the opposite of freezing).

Only projects with an existing `.env` are considered; the tool never creates
one. Only active (non-commented) `image:` pins count, because a commented-out
service variant cannot be reached by `.env` interpolation. Nested defaults
(`${A:-${B:-}x}`) carry no single value and are skipped.

Findings
--------
PIN      Compose pins `NAME=value`, `.env` has no active assignment yet (--write adds it)
UPDATE   `.env` has `NAME=old`, Compose now pins `value`   (--write rewrites it)
STALE    `.env` has a `VERSION*` assignment no Compose file reads (manual)
CONFLICT the Compose files of one project pin the same name to different values (manual)

Exit code is 1 while a dry-run still has PIN/UPDATE/STALE/CONFLICT work,
so it can gate a review. With --write, applied changes are not failures; only
findings left for a human keep the exit code at 1.
"""

import argparse
import re
import sys
from collections import defaultdict
from pathlib import Path

# `${NAME:-default}` where the default may itself contain a single `${...}` group.
VERSION_RE = re.compile(
    r"\$\{(?P<name>[A-Za-z_][A-Za-z0-9_]*):-(?P<value>(?:[^{}]|\$\{[^{}]*\})*)\}"
)
IMAGE_RE = re.compile(r"^\s*image:\s*(?P<image>[^#\n]*?)(?:\s+#.*)?$")
COMMENTED_IMAGE_RE = re.compile(r"^\s*#+\s*image:\s*(?P<image>[^#\n]*?)(?:\s+#.*)?$")
VERSION_NAME_RE = re.compile(r"^VERSION(_[A-Z0-9_]+)?$")
# A `NAME=value` line, optionally `export`ed and optionally commented out.
ENV_ASSIGN_RE = re.compile(
    r"^(?P<indent>[ \t]*)(?P<comment>#+[ \t]*)?(?:export[ \t]+)?"
    r"(?P<name>[A-Za-z_][A-Za-z0-9_]*)[ \t]*=(?P<rest>[^\n]*)$"
)
# `value`, optionally quoted, plus an optional trailing `# comment`.
ENV_VALUE_RE = re.compile(
    r"^[ \t]*(?P<q>[\"']?)(?P<value>[^\s#]*)(?P=q)[ \t]*(?P<suffix>#.*)?$"
)


def compose_files(root):
    return sorted(root.rglob("docker-compose*.y*ml"))


def unquote(value):
    value = value.strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in "'\"":
        return value[1:-1]
    return value


def image_value(line):
    """Return (image_reference, is_commented) for a Compose `image:` line."""
    commented = COMMENTED_IMAGE_RE.match(line)
    if commented:
        return unquote(commented.group("image")), True
    match = IMAGE_RE.match(line)
    if not match:
        return None, False
    return unquote(match.group("image")), False


def collect_pins(paths):
    """Collect the active `VERSION*` pins of one project.

    Returns `(active, commented, order)` where `active` maps a name to the set
    of values pinned in a deployed `image:` line, `commented` maps a name to the
    values only seen in a commented-out variant, and `order` is the first-seen
    order of the names, used to keep newly written assignments in Compose order.
    """
    active = defaultdict(set)
    commented = defaultdict(set)
    order = []
    for path in paths:
        for line in path.read_text(encoding="utf-8", errors="replace").splitlines():
            image, is_commented = image_value(line)
            if not image:
                continue
            for match in VERSION_RE.finditer(image):
                name = match.group("name")
                if not VERSION_NAME_RE.match(name):
                    continue
                if name not in order:
                    order.append(name)
                bucket = commented if is_commented else active
                bucket[name].add(match.group("value"))
    return active, commented, order


def env_assignments(text):
    """Map a `.env` variable name to its parsed assignment entries.

    Each entry records the value and whether the line was commented out, so a
    commented `# VERSION=...` override is never mistaken for a live pin.
    """
    assignments = defaultdict(list)
    for line in text.splitlines():
        match = ENV_ASSIGN_RE.match(line)
        if not match:
            continue
        name = match.group("name")
        if not VERSION_NAME_RE.match(name):
            continue
        value_match = ENV_VALUE_RE.match(match.group("rest"))
        if not value_match:
            continue
        assignments[name].append(
            {
                "value": value_match.group("value"),
                "commented": bool(match.group("comment")),
            }
        )
    return assignments


def rewrite_env_value(text, name, expected):
    """Set every `.env` line of `name` to `NAME=expected`, keeping its comment.

    Only the value token is replaced; indentation, an `export` prefix, an
    optional quote pair and a trailing `# comment` all survive the rewrite.
    """
    pattern = re.compile(
        rf"^(?P<prefix>[ \t]*(?:#+[ \t]*)?(?:export[ \t]+)?{re.escape(name)}[ \t]*=[ \t]*)"
        rf"(?:(?P<q>[\"'])[^\"'#\n]*(?P=q)|[^\s#]*)(?P<suffix>[ \t]*(?:#.*)?)$",
        re.MULTILINE,
    )
    return pattern.sub(
        lambda match: f"{match.group('prefix')}{expected}{match.group('suffix')}", text
    )


def insert_env_lines(text, names):
    """append a `NAME=value`-style block for `names`, grouped with existing ones.

    The lines are placed right after the last existing `VERSION*` assignment
    (active or commented) so versions stay together; otherwise they go at the
    end of the file. `names` is a list of pre-rendered `NAME=value` strings.
    """
    lines = text.splitlines()
    insert_at = len(lines)
    for index, line in enumerate(lines):
        match = ENV_ASSIGN_RE.match(line)
        if match and VERSION_NAME_RE.match(match.group("name")):
            insert_at = index + 1
    if insert_at == len(lines) and lines and lines[-1].strip():
        lines.append("")
        insert_at = len(lines)
    lines[insert_at:insert_at] = names
    return "\n".join(lines) + "\n"


def is_read_by_compose(name, compose_text):
    return re.search(rf"\b{re.escape(name)}\b", compose_text) is not None


class Report:
    def __init__(self):
        self.lines = []
        self.totals = defaultdict(int)

    def add(self, level, project, message):
        self.lines.append(f"{level:<8} {project} {message}")
        self.totals[level.lower()] += 1

    def applied(self, project, message):
        self.lines.append(f"{'APPLIED':<8} {project} {message}")
        self.totals["applied"] += 1

    @property
    def manual(self):
        """Findings a write cannot fix."""
        return sum(self.totals[level] for level in ("stale", "conflict"))

    @property
    def pending(self):
        """Changes a dry-run would apply plus the findings a write cannot fix."""
        return self.totals["pin"] + self.totals["update"] + self.manual


def main():
    parser = argparse.ArgumentParser(
        description="Freeze Compose VERSION pins into each stack's local .env",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("root", nargs="?", default=".", help="repository root")
    parser.add_argument(
        "--write",
        action="store_true",
        help="write the collected pins into each .env in place",
    )
    parser.add_argument(
        "--only-missing",
        action="store_true",
        help="with --write, add names a .env does not have yet but never "
        "overwrite an existing assignment (keeps a frozen value)",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="also list aligned pins, commented-only variants and would-be additions",
    )
    args = parser.parse_args()
    root = Path(args.root).resolve()

    projects = defaultdict(list)
    for path in compose_files(root):
        projects[path.parent].append(path)

    report = Report()
    considered = 0
    for project, project_paths in sorted(projects.items()):
        env = project / ".env"
        project_name = str(project.relative_to(root))
        if not env.is_file():
            continue
        considered += 1
        active, commented, order = collect_pins(project_paths)
        order = sorted(order, key=lambda name: (name != "VERSION", name))
        compose_text = "\n".join(
            path.read_text(encoding="utf-8", errors="replace") for path in project_paths
        )
        if not active and not commented:
            continue
        env_text = env.read_text(encoding="utf-8", errors="replace")
        documented = env_assignments(env_text)
        to_add = []
        dirty = False
        added = updated = frozen = 0

        for name in order:
            if name not in active:
                # only present in a commented-out service variant; `.env` cannot
                # reach it, so it is not frozen
                report.totals["commented_only"] += 1
                if args.verbose:
                    report.lines.append(
                        f"{'SKIP':<8} {project_name} {name} (commented-out variant)"
                    )
                continue
            values = active[name]
            if len(values) > 1:
                report.add(
                    "CONFLICT",
                    project_name,
                    f"{name}: {', '.join(sorted(values))}",
                )
                continue
            expected = next(iter(values))
            if not expected or "${" in expected:
                report.add(
                    "SKIP",
                    project_name,
                    f"{name}={expected} (nested or empty default)",
                )
                continue
            entries = documented.get(name, [])
            live = [entry for entry in entries if not entry["commented"]]
            commented_entries = [entry for entry in entries if entry["commented"]]
            if commented_entries:
                report.totals["commented"] += len(commented_entries)
            if not live:
                if args.verbose:
                    report.lines.append(f"{'ADD':<8} {project_name} {name}={expected}")
                report.add("PIN", project_name, f"{name}={expected} (not in .env)")
                added += 1
                if args.write:
                    to_add.append(f"{name}={expected}")
                    dirty = True
                continue
            current = live[0]["value"]
            if current == expected:
                if args.verbose:
                    report.lines.append(
                        f"{'ALIGNED':<8} {project_name} {name}={expected}"
                    )
                report.totals["aligned"] += 1
                continue
            if args.only_missing:
                report.add(
                    "KEPT",
                    project_name,
                    f"{name}={current} kept, Compose now pins {expected} "
                    "(frozen by --only-missing)",
                )
                frozen += 1
                continue
            report.add("UPDATE", project_name, f"{name}: {current} -> {expected}")
            updated += 1
            if args.write:
                env_text = rewrite_env_value(env_text, name, expected)
                dirty = True

        for name in sorted(documented):
            if name in active or name in commented:
                continue
            if is_read_by_compose(name, compose_text):
                continue
            values = ", ".join(sorted({entry["value"] for entry in documented[name]}))
            report.add(
                "STALE",
                project_name,
                f"{name}={values} is in .env but no Compose file reads it",
            )

        if args.write and dirty:
            if to_add:
                env_text = insert_env_lines(env_text, to_add)
            env.write_text(env_text, encoding="utf-8")
            report.applied(
                project_name, f"{added} added, {updated} updated, {frozen} kept"
            )

    for line in report.lines:
        print(line)
    print()
    print(f"Projects with a .env: {considered}")
    if report.totals["commented"] or args.verbose:
        print(f"Commented VERSION assignments in .env: {report.totals['commented']}")
    if args.verbose and report.totals["commented_only"]:
        print(f"Skipped commented-out variants: {report.totals['commented_only']}")
    print(f"Aligned: {report.totals['aligned']}")
    if args.write and report.totals["applied"]:
        print(f"Files written: {report.totals['applied']}")
    print(f"New pins: {report.totals['pin']}")
    print(f"Updated pins: {report.totals['update']}")
    if args.only_missing and report.totals["kept"]:
        print(f"Frozen pins kept: {report.totals['kept']}")
    print(f"Stale .env assignments: {report.totals['stale']}")
    print(f"Conflicting Compose values: {report.totals['conflict']}")
    print()
    if args.write:
        if report.manual:
            print(
                f"{report.manual} finding(s) left for a human: drop the stale "
                "assignment or resolve the conflicting pin."
            )
            return 1
        print("Every collected VERSION pin is present in its .env.")
        return 0
    if report.pending:
        print(
            f"{report.pending} change(s) pending - re-run with --write to "
            "freeze them into .env."
        )
        return 1
    print("Every collected VERSION pin is present in its .env.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
