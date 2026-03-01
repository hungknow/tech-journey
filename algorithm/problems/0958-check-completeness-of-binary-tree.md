# 0958 Check Completeness of a Binary Tree

## Problem Description

Given the `root` of a binary tree, determine if it is a complete binary tree.

In a complete binary tree, every level, except possibly the last, is completely filled, and all nodes are as far left as possible.

### Example 1:
```
Input: root = [1,2,3,4,5,6]
Output: true
```

### Example 2:
```
Input: root = [1,2,3,4,5,null,7]
Output: false
```

### Example 3:
```
Input: root = []
Output: true
```

## The Twist

A complete binary tree has **all levels filled except possibly the last**, and nodes are as far left as possible. We need to verify this property.

## Algorithm

### BFS Level Order Check:
1. Use BFS to traverse the tree level by level
2. Track whether we've seen a null node before a non-null node
3. If we encounter a null node:
   - All subsequent nodes at this level must be null
4. If we encounter a non-null node after seeing a null, return false
5. Return true if we complete the traversal

### Using Level Count:
1. Calculate the height of the tree
2. Count the number of nodes
3. A complete binary tree with height h should have exactly 2^h - 1 nodes
4. Return true if node count matches, false otherwise

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(w) - queue width for BFS

## Link

[LeetCode 0958 Check Completeness of a Binary Tree](https://leetcode.com/problems/check-completeness-of-binary-tree/)
