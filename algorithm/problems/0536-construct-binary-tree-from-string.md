# 0536 Construct Binary Tree from String

## Problem Description

You need to construct a binary tree from a string consisting of parenthesis and integers.

The whole input represents a binary tree. It contains an integer followed by an optional pair of parenthesis. The integer represents the root's value and a pair of parenthesis contains a child binary tree with the same structure.

You always start to construct the left child node of the parent first if it exists.

### Example 1:
```
Input: s = "4(2(3)(1))(6(5)(7))"
Output: [4,2,6,3,1,5,7]
```

### Example 2:
```
Input: s = "-4(2(3)(1))(6(5)(7))"
Output: [-4,2,-6,3,1,5,7]
```

### Example 3:
```
Input: s = "-4(2(3)(1))(6(5)(7))"
Output: [-4,2,-6,3,1,5,7]
```

## The Twist

The string uses **parentheses to represent tree structure**. We need to parse the string and recursively build the tree based on the nesting of parentheses.

## Algorithm

### Recursive Parsing:
1. Parse the root value (may include negative sign)
2. Find the matching parentheses for left and right subtrees
3. Recursively construct left subtree from the first pair of parentheses
4. Recursively construct right subtree from the second pair of parentheses
5. Return the constructed node

### Using Stack:
1. Use a stack to track nodes and their states
2. Parse the string character by character
3. When encountering a number, create a node
4. When encountering '(', push current node and prepare for children
5. When encountering ')', pop from stack to return to parent

## Complexity

- **Time**: O(n) - single pass through the string
- **Space**: O(n) - storing the tree

## Link

[LeetCode 0536 Construct Binary Tree from String](https://leetcode.com/problems/construct-binary-tree-from-string/)
