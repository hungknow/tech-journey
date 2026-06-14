import os
import re

# Read the binary-search.md file
with open('binary-search.md', 'r') as f:
    content = f.read()

# Extract all problem numbers using regex
problem_numbers = re.findall(r'\| (\d{4}) \|', content)

# Get unique problem numbers
unique_problems = sorted(set(problem_numbers))

# Get all existing problem files
existing_files = set()
for file in os.listdir('problems/'):
    if re.match(r'^\d{4}-.*\.md$', file):
        num = file[:4]
        existing_files.add(num)

# Find missing problems
missing_problems = []
for num in unique_problems:
    if num not in existing_files:
        missing_problems.append(num)

print(f"Total problems in binary-search.md: {len(unique_problems)}")
print(f"Existing problem files: {len(existing_files)}")
print(f"Missing problem files: {len(missing_problems)}")
print("\nMissing problem numbers:")
for num in sorted(missing_problems):
    print(num)