#!/usr/bin/env python3

import re
import os

# Read the sql.md file to extract problem information
with open('sql.md', 'r') as f:
    content = f.read()

# Extract problem information using regex
pattern = r'\|\s+(\d+)\s+\|\s+\[([^\]]+)\]\([^)]+\)\s+\|\s+\[MySQL\]\([^)]+\)\s+\|\s+([^|]+)\s+\|\s+([^|]+)\s+\|\s+([^|]+)\s+\|'
matches = re.findall(pattern, content)

# Create a dictionary of problem number to (title, time, space, difficulty)
problems = {}
for match in matches:
    problem_num = match[0]
    title = match[1]
    time = match[2].strip()
    space = match[3].strip()
    difficulty = match[4].strip()
    problems[problem_num] = (title, time, space, difficulty)

# Template for SQL problem files
template = '''# {num} {title}

## Problem Description

[Problem description would go here based on the LeetCode problem]

### Example 1:
```
Input: 
[Example input would go here]
Output: 
[Example output would go here]
```

## The Twist

[Key insight or twist for this problem would go here]

## Algorithm

1. [Algorithm step 1]
2. [Algorithm step 2]
3. [Algorithm step 3]

## Complexity

- **Time**: {time} — [Explanation]
- **Space**: {space} — [Explanation]

## Solution Code

```sql
[SQL solution would go here]
```

## Link

[LeetCode {num} {title}](https://leetcode.com/problems/{slug}/)
'''

# Create missing problem files
created_count = 0
for problem_num, (title, time, space, difficulty) in problems.items():
    filename = f"problems/{problem_num}-{title.lower().replace(' ', '-').replace(',', '').replace(':', '').replace('(', '').replace(')', '').replace('/', '-')}.md"
    slug = title.lower().replace(' ', '-')
    
    # Skip if file already exists
    if os.path.exists(filename):
        continue
    
    # Create the file with the template
    with open(filename, 'w') as f:
        f.write(template.format(
            num=problem_num,
            title=title,
            time=time,
            space=space,
            difficulty=difficulty,
            slug=slug
        ))
    
    created_count += 1
    print(f"Created {filename}")

print(f"\nTotal files created: {created_count}")