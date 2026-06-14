#!/usr/bin/env python3
import re
import os

def extract_problem_info():
    """Extract problem numbers and titles from design.md"""
    with open('design.md', 'r') as f:
        content = f.read()
    
    # Find all problem rows in the format | XXXX | [Title](./problems/XXXX-title.md) | ...
    pattern = r'\| (\d{4}) \| \[([^\]]+)\]\(\.\/problems\/\d{4}-[^)]+\) \|'
    matches = re.findall(pattern, content)
    
    # Create a dictionary of problem number -> title
    problem_info = {}
    for num, title in matches:
        problem_info[num] = title
    
    return problem_info

def get_missing_problems():
    """Get list of missing problem files"""
    problem_info = extract_problem_info()
    design_problems = problem_info.keys()
    
    existing_problems = []
    problems_dir = 'problems'
    if os.path.exists(problems_dir):
        for filename in os.listdir(problems_dir):
            if filename.endswith('.md'):
                match = re.match(r'(\d{4})-', filename)
                if match:
                    existing_problems.append(match.group(1))
    
    missing = sorted(set(design_problems) - set(existing_problems))
    return missing, problem_info

def create_filename(problem_num, title):
    """Create filename from problem number and title"""
    # Convert title to lowercase, replace spaces with hyphens, and remove special characters
    title_clean = re.sub(r'[^\w\s-]', '', title.lower())
    title_clean = re.sub(r'\s+', '-', title_clean.strip())
    return f"{problem_num}-{title_clean}.md"

def create_problem_file(problem_num, title, reference_file='problems/0355-design-twitter.md'):
    """Create a problem file using the reference structure"""
    filename = create_filename(problem_num, title)
    filepath = os.path.join('problems', filename)
    
    # Read the reference file
    with open(reference_file, 'r') as f:
        template = f.read()
    
    # Replace the problem number and title in the template
    content = template.replace('0355 Design Twitter', f'{problem_num} {title}')
    
    # Write the new file
    with open(filepath, 'w') as f:
        f.write(content)
    
    return filepath

def main():
    missing_problems, problem_info = get_missing_problems()
    
    print(f"Creating {len(missing_problems)} remaining problem files...")
    
    created_files = []
    for problem_num in missing_problems:
        title = problem_info.get(problem_num, f"Problem {problem_num}")
        filename = create_filename(problem_num, title)
        filepath = os.path.join('problems', filename)
        
        # Check if file already exists
        if os.path.exists(filepath):
            print(f"  Skipping {filename} (already exists)")
            continue
        
        try:
            created = create_problem_file(problem_num, title)
            created_files.append(created)
            print(f"  Created: {filename}")
        except Exception as e:
            print(f"  Error creating {filename}: {e}")
    
    print(f"\nSuccessfully created {len(created_files)} problem files.")
    return created_files

if __name__ == "__main__":
    main()