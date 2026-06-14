#!/usr/bin/env python3
"""
Update algorithm root .md files: remove C++ and Python solution links,
add Go link derived from the problem link (./problems/NNNN-slug.md -> ./golang/NNNN_slug.go).
Also handles 0001-1000.md style rows (leetcode.com links) using C++ path for slug.
"""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# Match problem link to get NNNN-slug (e.g. 0001-two-sum)
PROBLEM_LINK_RE = re.compile(r'\]\(\./problems/(\d{4}-[^)]+?)\.md\)')

# Leetcode-style: problem number at start and C++ or Python path for slug
LEETCODE_ROW_RE = re.compile(r'^(\d{4})\s*\|\s*.*?\[C\+\+\]\([^)]*/([^/)]+?)(?:\.cpp)?\)')
LEETCODE_PYTHON_ONLY_RE = re.compile(r'^(\d{4})\s*\|\s*.*?\[Python\]\([^)]*/([^/)]+?)(?:\.py)?\)')

# Remove C++ (and typo [C+]), Python links - match link text and path
CPP_RE = re.compile(r'\[C\+\+\]\([^)]+\)\s*')
CPP_TYPO_RE = re.compile(r'\[C\+\]\([^)]+\)\s*')
PYTHON_RE = re.compile(r'\[Python\]\([^)]+\)\s*')

# Also match C++ with typo like "reverse-pairscpp" (missing dot)
CPP_ANY_RE = re.compile(r'\[C\+\+\]\([^)]*cpp\)\s*')


def golang_path_from_slug(slug: str) -> str:
    """e.g. 0001-two-sum -> golang/0001_two_sum.go"""
    go_name = slug.replace('-', '_') + '.go'
    return f'./golang/{go_name}'


def process_line(line: str) -> str:
    # Try internal ./problems/ format first
    m = PROBLEM_LINK_RE.search(line)
    if m:
        slug = m.group(1)
        new_line = line
        for pattern in (CPP_RE, CPP_TYPO_RE, PYTHON_RE, CPP_ANY_RE):
            new_line = pattern.sub('', new_line)
        if '[Go](' not in new_line:
            go_link = f'[Go]({golang_path_from_slug(slug)})'
            col_re = re.compile(r'(\.md\)\s*\|\s)(\s*)(\s*\|\s+_O)', re.IGNORECASE)
            new_line = col_re.sub(lambda m: m.group(1) + ' ' + go_link + m.group(3), new_line, count=1)
            if '[Go](' not in new_line:
                col_re2 = re.compile(r'(\.md\)\s*\|\s)(\s*)(\s*\|\s+)')
                new_line = col_re2.sub(lambda m: m.group(1) + ' ' + go_link + m.group(3), new_line, count=1)
        return new_line

    # Leetcode-style rows: NNNN | [Title](...) | [C++](.../slug.cpp) [Python](...) or Python only
    leet = LEETCODE_ROW_RE.match(line)
    if not leet:
        leet = LEETCODE_PYTHON_ONLY_RE.match(line)
    if leet:
        num = leet.group(1)
        name = leet.group(2).replace('.cpp', '').replace('.py', '')
        slug_go = f'{num}_{name.replace("-", "_")}.go'
        go_link = f'[Go](./golang/{slug_go})'
        new_line = line
        for pattern in (CPP_RE, CPP_TYPO_RE, PYTHON_RE, CPP_ANY_RE):
            new_line = pattern.sub('', new_line)
        if '[Go](' not in new_line:
            new_line = re.sub(r'(\)\s*\|\s)(\s*)(\s*\|\s+_O)', lambda m: m.group(1) + ' ' + go_link + m.group(3), new_line, count=1)
        return new_line

    return line


def main():
    root_md = [f for f in ROOT.iterdir() if f.suffix == '.md' and f.is_file()]
    for path in sorted(root_md):
        text = path.read_text(encoding='utf-8')
        new_lines = [process_line(line) for line in text.splitlines(keepends=True)]
        new_text = ''.join(new_lines)
        if new_text != text:
            path.write_text(new_text, encoding='utf-8')
            print(path.name)


if __name__ == '__main__':
    main()
