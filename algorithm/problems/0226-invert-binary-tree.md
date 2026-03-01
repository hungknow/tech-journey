# 0226 Invert Binary Tree

## Problem Description

Given the `root` of a binary tree, invert the tree, and return its root.

### Example 1:
```
Input: root = [4,2,7,1,3,6,9]
Output: [4,7,2,9,6,3,1]
```

### Example 2:
```
Input: root = [2,1,3]
Output: [2,3,1]
```

### Example 3:
```
Input: root = []
Output: []
```

## The Twist

Inverting a binary tree means **swapping left and right children** at every node. This is a simple but fundamental tree operation.

## Algorithm

### Recursive Approach:
1. If root is null, return null
2. Swap left and right children
3. Recursively invert left subtree
4. Recursively invert right subtree
5. Return root

### Iterative Approach (using queue):
1. Use BFS to traverse the tree level by level
2. For each node, swap its left and right children
3. Continue until all nodes are processed

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(h) recursive, O(w) iterative (queue width)

## Link

[LeetCode 0226 Invert Binary Tree](https://leetcode.com/problems/invert-binary-tree/)
