#!/usr/bin/env python3
"""
Development -> Production question promotion export (Faz D).

Reads an EXPLICIT list of development `question.id` values (never a blanket
"export everything PUBLISHED" query -- that is a deliberate choice, see
docs/known-constraints.md "Faz D") and generates a single Flyway migration
file that INSERTs those exact questions + options into whatever database the
migration is later applied to (dev again, or -- via a normal app deploy,
never this script -- production).

This script NEVER connects to production. It only reads from the
DEVELOPMENT database (connection settings below, matching this project's own
docker-compose.yml dev setup) and only WRITES a plain .sql file under
src/main/resources/db/migration/question-promotion/. Nothing it does can
reach a production database, by construction: it never reads the
DB_URL/DB_USERNAME/DB_PASSWORD environment variable names application-prod.yml
uses, and it contains no code path that opens any network connection other
than the one explicit `psql` call against the source (dev) database below.

Usage:
    scripts/export_approved_questions.py 101 102 103
    scripts/export_approved_questions.py --name enum-batch-1 101 102 103
    scripts/export_approved_questions.py --stdout-only 101 102 103

Only PUBLISHED questions may be exported -- PENDING_REVIEW/REJECTED/DRAFT
cause the whole run to abort with a clear error (never a silent skip), since
this tool is meant to promote a batch a human has already reviewed and
explicitly chosen by ID, and a status mismatch almost always means the wrong
ID was typed.
"""
import argparse
import json
import os
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
MIGRATION_ROOT = REPO_ROOT / "src" / "main" / "resources" / "db" / "migration"
PROMOTION_SUBDIR = MIGRATION_ROOT / "question-promotion"

# Deliberately distinct names from the DB_URL/DB_USERNAME/DB_PASSWORD env vars
# application-prod.yml reads -- this script must never be able to pick up
# production credentials, even by accident, even if someone exports those
# variables in their shell for an unrelated reason. Defaults match this
# project's own docker-compose.yml (dev-only, checked into the repo).
SOURCE_DB_HOST = os.environ.get("EXPORT_SOURCE_DB_HOST", "localhost")
SOURCE_DB_PORT = os.environ.get("EXPORT_SOURCE_DB_PORT", "5433")
SOURCE_DB_NAME = os.environ.get("EXPORT_SOURCE_DB_NAME", "learning")
SOURCE_DB_USER = os.environ.get("EXPORT_SOURCE_DB_USER", "learning")
SOURCE_DB_PASSWORD = os.environ.get("EXPORT_SOURCE_DB_PASSWORD", "learning")


class ExportError(Exception):
    pass


def fetch_question(question_id: int) -> dict:
    """Reads ONE question + its options from the source (dev) DB as JSON.
    Read-only SELECT; never writes anything."""
    query = f"""
        SELECT row_to_json(t) FROM (
            SELECT q.id, top.slug AS topic_slug, q.language, q.type, q.difficulty,
                   q.status, q.source, q.question, q.code_snippet, q.code_language,
                   q.explanation, q.reviewed_by, q.reviewed_at::text AS reviewed_at,
                   (SELECT json_agg(json_build_object(
                            'option_text', o.option_text,
                            'correct', o.is_correct,
                            'sort_order', o.sort_order
                        ) ORDER BY o.sort_order)
                    FROM question_option o WHERE o.question_id = q.id) AS options
            FROM question q
            JOIN topic top ON top.id = q.topic_id
            WHERE q.id = {int(question_id)}
        ) t;
    """
    env = dict(os.environ)
    env["PGPASSWORD"] = SOURCE_DB_PASSWORD
    result = subprocess.run(
        ["psql", "-h", SOURCE_DB_HOST, "-p", SOURCE_DB_PORT, "-U", SOURCE_DB_USER,
         "-d", SOURCE_DB_NAME, "-t", "-A", "-c", query],
        env=env, capture_output=True, text=True, check=False,
    )
    if result.returncode != 0:
        raise ExportError(f"could not query source (dev) database: {result.stderr.strip()}")

    raw = result.stdout.strip()
    if not raw:
        raise ExportError(f"question id {question_id} was not found in the source (dev) database")

    return json.loads(raw)


def sql_string(value) -> str:
    if value is None:
        return "NULL"
    escaped = str(value).replace("'", "''")
    return f"'{escaped}'"


def render_question_sql(q: dict) -> str:
    dev_id = q["id"]
    cte_name = f"new_question_{dev_id}"

    options = q.get("options") or []
    if not options:
        raise ExportError(f"question id {dev_id} has no options -- refusing to promote an incomplete question")

    option_rows = "\n    UNION ALL ".join(
        f"SELECT id, {sql_string(o['option_text'])}, "
        f"{'TRUE' if o['correct'] else 'FALSE'}, {int(o['sort_order'])} FROM {cte_name}"
        for o in options
    )

    return f"""-- Dev question id {dev_id} (topic: {q['topic_slug']}, language: {q['language']})
WITH {cte_name} AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, {sql_string(q['language'])}, {sql_string(q['type'])}, {sql_string(q['difficulty'])},
           'PUBLISHED', {sql_string(q['source'])},
           {sql_string(q['question'])}, {sql_string(q['code_snippet'])}, {sql_string(q['code_language'])},
           {sql_string(q['explanation'])}, {sql_string(q['reviewed_by'])}, {sql_string(q['reviewed_at'])},
           now(), now()
    FROM topic WHERE slug = {sql_string(q['topic_slug'])}
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    {option_rows};
"""


def next_migration_version() -> int:
    highest = 0
    for path in MIGRATION_ROOT.rglob("V*.sql"):
        m = re.match(r"V(\d+)__", path.name)
        if m:
            highest = max(highest, int(m.group(1)))
    return highest + 1


def build_migration(question_ids: list[int], name_suffix: str) -> tuple[str, str]:
    questions = []
    for qid in question_ids:
        q = fetch_question(qid)
        if q["status"] != "PUBLISHED":
            raise ExportError(
                f"question id {qid} is {q['status']}, not PUBLISHED -- only explicitly "
                f"reviewed+PUBLISHED development questions may be exported. Aborting the "
                f"whole batch (no partial output) so a wrong id doesn't get silently skipped."
            )
        questions.append(q)

    generated_at = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC")
    ids_csv = ", ".join(str(q["id"]) for q in questions)
    header = f"""-- Promotion batch
-- Development Question IDs: {ids_csv}
-- Generated: {generated_at}
-- All questions were PUBLISHED and ADMIN-reviewed in development.
--
-- These development IDs are DOCUMENTATION/PROVENANCE ONLY -- no development id
-- is used as a foreign key value anywhere below. topic_id is resolved by
-- Topic.slug (globally unique, stable across environments); question_option
-- rows reference the newly generated id of the INSERT immediately above them
-- via a WITH ... RETURNING id CTE, so this migration is correct regardless of
-- what this environment's own auto-generated ids turn out to be.
--
-- Duplicate-promotion safety (bkz. docs/known-constraints.md "Faz D"): this
-- project intentionally has no promoted_at column or unique constraint yet --
-- before writing a NEW promotion migration, grep existing
-- db/migration/question-promotion/*.sql header comments for these same
-- Development Question IDs to confirm they were not already promoted.

"""
    body = "\n".join(render_question_sql(q) for q in questions)

    version = next_migration_version()
    slug = name_suffix or "batch"
    filename = f"V{version}__promote_questions_{slug}.sql"
    return filename, header + body


def main():
    parser = argparse.ArgumentParser(
        description="Export an explicit batch of PUBLISHED dev questions into a Flyway promotion migration.")
    parser.add_argument("question_ids", nargs="+", type=int,
                         help="Development question.id values to promote (explicit list, required)")
    parser.add_argument("--name", default="", help="Short slug appended to the migration filename")
    parser.add_argument("--stdout-only", action="store_true",
                         help="Print the generated SQL without writing a migration file")
    args = parser.parse_args()

    try:
        filename, sql = build_migration(args.question_ids, args.name)
    except ExportError as e:
        print(f"ERROR: {e}", file=sys.stderr)
        sys.exit(1)

    print(sql)

    if args.stdout_only:
        print(f"# --stdout-only: no file written (would have been {filename})", file=sys.stderr)
        return

    PROMOTION_SUBDIR.mkdir(parents=True, exist_ok=True)
    out_path = PROMOTION_SUBDIR / filename
    if out_path.exists():
        print(f"ERROR: {out_path} already exists -- refusing to overwrite", file=sys.stderr)
        sys.exit(1)
    out_path.write_text(sql)
    print(f"# Wrote {out_path.relative_to(REPO_ROOT)}", file=sys.stderr)
    print(f"# Promoted dev question ids: {', '.join(str(i) for i in args.question_ids)}", file=sys.stderr)


if __name__ == "__main__":
    main()
