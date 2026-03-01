# 1457 Pseudo-Palindromic Paths in a Binary Tree

## Problem Problem

Given the `root` of a binary tree, return the number of pseudo-palindromic paths in the tree.

A pseudo-palindromic path is a path that reads the same forward and backward.

### Example 1:
```
Input: root = [2,3,1,1]
Output: 2
Explanation: Three pseudo-palindromic paths: [2,3,3],[2,1,1],[1,1]]
```

### Example 2:
```
Input: root = [1,2,3]
Output: 1
Explanation: Only one pseudo-palindromic path: [1,2,3]
```

### Example 3:
```
Input: root = [2,1]
Output: 2
Explanation: Only one pseudo-palindromic path: [2,1]
```

## The Twist

We need to count paths that are **palindromic** (same forward and backward). This requires checking each path in both directions.

## Algorithm

### DFS with Hash Set:
1. Use DFS to traverse all root-to-leaf paths
2. For each path:
   - Check if the path is a palindrome
   - If yes, increment count
3. Return the total count

### Using String Comparison:
1. For each root-to-leaf path:
   - Create the string representation of the path
   - Check if it equals its reverse
   - If yes, increment count
3. Return the total count

### Using Post-order with Path Building:
1. For each node, recursively build paths to leaves
2. Check each path for palindrome property
3. Count all valid paths

## Complexity

- **Time**: O(n²) - each path can be O(n) long
- **Space**: O(n) - storing paths

## Link

[LeetCode 1457 Pseudo-Palindromic Paths in a Binary Tree](https://leetcode.com/problems/pseudo-palindromic-paths-in-a-binary-tree/)
