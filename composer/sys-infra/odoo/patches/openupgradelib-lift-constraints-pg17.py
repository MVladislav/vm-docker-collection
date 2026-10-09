"""Make openupgradelib's lift_constraints() work on PostgreSQL >= 17.

Upstream: OCA/openupgradelib#462 (still an open draft, not in any release).
Verified on PostgreSQL 18, where an 18.0 -> 19.0 migration otherwise dies on
hr_recruitment with:

    psycopg2.errors.InvalidTableDefinition: column "id" is in a primary key

PostgreSQL 17+ catalogues NOT NULL as a named constraint
(<table>_<column>_not_null) and refuses to drop it while the column is still
inside a primary key. The upstream draft splits the combined ALTER TABLE into
one statement per constraint, which is necessary but NOT sufficient: dropping
the not-null constraint first still fails as a separate statement. Dropping
the primary/unique constraints first, then everything else, works.

Idempotent and non-fatal on purpose: it exits 0 when the fix is already
present, and also when the anchor cannot be found, so a future openupgradelib
release that fixes this upstream does not break the image build.
"""

import glob
import io
import os
import sys

OLD = '''    for table, constraints in cr.fetchall():
        cr.execute(
            "alter table %s drop constraint if exists %s",
            (
                AsIs(table),
                AsIs(
                    ", drop constraint if exists ".join(
                        (constraint if not cascade else (constraint + " cascade"))
                        for constraint in constraints
                    )
                ),
            ),
        )
'''

NEW = '''    for table, constraints in cr.fetchall():
        # LOCAL PATCH: see patches/openupgradelib-lift-constraints-pg17.py.
        # PostgreSQL 17+ refuses to drop a not-null constraint while the column
        # is still in a primary key, so drop primary/unique constraints first.
        cr.execute(
            "select c.conname from pg_constraint c "
            "join pg_class t on t.oid = c.conrelid "
            "where t.relname = %s and c.contype in ('p', 'u') "
            "and c.conname = any(%s)",
            (table, list(constraints)),
        )
        leading = [row[0] for row in cr.fetchall()]
        ordered = leading + [c for c in constraints if c not in leading]
        for constraint in ordered:
            cr.execute(
                "alter table %s drop constraint if exists %s",
                (AsIs(table), AsIs(constraint + " cascade" if cascade else constraint)),
            )
'''


def candidates():
    roots = [
        p
        for p in sys.path
        if p.endswith("site-packages") or p.endswith("dist-packages")
    ]
    paths = []
    for root in roots:
        paths.extend(glob.glob(os.path.join(root, "openupgradelib", "openupgrade.py")))
        paths.extend(glob.glob(os.path.join(root, "openupgradelib", "sql.py")))
    return paths


def main():
    paths = candidates()
    if not paths:
        print("lift-constraints patch: openupgradelib not found, skipping")
        return 0

    status = 0
    for path in paths:
        with io.open(path, encoding="utf-8") as fh:
            src = fh.read()
        if NEW in src:
            print("lift-constraints patch: already applied to %s" % path)
            continue
        if src.count(OLD) != 1:
            print(
                "lift-constraints patch: anchor found %d times in %s, skipping"
                % (src.count(OLD), path)
            )
            status = 0
            continue
        with io.open(path, "w", encoding="utf-8") as fh:
            fh.write(src.replace(OLD, NEW))
        print("lift-constraints patch: applied to %s" % path)
    return status


if __name__ == "__main__":
    sys.exit(main())