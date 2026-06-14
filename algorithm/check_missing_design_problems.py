#!/usr/bin/env python3
import re
import os

def extract_problem_numbers():
    """Extract all problem numbers from design.md"""
    with open('design.md', 'r') as f:
        content = f.read()
    
    # Find all problem numbers in the format | XXXX | 
    pattern = r'\| (\d{4}) \|'
    matches = re.findall(pattern, content)
    return sorted(set(matches))

def get_existing_problems():
    """Get list of existing problem files in problems folder"""
    problems_dir = 'problems'
    if not os.path.exists(problems_dir):
        return []
    
    existing = []
    for filename in os.listdir(problems_dir):
        if filename.endswith('.md'):
            # Extract problem number from filename (e.g., "0146-lru-cache.md" -> "0146")
            match = re.match(r'(\d{4})-', filename)
            if match:
                existing.append(match.group(1))
    
    return sorted(set(existing))

def main():
    design_problems = extract_problem_numbers()
    existing_problems = get_existing_problems()
    
    print(f"Total problems in design.md: {len(design_problems)}")
    print(f"Existing problem files: {len(existing_problems)}")
    
    missing = sorted(set(design_problems) - set(existing_problems))
    
    print(f"\nMissing problem files ({len(missing)}):")
    for num in missing:
        print(f"  {num}")
    
    return missing

if __name__ == "__main__":
    missing = main()