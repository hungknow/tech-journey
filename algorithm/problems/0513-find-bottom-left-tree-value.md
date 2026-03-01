# 0513 Find Bottom Left Tree Value

## Problem Description

Given the `root` of a binary tree, return the leftmost value in the last row of the tree.

### Example 1:
```
Input: root = [2,1,3]
Output: 1
```

### Example 2:
```
Input: root = [1,2,3,4,null,5,6,null,null,7]
Output: 7
```

## The Twist

We need to find the **leftmost value in the last level**. This requires BFS to find the last level, then identify the leftmost node.

## Algorithm

### BFS Approach:
1. Use BFS to traverse the tree level by level
2. Track the first node of each level
3. After traversal, the last tracked first node is the answer

### DFS with Depth Tracking:
1. Use DFS to find the maximum depth
2. During DFS, track the leftmost node at each depth
3. Return the leftmost node at maximum depth

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(w) - queue width for BFS, O(h) for DFS

## Link

[LeetCode 0513 Find Bottom Left Tree Value](https://leetcode.com/problems/find-bottom-left-tree-value/)
