import re

# Read the binary-search.md file
with open('binary-search.md', 'r') as f:
    content = f.read()

# Extract all problem numbers using regex
problem_numbers = re.findall(r'\| (\d{4}) \|', content)

# Get unique problem numbers
unique_problems = sorted(set(problem_numbers))

print(f"Total unique problems: {len(unique_problems)}")
print("Problem numbers:")
for num in unique_problems:
    print(num)
