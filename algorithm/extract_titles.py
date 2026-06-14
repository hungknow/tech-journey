import re

# Read the binary-search.md file
with open('binary-search.md', 'r') as f:
    content = f.read()

# Extract problem number and title pairs
pattern = r'\| (\d{4}) \| \[([^\]]+)\]'
matches = re.findall(pattern, content)

# Create a dictionary of problem number to title
problem_titles = {}
for num, title in matches:
    problem_titles[num] = title

# Get the missing problem numbers
missing_problems = [
    '0793', '1201', '1228', '1385', '1533', '1539', '1618', '1648', '1802', '1818',
    '1870', '1889', '1891', '1898', '1918', '2064', '2137', '2187', '2226', '2250',
    '2300', '2333', '2389', '2448', '2476', '2513', '2517', '2528', '2529', '2554',
    '2557', '2560', '2594', '2602', '2616', '2702', '2936', '2940'
]

print("Missing problem files to create:")
for num in missing_problems:
    if num in problem_titles:
        title = problem_titles[num]
        # Convert title to kebab-case for filename
        filename = num + '-' + title.lower().replace(' ', '-').replace(',', '').replace('(', '').replace(')', '') + '.md'
        print(f"{num}: {title} -> {filename}")
    else:
        print(f"{num}: Title not found")