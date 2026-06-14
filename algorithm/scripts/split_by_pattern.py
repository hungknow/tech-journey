#!/usr/bin/env python3
"""
Parse 0001-1000.md and generate per-pattern markdown files with local problem links.
Links point to ./problems/XXXX-slug.md (no LeetCode URLs).
Problems are grouped by common pattern within each file (see groupings.py).
"""
import re
import os
from groupings import SECTION_GROUPS, assign_group

SECTION_TO_FILE = {
    "Bit Manipulation": "bit-manipulation.md",
    "Array": "array.md",
    "String": "string.md",
    "Linked List": "linked-list.md",
    "Stack": "stack.md",
    "Queue": "queue.md",
    "Binary Heap": "binary-heap.md",
    "Tree": "tree.md",
    "Hash Table": "hash-table.md",  # already refactored with subgroups; skip overwriting
    "Math": "math.md",
    "Sort": "sort.md",
    "Two Pointers": "two-pointers.md",
    "Recursion": "recursion.md",
    "Binary Search": "binary-search.md",
    "Binary Search Tree": "binary-search-tree.md",
    "Breadth-First Search": "breadth-first-search.md",
    "Depth-First Search": "depth-first-search.md",
    "Backtracking": "backtracking.md",
    "Dynamic Programming": "dynamic-programming.md",
    "Greedy": "greedy.md",
    "Graph": "graph.md",
    "Geometry": "geometry.md",
    "Simulation": "simulation.md",
    "Design": "design.md",
    "Concurrency": "concurrency.md",
    "SQL": "sql.md",
    "Shell Script": "shell-script.md",
}

# Row pattern: "0136 | [Title](https://leetcode.com/problems/slug/) | ..."
ROW_RE = re.compile(
    r"^(\d{4})\s*\|\s*\[([^\]]+)\]\(https://leetcode\.com/problems/([^/]+)/\)\s*\|(.*)$",
    re.MULTILINE,
)


def slug_from_url(url_path: str) -> str:
    """Extract slug from leetcode URL path (e.g. 'single-number' from 'single-number/')."""
    return url_path.rstrip("/")


def convert_row(line: str) -> tuple:
    """Convert a table row to use local problem link. Returns (group_name, row_str) or (None, None)."""
    m = ROW_RE.match(line)
    if not m:
        return None, None
    num, title, slug, rest = m.groups()
    slug = slug_from_url(slug)
    local_link = f"./problems/{num}-{slug}.md"
    row_str = f"| {num} | [{title}]({local_link}) |{rest}\n"
    return None, row_str  # group assigned later


# Source files to merge (problems 1-1000, 1001-2000, 2001-3000)
SOURCE_FILES = ["0001-1000.md", "1001-2000.md", "2001-3000.md"]

# Extract problem number from row string for sorting (e.g. "| 0136 |" or "| 1310 |")
def _row_key(row_str):
    m = re.match(r"^\|\s*(\d+)\s*\|", row_str)
    return int(m.group(1)) if m else 0


def parse_source(base: str, path: str) -> dict:
    """Parse one source md file; return section_name -> group_name -> list of row strings."""
    full_path = os.path.join(base, path)
    if not os.path.isfile(full_path):
        return {}
    with open(full_path, "r", encoding="utf-8") as f:
        content = f.read()
    sections = re.split(r"\n## (?=[A-Za-z])", content)
    result = {}  # section_name -> group_name -> [rows]
    for i, block in enumerate(sections):
        if not block.strip():
            continue
        first_line, _, rest = block.partition("\n")
        if i == 0:
            continue
        section_name = first_line.strip()
        if section_name not in SECTION_TO_FILE:
            continue
        if section_name not in result:
            result[section_name] = {}
        grouped = result[section_name]
        lines = rest.split("\n")
        in_table = False
        for line in lines:
            if line.startswith("|  #  |"):
                in_table = True
                continue
            if line.startswith("|-----|") and in_table:
                continue
            if in_table and ROW_RE.match(line):
                m = ROW_RE.match(line)
                num, title, slug, rest_part = m.groups()
                slug = slug_from_url(slug)
                local_link = f"./problems/{num}-{slug}.md"
                row_str = f"| {num} | [{title}]({local_link}) |{rest_part}\n"
                group_name = assign_group(section_name, num, title, rest_part)
                grouped.setdefault(group_name, []).append(row_str)
            elif in_table and line.startswith("|") and not re.match(r"^\|\s*\d+\s*\|", line):
                if "-----" not in line:
                    in_table = False
            elif in_table and line.strip() == "":
                in_table = False
    return result


def main():
    base = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    # Merge all sources: section -> group -> list of rows
    merged = {}  # section_name -> group_name -> [rows]
    for src in SOURCE_FILES:
        parsed = parse_source(base, src)
        for section_name, groups in parsed.items():
            if section_name not in merged:
                merged[section_name] = {}
            for group_name, rows in groups.items():
                merged[section_name].setdefault(group_name, []).extend(rows)

    for section_name, grouped in merged.items():
        out_file = SECTION_TO_FILE.get(section_name)
        if not out_file or out_file == "hash-table.md":
            continue
        # Sort rows within each group by problem number
        for group_name in grouped:
            grouped[group_name].sort(key=_row_key)
        table_header = "| # | Title | Solution | Time | Space | Difficulty | Tag | Note |\n"
        table_sep = "|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|\n"
        order = [g[0] for g in SECTION_GROUPS.get(section_name, [("Problems", None)])]
        for g in grouped:
            if g not in order:
                order.append(g)
        body = "## " + section_name + "\n\n"
        total = 0
        for i, group_name in enumerate(order):
            rows = grouped.get(group_name, [])
            if not rows:
                continue
            total += len(rows)
            body += "### " + str(i + 1) + ". " + group_name + "\n\n"
            body += table_header
            body += table_sep
            body += "".join(rows)
            body += "\n---\n\n"
        body = body.rstrip("\n---\n\n") + "\n"
        out_path = os.path.join(base, out_file)
        with open(out_path, "w", encoding="utf-8") as f:
            f.write(body)
        print("Wrote", out_file, "(", total, "problems in", len([g for g in order if grouped.get(g)]), "groups)")


if __name__ == "__main__":
    main()
