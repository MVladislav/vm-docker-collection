#!/usr/bin/env python3
"""Keep stack README `.env` examples aligned with the image pins in Compose.

For every project folder (a directory holding `docker-compose*.y*ml`) the tool
collects the `VERSION*` variables used in an `image:` reference, then compares
the pinned Compose default with the assignment documented in the project
`README.md`.

Findings
--------
UPDATE   README pins a different value than Compose  (fixed by --write)
BROKEN   README writes `NAME:-value` - a copy/paste of the Compose
         interpolation syntax that is not valid `.env`   (fixed by --write)
MISSING  Compose pins a version the README never documents
STALE    README documents a `VERSION*` variable no Compose file reads
CONFLICT the Compose files of one project pin the same name to different values
NOREF    project has Compose files but no `README.md`

Rolling defaults (`latest`, `main`, `master`, ...) and nested defaults
(`${OTHER:-x}`) carry no pinnable value and are only listed with `--verbose`.
Commented-out assignments are counted in the summary and listed with their
category (`optional override` or `commented-out service`) under `--verbose`.

Exit code is 1 while any finding is open, so the tool can gate a commit.
"""

import argparse
import re
import sys
from collections import defaultdict
from pathlib import Path

# `${NAME:-default}` where default may itself contain a single `${...}` group.
VERSION_RE = re.compile(
    r"\$\{(?P<name>[A-Za-z_][A-Za-z0-9_]*):-(?P<value>(?:[^{}]|\$\{[^{}]*\})*)\}"
)
IMAGE_RE = re.compile(r"^\s*image:\s*(?P<image>[^#\n]*?)(?:\s+#.*)?$")
# the same line commented out, e.g. `  # image: app:${VERSION:-1.2.3-alpine}`
COMMENTED_IMAGE_RE = re.compile(r"^\s*#+\s*image:\s*(?P<image>[^#\n]*?)(?:\s+#.*)?$")
# NAME=value, `export NAME=value` and the same forms commented out. The
# separator group also accepts the `:-` of Compose interpolation, which is how a
# malformed README example is recognised.
ASSIGNMENT_RE = re.compile(
    r"^(?P<indent>[ \t]*)"
    r"(?P<comment>#+[ \t]*)?"
    r"(?:export[ \t]+)?"
    r"(?P<name>[A-Za-z_][A-Za-z0-9_]*)"
    r"(?P<sep>[ \t]*[:=]-|=|:)"
    r"(?P<rest>[^\n]*)$"
)
VALUE_RE = re.compile(r"^(?P<value>[^\s#]+)(?P<suffix>[ \t]*(?:#.*)?)$")
VERSION_NAME_RE = re.compile(r"^VERSION(_[A-Z0-9_]+)?$")
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


def project_version_pins(paths):
    """Return (pins, compose_text) for one project.

    `pins` maps a `VERSION*` name to the set of defaults used inside an
    `image:` reference - the only place a pinnable default can live - split into
    `active` (the default a deployed stack gets) and `commented` (defaults of
    alternative images that are only present inside a commented-out block).
    `compose_text` is every project Compose file joined, used to tell a variable
    the stack still reads from one it has stopped using.
    """
    pins = defaultdict(lambda: {"active": set(), "commented": set()})
    texts = []
    for path in paths:
        text = path.read_text()
        texts.append(text)
        for line in text.splitlines():
            image, commented = image_value(line)
            if not image:
                continue
            for match in VERSION_RE.finditer(image):
                name = match.group("name")
                if VERSION_NAME_RE.match(name):
                    bucket = "commented" if commented else "active"
                    pins[name][bucket].add(match.group("value"))
    return pins, "\n".join(texts)


def is_read_by_compose(name, compose_text):
    """True when the project Compose files mention `name` as a whole word.

    A plain word search is deliberate: it also covers `build: args:` mapping keys
    and services that only exist inside a commented-out block, both of which are
    still documented knobs. Searching per name instead of collecting every
    `VERSION*` identifier up front keeps multi-underscore names such as
    `VERSION_NEXTCLOUD_CRON` exact - a `\\bVERSION(_[A-Z0-9]+)*\\b` scan only ever
    matched their first segment.
    """
    return re.search(rf"\b{re.escape(name)}\b", compose_text) is not None


def assignment_pattern(name):
    """A README `.env` line for `name`, with either `=` or the malformed `:-`.

    Both separators are matched so one substitution can normalise a line written
    as `NAME:-value` (Compose interpolation syntax pasted into an example) into a
    real `NAME=value` assignment.
    """
    return re.compile(
        rf"^(?P<prefix>[ \t]*(?:#+[ \t]*)?(?:export[ \t]+)?{re.escape(name)}[ \t]*)"
        rf"(?::-|=)[ \t]*(?P<value>[^\s#]+)(?P<suffix>[ \t]*(?:#.*)?)$",
        re.MULTILINE,
    )


def malformed_pattern(name):
    """Detect `NAME:-value` - Compose interpolation syntax in a `.env` example."""
    return re.compile(
        rf"^[ \t]*(?:#+[ \t]*)?(?:export[ \t]+)?{re.escape(name)}[ \t]*:-[ \t]*"
        rf"[^\s#]+[ \t]*(?:#.*)?$",
        re.MULTILINE,
    )


def rewrite_assignment(text, name, expected):
    """Set every `.env` line of `name` to `NAME=expected`.

    The trailing comment of the original line is preserved so an inline
    explanation such as `VERSION=1.2.3 # keep in sync` survives the sync.
    """
    return assignment_pattern(name).sub(
        lambda match: f"{match.group('prefix')}={expected}{match.group('suffix')}",
        text,
    )


def documented_assignments(readme_text):
    """Map every `NAME=value` / `#NAME=value` line in the README to its value."""
    assignments = defaultdict(list)
    for line in readme_text.splitlines():
        match = ASSIGNMENT_RE.match(line)
        if not match:
            continue
        name = match.group("name")
        if not VERSION_NAME_RE.match(name):
            continue
        value_match = VALUE_RE.match(match.group("rest"))
        if not value_match:
            continue
        assignments[name].append(
            {
                "value": value_match.group("value"),
                "commented": bool(match.group("comment")),
            }
        )
    return assignments


def relative(path, root):
    try:
        return str(path.relative_to(root))
    except ValueError:
        return str(path)


class Report:
    """Collects findings, keeps per-project order and renders the summary."""

    def __init__(self):
        self.lines = []
        self.skipped = []
        self.commented = []
        self.totals = defaultdict(int)

    def add(self, level, project, message):
        self.lines.append(f"{level:<8} {project} {message}")
        self.totals[level.lower()] += 1

    def fixed(self, project, message):
        self.lines.append(f"{'FIXED':<8} {project} {message}")
        self.totals["fixed"] += 1

    def skip(self, project, message):
        self.skipped.append(f"SKIP     {project} {message}")

    def comment(self, project, message):
        self.commented.append(f"COMMENT  {project} {message}")

    def add_commented(self, count):
        self.totals["commented"] += count

    @property
    def failures(self):
        return sum(
            self.totals[level]
            for level in ("update", "broken", "missing", "stale", "conflict", "noref")
        )


def main():
    parser = argparse.ArgumentParser(
        description="Sync stack README Compose version examples",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("root", nargs="?", default=".", help="repository root")
    parser.add_argument(
        "--write",
        action="store_true",
        help="rewrite stale and malformed README assignments in place",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="also list rolling/nested defaults that carry no pinnable value",
    )
    args = parser.parse_args()
    root = Path(args.root).resolve()
    paths = compose_files(root)
    projects = defaultdict(list)
    for path in paths:
        projects[path.parent].append(path)

    report = Report()
    for project, project_paths in sorted(projects.items()):
        pins, compose_text = project_version_pins(project_paths)
        if not pins and "VERSION" not in compose_text:
            continue
        readme = project / "README.md"
        project_name = relative(project, root)
        if not readme.is_file():
            report.add("NOREF", project_name, "no README.md for these Compose files")
            continue
        readme_text = readme.read_text()
        documented = documented_assignments(readme_text)
        # Counted straight from the parsed assignments, not from the comparison
        # loop, so a commented variable is still counted when it is rolling or
        # never appears in an `image:` line.
        report.add_commented(
            sum(1 for entries in documented.values() for e in entries if e["commented"])
        )
        dirty = False
        for name in sorted(pins):
            active = pins[name]["active"]
            alternatives = pins[name]["commented"]
            expected_set = active or alternatives
            if len(expected_set) > 1:
                report.add(
                    "CONFLICT",
                    project_name,
                    f"{name}: {', '.join(sorted(expected_set))}",
                )
                continue
            expected = next(iter(expected_set))
            if expected in ROLLING_VALUES or "${" in expected:
                report.skip(
                    project_name, f"{name}={expected} (rolling or nested default)"
                )
                continue
            if name not in documented:
                if not active:
                    # only pinned inside a commented-out service block: not part
                    # of the deployed stack, so need not be documented
                    report.skip(
                        project_name, f"{name}={expected} (commented-out service)"
                    )
                    continue
                report.add(
                    "MISSING",
                    project_name,
                    f"{name}={expected} is not documented in README.md",
                )
                continue
            # Partition the documented lines. A commented README assignment that
            # repeats a commented-out Compose alternative documents that variant,
            # it is not a stale value. A commented README assignment checked
            # against the *active* pin is an optional override - the knob is
            # only there to be uncommented.
            stale, alternatives_ok = [], []
            for entry in documented[name]:
                if entry["commented"] and entry["value"] in alternatives:
                    alternatives_ok.append(entry)
                else:
                    stale.append(entry)
            for entry in alternatives_ok:
                report.comment(
                    project_name,
                    f"{name}={entry['value']} (commented-out service variant)",
                )
            for entry in stale:
                if entry["commented"]:
                    report.comment(
                        project_name, f"{name}={entry['value']} (optional override)"
                    )
            if not stale:
                continue
            report.totals["aligned"] += 1
            malformed = malformed_pattern(name).search(readme_text)
            current = [entry["value"] for entry in stale]
            outdated = [value for value in current if value != expected]
            if not outdated and not malformed:
                continue
            comment = " (commented out)" if stale[0]["commented"] else ""
            if malformed:
                report.add(
                    "BROKEN",
                    project_name,
                    f"{name}: '{malformed.group(0).strip()}' uses ':-' "
                    "interpolation syntax instead of a .env assignment",
                )
            if outdated:
                report.add(
                    "UPDATE",
                    project_name,
                    f"{name}{comment}: {', '.join(outdated)} -> {expected}",
                )
            if args.write:
                readme_text = rewrite_assignment(readme_text, name, expected)
                dirty = True
                suffix = f"{comment}" if comment else ""
                report.fixed(project_name, f"{name} = {expected}{suffix}")
        for name in sorted(documented):
            if name in pins or is_read_by_compose(name, compose_text):
                continue
            values = ", ".join(sorted({entry["value"] for entry in documented[name]}))
            report.add(
                "STALE",
                project_name,
                f"{name}={values} is documented but no Compose file reads it",
            )
        if args.write and dirty:
            readme.write_text(readme_text)

    for line in report.lines:
        print(line)
    if args.verbose:
        for line in report.commented:
            print(line)
        for line in report.skipped:
            print(line)
    print()
    if args.verbose or report.totals["commented"]:
        print(f"Commented-out README assignments: {report.totals['commented']}")
    if args.verbose or report.skipped:
        print(f"Skipped rolling/nested defaults: {len(report.skipped)}")
    print(f"Projects scanned: {len(projects)}")
    print(f"Compose files: {len(paths)}")
    print(f"Aligned variables: {report.totals['aligned']}")
    if report.totals["fixed"]:
        print(f"Rewritten assignments: {report.totals['fixed']}")
    print(f"Outdated README assignments: {report.totals['update']}")
    print(f"Malformed README assignments: {report.totals['broken']}")
    print(f"Missing README assignments: {report.totals['missing']}")
    print(f"Stale README assignments: {report.totals['stale']}")
    print(f"Conflicting Compose values: {report.totals['conflict']}")
    print(f"Projects without README: {report.totals['noref']}")
    print()
    auto = report.totals["update"] + report.totals["broken"]
    manual = report.failures - auto
    if report.failures:
        parts = []
        if auto:
            parts.append(
                f"{auto} assignment(s) fixed"
                if args.write
                else f"{auto} outdated/malformed assignment(s) - re-run with --write"
            )
        if manual:
            parts.append(
                f"{manual} finding(s) left for a human: add the missing assignment, "
                "drop the stale one, or resolve the conflicting pin"
            )
        print("; ".join(parts) + ".")
        return 1
    print("All README version assignments match the Compose defaults.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
