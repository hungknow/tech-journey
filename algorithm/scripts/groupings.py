"""
Define pattern groups per topic. Each entry: (group_name, matcher).
Matcher is either a set of problem numbers (as strings "0136") or a list of keywords
(any match in title or rest assigns the row to that group). First match wins.
Use "**" as group name for catch-all "Other" (optional).
"""
import re

def _nums(*ids):
    return frozenset(f"{i:04d}" for i in ids)

# (section_name, list of (group_name, matcher))
# matcher: frozenset of "XXXX" -> by problem number; or list of keywords -> by title/rest
SECTION_GROUPS = {
    "Bit Manipulation": [
        ("Single Number & XOR", _nums(136, 137, 260, 371, 389)),
        ("Power of 2/4 & Bit Check", _nums(231, 342, 693)),
        ("Count Bits & Hamming", _nums(191, 461, 476, 477, 762)),
        ("Range & AND/OR", _nums(201, 898)),
        ("Reverse & Manipulate Bits", _nums(190)),
        ("Missing / Mismatch", _nums(268, 645)),
        ("Other", None),  # catch-all
    ],
    "Array": [
        ("Two Pointers & In-place", ["Two Pointers", "Inplace", "Remove Duplicates", "Remove Element"]),
        ("Matrix & 2D Grid", ["Matrix", "Spiral", "Image", "Grid", "Board", "Battleship", "Diagonal", "Transpose", "Toeplitz", "Magic Square"]),
        ("Subarray & Sliding Window", ["Subarray", "Consecutive", "Product Less", "Bounded Maximum", "Turbulent"]),
        ("Prefix / Ranges / Pivot", ["Summary Ranges", "Missing Ranges", "Pivot Index", "Range Addition"]),
        ("Stock & Buy/Sell", ["Stock", "Buy", "Sell"]),
        ("Majority / Duplicate / Frequency", ["Majority", "Duplicate", "Disappeared", "Degree of an Array"]),
        ("Quick Select / Partition", ["Quick Select", "Tri Partition", "Kth Largest"]),
        ("Intervals & Calendar", ["Calendar", "Interval", "Disjoint"]),
        ("Union Find", ["Union Find"]),
        ("Simulation & Game Logic", ["Game of Life", "Fizz", "Lemonade", "Teemo", "Tic-Tac-Toe", "Candy Crush", "Pour Water", "Snakes and Ladders"]),
        ("Other", None),
    ],
    "String": [
        ("Palindrome & Substring", ["Palindrome", "Palindromic", "Substring"]),
        ("Parsing & Validation", ["Valid", "Parse", "Encode", "Decode", "IP", "Abbreviation"]),
        ("Reverse & Transform", ["Reverse", "Zigzag", "Add Binary", "Multiply"]),
        ("Word & Pattern", ["Word", "Pattern", "Anagram", "Dictionary"]),
        ("KMP / String Match", ["strStr", "KMP", "Rabin-Karp", "Repeated Substring"]),
        ("Other", None),
    ],
    "Linked List": [
        ("Merge & Sort", ["Merge", "Sort"]),
        ("Reverse & Reorder", ["Reverse", "Reorder"]),
        ("Two Pointers / Cycle", ["Cycle", "Intersection", "Nth", "Middle"]),
        ("Add / Remove", ["Add Two", "Remove", "Delete", "Partition"]),
        ("Other", None),
    ],
    "Stack": [
        ("Parentheses & Valid", ["Parentheses", "Valid Parentheses", "Decode String", "Score of Parentheses"]),
        ("Monotonic Stack", ["Mono Stack", "Next Greater", "Daily Temperatures", "Largest Rectangle"]),
        ("Calculator & Eval", ["Calculator", "Polish", "Evaluate"]),
        ("Other", None),
    ],
    "Queue": [
        ("Sliding Window / Deque", ["Sliding Window", "Mono Deque"]),
        ("Iterator / Stream", ["Iterator", "Moving Average", "Recent Calls"]),
        ("Other", None),
    ],
    "Binary Heap": [
        ("K-th / Median", ["Kth", "Median", "Smallest", "Largest"]),
        ("Merge / Multiple", ["Merge", "Smallest Range", "K Pairs"]),
        ("Scheduling / Greedy", ["IPO", "Refuel", "Rearrange String"]),
        ("Other", None),
    ],
    "Tree": [
        ("Traversal (Inorder/Pre/Post)", ["Inorder", "Preorder", "Postorder", "Level Order", "Traversal"]),
        ("BST & Search", ["BST", "Binary Search Tree", "Search", "Insert", "Delete"]),
        ("Serialize / Deserialize", ["Serialize", "Deserialize"]),
        ("Path & Sum", ["Path Sum", "Diameter", "Tilt"]),
        ("Construction", ["Construct", "Build", "Convert"]),
        ("Other", None),
    ],
    "Math": [
        ("Integer / Digit", ["Reverse Integer", "Palindrome Number", "Add Digits", "Nth Digit"]),
        ("Roman / Conversion", ["Roman", "Integer to", "Excel", "Base 7", "Hexadecimal"]),
        ("Power / Sqrt", ["Pow", "Sqrt", "Power of", "Super Pow"]),
        ("Geometry / Rectangle", ["Rectangle", "Overlap", "Area", "Triangle"]),
        ("Random / Probability", ["Random", "Rand7", "Rand10", "Probability"]),
        ("Other", None),
    ],
    "Sort": [
        ("Merge / Interval", ["Merge Interval", "Insert Interval"]),
        ("Partition / QuickSelect", ["Sort Colors", "Tri Partition", "Wiggle"]),
        ("Top K / Frequency", ["Top K", "Frequent", "K Closest"]),
        ("Other", None),
    ],
    "Two Pointers": [
        ("3Sum / 4Sum / NSum", ["3 Sum", "4 Sum", "3Sum", "4Sum"]),
        ("Sliding Window", ["Subarray Sum", "Minimum Size", "Sliding Window", "Fruit", "Binary Subarrays"]),
        ("Linked List", ["Linked List", "Cycle", "Nth Node", "Middle"]),
        ("Reverse / Two Arrays", ["Reverse", "Intersection", "Backspace"]),
        ("Other", None),
    ],
    "Recursion": [
        ("BST / Tree Build", ["Binary Search Tree", "Construct", "Convert Sorted"]),
        ("Path / Sum", ["Path Sum", "Maximum Path", "Sum Root"]),
        ("Divide & Conquer", ["Different Ways", "Range Sum"]),
        ("Other", None),
    ],
    "Binary Search": [
        ("Sorted Array", ["Sorted Array", "Search Insert", "First Bad", "Search in Rotated"]),
        ("Matrix / 2D", ["2D Matrix", "Matrix"]),
        ("Answer on Value", ["Koko", "Heaters", "Split Array", "Minimize Max"]),
        ("Other", None),
    ],
    "Binary Search Tree": [
        ("Kth / Order", ["Kth Smallest", "Inorder Successor"]),
        ("LCA / Closest", ["Lowest Common", "Closest"]),
        ("Serialize / Interval", ["Serialize", "Disjoint Interval"]),
        ("Other", None),
    ],
    "Breadth-First Search": [
        ("Tree Level", ["Level Order", "Zigzag", "Next Right"]),
        ("Graph / Shortest Path", ["Word Ladder", "Course Schedule", "Network Delay", "Dijkstra"]),
        ("Grid / Matrix", ["Surrounded", "01 Matrix", "Rotting", "Maze", "Shortest Bridge"]),
        ("Other", None),
    ],
    "Depth-First Search": [
        ("Path / Sum", ["Path Sum", "Binary Tree Paths"]),
        ("Islands / Grid", ["Islands", "Max Area", "Flood Fill", "Distinct Islands"]),
        ("Graph / Cycle", ["Clone Graph", "Bipartite", "Eventual Safe"]),
        ("Other", None),
    ],
    "Backtracking": [
        ("Combination / Subset", ["Combination", "Subset", "Permutation"]),
        ("Word Search / Break", ["Word Search", "Word Break", "Palindrome Partition"]),
        ("N-Queens / Sudoku", ["N-Queens", "Sudoku"]),
        ("Other", None),
    ],
    "Dynamic Programming": [
        ("1D / Linear", ["Climbing Stairs", "House Robber", "Maximum Subarray", "Coin Change"]),
        ("2D / Grid", ["Unique Paths", "Minimum Path", "Dungeon", "Maximal Square"]),
        ("String DP", ["Edit Distance", "Longest Palindromic", "Word Break", "Interleaving"]),
        ("Stock / Buy Sell", ["Stock", "Buy", "Sell"]),
        ("Other", None),
    ],
    "Greedy": [
        ("Intervals", ["Interval", "Non-overlapping", "Arrow", "Partition Labels"]),
        ("Jump / Reach", ["Jump", "Gas Station", "Reach"]),
        ("Two Pointers", ["Container", "Trapping Rain", "Assign Cookies"]),
        ("Other", None),
    ],
    "Graph": [
        ("Union Find", ["Union Find", "Satisfiability", "Regions", "Malware"]),
        ("Path / Euler", ["Reconstruct Itinerary", "Evaluate Division"]),
        ("Other", None),
    ],
    "Geometry": [
        ("Convex Hull / Fence", ["Fence", "Convex"]),
        ("3D / Surface", ["Surface Area", "3D"]),
        ("Other", None),
    ],
    "Simulation": [
        ("Robot / Walk", ["Robot", "Walking"]),
        ("Other", None),
    ],
    "Design": [
        ("Cache", ["LRU", "LFU", "Cache"]),
        ("Stack / Queue", ["Stack", "Queue", "Deque"]),
        ("Hash / Set", ["HashSet", "HashMap"]),
        ("Other", None),
    ],
    "Concurrency": [
        ("Other", None),
    ],
    "SQL": [
        ("Join / Aggregate", ["Combine", "Department", "Salary", "Duplicate"]),
        ("Window / Rank", ["Rank", "Nth", "Running"]),
        ("Other", None),
    ],
    "Shell Script": [
        ("Text / File", ["Word Frequency", "Transpose", "Tenth Line"]),
        ("Validation", ["Valid Phone"]),
        ("Other", None),
    ],
}


def assign_group(section_name: str, problem_num: str, title: str, rest: str) -> str:
    """Return group name for this row. problem_num is 4-char string."""
    groups = SECTION_GROUPS.get(section_name)
    if not groups:
        return "Problems"
    text = (title + " " + rest).lower()
    for group_name, matcher in groups:
        if matcher is None:
            return group_name  # catch-all
        if isinstance(matcher, frozenset):
            if problem_num in matcher:
                return group_name
        else:
            for kw in matcher:
                if kw.lower() in text:
                    return group_name
    return groups[-1][0] if groups else "Problems"
