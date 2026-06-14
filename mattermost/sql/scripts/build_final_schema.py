#!/usr/bin/env python3
"""
Build final.sql with only CREATE statements (no ALTER, no DO $$ blocks).
Reads the combined migrations from final.sql and outputs the final schema.
Run from server/channels/db/migrations: python3 scripts/build_final_schema.py
"""
import re
import sys
from pathlib import Path
from typing import Optional

MIGRATIONS_DIR = Path(__file__).resolve().parent.parent
COMBINED_SQL = MIGRATIONS_DIR / "combined_migrations.sql"
FINAL_SQL = MIGRATIONS_DIR / "final.sql"


def strip_comments_and_blocks(content: str) -> str:
    """Remove comment lines and DO $$ ... $$ blocks so we can split by ; safely."""
    # Remove line comments (after DO blocks so we don't remove $$ inside comments)
    content = re.sub(r"--[^\n]*", "", content)
    # Remove DO $$ ... $$ blocks (non-greedy)
    content = re.sub(r"DO\s*\$\$.*?\$\$;", ";", content, flags=re.DOTALL)
    # Remove CALL ... ; and DROP PROCEDURE
    content = re.sub(r"call\s+create_attribute_view\s*\(\)\s*;", ";", content, flags=re.IGNORECASE)
    content = re.sub(r"DROP\s+PROCEDURE\s+create_attribute_view\s*\(\)\s*;", ";", content, flags=re.IGNORECASE)
    return content


def find_matching_paren(s: str, start: int) -> int:
    """Return index of closing paren for the open paren at start."""
    depth = 0
    i = start
    while i < len(s):
        if s[i] == "(":
            depth += 1
        elif s[i] == ")":
            depth -= 1
            if depth == 0:
                return i
        i += 1
    return -1


def parse_create_table(stmt: str) -> tuple[Optional[str], Optional[str]]:
    """Extract (table_name, column_list_body) from CREATE TABLE ... ( body );"""
    m = re.search(r"CREATE\s+TABLE\s+IF\s+NOT\s+EXISTS\s+(\w+)\s*\(", stmt, re.IGNORECASE)
    if not m:
        return None, None
    table = m.group(1).lower()
    # Use the "(" that is part of the regex match (after table name), not the next "(" in VARCHAR(26) etc.
    start = m.end() - 1
    end = find_matching_paren(stmt, start)
    if end == -1:
        return table, None
    body = stmt[start + 1 : end].strip()
    return table, body


def parse_alter_add_column(stmt: str) -> tuple[Optional[str], Optional[str], Optional[str]]:
    """Extract (table, colname, rest) from ALTER TABLE t ADD COLUMN [IF NOT EXISTS] c type..."""
    m = re.search(
        r"ALTER\s+TABLE\s+(\w+)\s+ADD\s+COLUMN\s+(?:IF\s+NOT\s+EXISTS\s+)?(\w+)\s+(.+)",
        stmt,
        re.IGNORECASE | re.DOTALL,
    )
    if not m:
        return None, None, None
    return m.group(1).lower(), m.group(2).lower(), m.group(3).strip()


def parse_alter_drop_column(stmt: str) -> tuple[Optional[str], Optional[str]]:
    m = re.search(
        r"ALTER\s+TABLE\s+(\w+)\s+DROP\s+COLUMN\s+(?:IF\s+EXISTS\s+)?(\w+)",
        stmt,
        re.IGNORECASE,
    )
    if not m:
        return None, None
    return m.group(1).lower(), m.group(2).lower()


def parse_alter_alter_column_type(stmt: str) -> tuple[Optional[str], Optional[str], Optional[str]]:
    m = re.search(
        r"ALTER\s+TABLE\s+(\w+)\s+ALTER\s+COLUMN\s+(\w+)\s+TYPE\s+(.+)",
        stmt,
        re.IGNORECASE | re.DOTALL,
    )
    if not m:
        return None, None, None
    return m.group(1).lower(), m.group(2).lower(), m.group(3).strip()


def parse_drop_table(stmt: str) -> Optional[str]:
    m = re.search(r"DROP\s+TABLE\s+(?:IF\s+EXISTS\s+)?(\w+)", stmt, re.IGNORECASE)
    return m.group(1).lower() if m else None


def parse_create_index(stmt: str) -> tuple[Optional[str], str]:
    """Return (index_name, full_statement)."""
    # CREATE [UNIQUE] INDEX [CONCURRENTLY] [IF NOT EXISTS] name ON ...
    m = re.search(
        r"CREATE\s+(?:UNIQUE\s+)?INDEX\s+(?:CONCURRENTLY\s+)?(?:IF\s+NOT\s+EXISTS\s+)?(\w+)\s+ON\s+",
        stmt,
        re.IGNORECASE,
    )
    if not m:
        return None, ""
    name = m.group(1).lower()
    # Normalize: output without CONCURRENTLY for a static schema file (optional)
    normalized = re.sub(r"\s+CONCURRENTLY\s+", " ", stmt, flags=re.IGNORECASE)
    return name, normalized.strip()


def parse_drop_index(stmt: str) -> Optional[str]:
    m = re.search(
        r"DROP\s+INDEX\s+(?:IF\s+EXISTS\s+)?(?:CONCURRENTLY\s+)?(\w+)",
        stmt,
        re.IGNORECASE,
    )
    return m.group(1).lower() if m else None


def parse_create_type(stmt: str) -> Optional[str]:
    if re.search(r"CREATE\s+TYPE\s+\w+\s+AS\s+ENUM", stmt, re.IGNORECASE):
        return stmt.strip()
    return None


def columns_and_constraints(body: str) -> tuple[list[tuple[str, str]], list[str]]:
    """Parse table body into list of (colname, coldef) and list of constraint lines (PRIMARY KEY, UNIQUE)."""
    cols = []
    constraints = []
    depth = 0
    start = 0
    for i, c in enumerate(body + ","):
        if c == "(":
            depth += 1
        elif c == ")":
            depth -= 1
        elif c == "," and depth == 0:
            part = body[start:i].strip()
            start = i + 1
            if not part:
                continue
            # Check if it's a constraint (PRIMARY KEY, UNIQUE, FOREIGN KEY, etc.)
            if re.match(r"^\s*(PRIMARY\s+KEY|UNIQUE|FOREIGN\s+KEY|CONSTRAINT)\s", part, re.IGNORECASE):
                constraints.append(part)
            else:
                # Column: first word is name, rest is definition
                col_match = re.match(r"^\s*(\w+)\s+(.+)$", part.strip(), re.DOTALL)
                if col_match:
                    # Store (name, type_and_constraints) so output is "name type..."
                    cols.append((col_match.group(1).lower(), col_match.group(2).strip()))
    return cols, constraints


def main() -> None:
    # Use combined_migrations.sql; build it from migrations.list if missing
    if not COMBINED_SQL.exists():
        list_file = MIGRATIONS_DIR / "migrations.list"
        if list_file.exists():
            lines = [
                p.strip() for p in list_file.read_text().splitlines()
                if p.strip().endswith(".up.sql")
            ]
            # Paths in list are like "channels/db/migrations/postgres/000001...."
            # From repo root they are server/channels/...
            base = MIGRATIONS_DIR.parent.parent.parent.parent  # migrations -> db -> channels -> server -> repo root
            parts = []
            for rel in lines:
                path = base / "server" / rel
                if path.exists():
                    parts.append(f"-- {path}\n{path.read_text(encoding='utf-8', errors='replace')}\n")
            COMBINED_SQL.write_text("".join(parts), encoding="utf-8")
            print("Built", COMBINED_SQL, "from migrations.list", file=sys.stderr)
    input_file = COMBINED_SQL if COMBINED_SQL.exists() else FINAL_SQL
    content = input_file.read_text(encoding="utf-8", errors="replace")
    # Skip header comment block (only when reading final.sql-style header)
    if content.startswith("-- Mattermost") and "==========" not in content[:500]:
        first_sql = content.find("\nCREATE ")
        if first_sql != -1:
            content = content[first_sql:]
    cleaned = strip_comments_and_blocks(content)
    # Split by semicolon (statements)
    statements = [
        s.strip() for s in re.split(r";\s*\n", cleaned) if s.strip() and not s.strip().startswith("=")
    ]

    tables: dict[str, dict] = {}  # table -> { cols: { name: def }, constraints: [...] }
    indexes: dict[str, str] = {}  # index_name -> full CREATE INDEX
    types: list[str] = []
    dropped_tables: set[str] = set()
    dropped_indexes: set[str] = set()
    attribute_view_sql: Optional[str] = None

    for stmt in statements:
        stmt = stmt.strip()
        # Remove leading comment lines so we can match CREATE TABLE / ALTER etc.
        stmt = re.sub(r"^(\s*--[^\n]*\n?)+", "", stmt).strip()
        if not stmt or stmt.startswith("="):
            continue
        # CREATE TABLE
        if re.search(r"CREATE\s+TABLE\s+IF\s+NOT\s+EXISTS", stmt, re.IGNORECASE):
            table, body = parse_create_table(stmt)
            if table and table not in dropped_tables:
                # Strip line comments from body before parsing (comments can break comma split)
                body_clean = re.sub(r"--[^\n]*", "", body) if body else ""
                cols, constraints = columns_and_constraints(body_clean)
                if cols or constraints:
                    tables[table] = {"cols": {c[0]: c[1] for c in cols}, "constraints": constraints}
            continue
        # ALTER TABLE ... ADD COLUMN
        if "ADD COLUMN" in stmt.upper() and "ALTER TABLE" in stmt.upper():
            t, c, rest = parse_alter_add_column(stmt)
            if t and c and t in tables and t not in dropped_tables:
                # Take only type and optional DEFAULT/NOT NULL (simplified)
                tables[t]["cols"][c] = rest.split(",")[0].strip()
            continue
        # ALTER TABLE ... DROP COLUMN
        if "DROP COLUMN" in stmt.upper():
            t, c = parse_alter_drop_column(stmt)
            if t and c and t in tables:
                tables[t]["cols"].pop(c, None)
            continue
        # ALTER TABLE ... ALTER COLUMN ... TYPE
        if "ALTER COLUMN" in stmt.upper() and "TYPE" in stmt.upper():
            t, c, typ = parse_alter_alter_column_type(stmt)
            if t and c and t in tables:
                typ = typ.split(",")[0].strip()
                tables[t]["cols"][c] = typ
            continue
        # DROP TABLE
        if re.match(r"DROP\s+TABLE", stmt, re.IGNORECASE):
            t = parse_drop_table(stmt)
            if t:
                dropped_tables.add(t)
                tables.pop(t, None)
                # Drop indexes for this table (we'll drop by name where ON table)
                for idx_name in list(indexes.keys()):
                    if re.search(rf"\s+ON\s+{re.escape(t)}\s", indexes[idx_name], re.IGNORECASE):
                        dropped_indexes.add(idx_name)
                        del indexes[idx_name]
            continue
        # CREATE INDEX
        if re.match(r"CREATE\s+(?:UNIQUE\s+)?INDEX", stmt, re.IGNORECASE):
            name, full = parse_create_index(stmt)
            if name and name not in dropped_indexes:
                indexes[name] = full + ";"
            continue
        # DROP INDEX
        if re.match(r"DROP\s+INDEX", stmt, re.IGNORECASE):
            name = parse_drop_index(stmt)
            if name:
                dropped_indexes.add(name)
                indexes.pop(name, None)
            continue
        # CREATE TYPE
        if "CREATE TYPE" in stmt and "AS ENUM" in stmt:
            t = parse_create_type(stmt)
            if t and t not in types:
                types.append(t + ";")
            continue
        # CREATE MATERIALIZED VIEW (from 000137 - we inject the static definition)
        if "CREATE MATERIALIZED VIEW" in stmt or "CREATE OR REPLACE PROCEDURE" in stmt:
            if "AttributeView" in stmt and "CREATE MATERIALIZED VIEW" in stmt:
                # Extract the inner CREATE MATERIALIZED VIEW from the procedure string
                inner = re.search(
                    r"CREATE\s+MATERIALIZED\s+VIEW\s+IF\s+NOT\s+EXISTS\s+AttributeView\s+AS\s+SELECT[\s\S]+?GROUP BY[^']+",
                    stmt,
                )
                if inner:
                    attribute_view_sql = inner.group(0).replace("''", "'") + ";"
            continue
        # UPDATE / DELETE / INSERT / other - skip
        if re.match(r"(UPDATE|DELETE|INSERT|SELECT)\s", stmt, re.IGNORECASE):
            continue

    # Build AttributeView from 000137 if we didn't capture it (static definition)
    if attribute_view_sql is None:
        attribute_view_sql = """CREATE MATERIALIZED VIEW IF NOT EXISTS AttributeView AS
SELECT
    pv."GroupID",
    pv."TargetID",
    pv."TargetType",
    jsonb_object_agg(
        pf."Name",
        CASE
            WHEN pf."Type" = 'select' THEN (
                SELECT to_jsonb(options.name)
                FROM jsonb_to_recordset(pf."Attrs"->'options') AS options(id text, name text)
                WHERE options.id = pv."Value" #>> '{}'
                LIMIT 1
            )
            WHEN pf."Type" = 'multiselect' AND jsonb_typeof(pv."Value") = 'array' THEN (
                SELECT jsonb_agg(option_names.name)
                FROM jsonb_array_elements_text(pv."Value") AS option_id
                JOIN jsonb_to_recordset(pf."Attrs"->'options') AS option_names(id text, name text)
                ON option_id = option_names.id
            )
            ELSE pv."Value"
        END
    ) AS "Attributes"
FROM "PropertyValues" pv
LEFT JOIN "PropertyFields" pf ON pf."ID" = pv."FieldID"
WHERE (pv."DeleteAt" = 0 OR pv."DeleteAt" IS NULL) AND (pf."DeleteAt" = 0 OR pf."DeleteAt" IS NULL)
GROUP BY pv."GroupID", pv."TargetID", pv."TargetType";"""

    # Types from 000090 (inside DO $$ so not in statements); add if not present
    for enum_name, enum_vals in [
        ("channel_type", "('P', 'G', 'O', 'D')"),
        ("team_type", "('I', 'O')"),
        ("upload_session_type", "('attachment', 'import')"),
    ]:
        if not any(enum_name in t for t in types):
            types.append(f"CREATE TYPE {enum_name} AS ENUM {enum_vals}")

    # Output
    out = []
    out.append("-- Mattermost Channels Database - Final schema (CREATE only)")
    out.append("-- Generated by scripts/build_final_schema.py from migrations.")
    out.append("-- Use for fresh installs. Do not run on existing databases.")
    out.append("")

    # 1. Types
    for t in types:
        out.append(t if t.endswith(";") else t + ";")
        out.append("")

    # 2. Tables (alphabetical for stable output)
    for table in sorted(tables.keys()):
        if table in dropped_tables:
            continue
        data = tables[table]
        cols = data["cols"]
        constraints = data["constraints"]
        col_lines = [f"    {name} {def_}" for name, def_ in sorted(cols.items())]
        constraint_lines = [f"    {c}" for c in constraints]
        all_parts = col_lines + constraint_lines
        out.append(f"CREATE TABLE IF NOT EXISTS {table} (")
        out.append(",\n".join(all_parts))
        out.append(");")
        out.append("")

    # 3. Indexes
    for name in sorted(indexes.keys()):
        out.append(indexes[name])
        out.append("")

    # 4. Materialized view
    if attribute_view_sql:
        out.append(attribute_view_sql)

    result = "\n".join(out)
    # Write to final.sql (overwrite)
    FINAL_SQL.write_text(result, encoding="utf-8")
    print(f"Wrote {FINAL_SQL} ({len(result)} chars, {len(tables)} tables, {len(indexes)} indexes)", file=sys.stderr)


if __name__ == "__main__":
    main()
