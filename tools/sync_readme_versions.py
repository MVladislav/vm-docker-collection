#!/usr/bin/env python3
import argparse
import re
import sys
from collections import defaultdict
from pathlib import Path

VERSION_RE = re.compile(
    r"\$\{(?P<name>[A-Za-z_][A-Za-z0-9_]*):-(?P<value>(?:[^{}]|\$\{[^{}]*\})*)\}"
)
IMAGE_RE = re.compile(r"^\s*image:\s*(?P<image>[^#\n]*?)(?:\s+#.*)?$")
ROLLING_VALUES = {
    "latest",
    "master",
    "main",
    "edge",
    "rolling",
    "nightly",
    "continuous",
    "dev",
}


def compose_files(root):
    return sorted(root.rglob("docker-compose*.y*ml"))


def image_value(line):
    if line.lstrip().startswith("#"):
        return None
    match = IMAGE_RE.match(line)
    if not match:
        return None
    value = match.group("image").strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in "'\"":
        value = value[1:-1]
    return value


def project_variables(paths):
    values = defaultdict(set)
    locations = defaultdict(list)
    for path in paths:
        for line_number, line in enumerate(path.read_text().splitlines(), 1):
            image = image_value(line)
            if not image:
                continue
            for match in VERSION_RE.finditer(image):
                name = match.group("name")
                if name == "VERSION" or name.startswith("VERSION_"):
                    values[name].add(match.group("value"))
                    locations[name].append(f"{path}:{line_number}")
    return values, locations


def assignment_pattern(name):
    return re.compile(
        rf"^(?P<prefix>[ \t]*(?:export[ \t]+)?{re.escape(name)}[ \t]*=[ \t]*)"
        rf"(?P<value>[^\s#]+)(?P<suffix>[ \t]*(?:#.*)?)$",
        re.MULTILINE,
    )


def update_readme(path, name, expected, text=None):
    text = path.read_text() if text is None else text
    pattern = assignment_pattern(name)
    matches = list(pattern.finditer(text))
    if not matches:
        return text, 0, []
    old_values = []
    for match in matches:
        old_values.append(match.group("value"))
    if all(value == expected for value in old_values):
        return text, 0, old_values
    updated = pattern.sub(
        lambda match: match.group("prefix") + expected + match.group("suffix"), text
    )
    return updated, len(matches), old_values


def relative(path, root):
    try:
        return str(path.relative_to(root))
    except ValueError:
        return str(path)


def main():
    parser = argparse.ArgumentParser(description="Sync README Compose version examples")
    parser.add_argument("root", nargs="?", default=".", help="repository root")
    parser.add_argument(
        "--write", action="store_true", help="update existing README assignments"
    )
    args = parser.parse_args()
    root = Path(args.root).resolve()
    paths = compose_files(root)
    projects = defaultdict(list)
    for path in paths:
        projects[path.parent].append(path)

    totals = defaultdict(int)
    messages = []
    for project, project_paths in sorted(projects.items()):
        values, locations = project_variables(project_paths)
        if not values:
            continue
        readme = project / "README.md"
        project_name = relative(project, root)
        if not readme.is_file():
            messages.append(f"MISSING README {project_name}")
            totals["missing_readme"] += 1
            continue
        readme_text = readme.read_text()
        changed = False
        for name in sorted(values):
            candidates = values[name]
            if len(candidates) != 1:
                messages.append(
                    f"CONFLICT {project_name} {name}: {', '.join(sorted(candidates))}"
                )
                totals["conflicts"] += 1
                continue
            expected = next(iter(candidates))
            if expected in ROLLING_VALUES or "${" in expected:
                messages.append(
                    f"SKIP {project_name} {name}={expected} (rolling or nested default)"
                )
                totals["skipped"] += 1
                continue
            pattern = assignment_pattern(name)
            matches = list(pattern.finditer(readme_text))
            if not matches:
                messages.append(f"MISSING {project_name} {name}={expected}")
                totals["missing"] += 1
                continue
            old_values = [match.group("value") for match in matches]
            totals["aligned"] += 1
            if all(value == expected for value in old_values):
                continue
            totals["changed"] += 1
            changed = True
            if args.write:
                readme_text, count, _ = update_readme(
                    readme, name, expected, readme_text
                )
                messages.append(
                    f"UPDATE {project_name} {name}: {', '.join(old_values)} -> {expected} ({count} occurrence(s))"
                )
            else:
                messages.append(
                    f"CHECK {project_name} {name}: {', '.join(old_values)} -> {expected}"
                )
        if args.write and changed:
            readme.write_text(readme_text)

    for message in messages:
        print(message)
    print()
    print(f"Projects scanned: {len(projects)}")
    print(f"Compose files: {len(paths)}")
    print(f"Aligned variables: {totals['aligned']}")
    print(f"Changed variables: {totals['changed']}")
    print(f"Missing README assignments: {totals['missing']}")
    print(f"Missing README files: {totals['missing_readme']}")
    print(f"Conflicting Compose values: {totals['conflicts']}")
    print(f"Skipped rolling/nested defaults: {totals['skipped']}")
    if args.write and totals["changed"]:
        print()
        print("Suggested commit message:")
        print("chore(docs): sync stack README versions with Compose defaults")
    elif not args.write:
        print()
        print(
            "Dry run only. Re-run with --write to update existing README assignments."
        )
    return 1 if totals["conflicts"] or totals["missing_readme"] else 0


if __name__ == "__main__":
    sys.exit(main())
