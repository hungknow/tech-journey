# 0687 Longest Univalue Path

## Problem Description

Given the `root` of a binary tree, return the length of the longest path where each node in the path has the same value.

This path may or may not pass through the root.

The length of the path between two nodes is represented by the number of edges between them.

### Example 1:
```
Input: root = [5,5,5,5,5,5,5]
Output: 5
```

### Example 2:
```
Input: root = [1,4,5,5,4,4,5]
Output: 2
```

### Example 3:
```
Input: root = []
Output: 0
```

## The Twist

We need to find the **longest path with same values**. The path can go through a node in both directions (up through parent, down through children).

## Algorithm

### DFS with Path Tracking:
1. For each node, calculate the longest univalue path through it
2. For each node:
   - Calculate the longest path down the left subtree with same value
   - Calculate the longest path down the right subtree with same value
   - Path through this node = left_path + right_path
   - Update global maximum
3. Return the global maximum

### Recursive Approach:
1. Define a helper that returns (longest_down, longest_through)
2. For each node:
   - Get results from left and right children
   - Calculate longest_down (extend if values match)
   - Calculate longest_through (connect left and right paths if values match)
   - Update global maximum
3. Return the global maximum

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 0687 Longest Univalue Path](https://leetcode.com/problems/longest-univalue-path/)
