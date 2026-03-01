# 0543 Diameter of Binary Tree

## Problem Description

Given the `root` of a binary tree, return the length of the diameter of the tree.

The diameter of a binary tree is the length of the longest path between any two nodes in a tree. This path may or may not pass through the root.

The length of a path between two nodes is represented by the number of edges between them.

### Example 1:
```
Input: root = [1,2,3,4,5]
Output: 3
Explanation: The longest path is [3,4,5,2] or [5,4,3,2] with length 3.
```

### Example 2:
```
Input: root = [1,2]
Output: 1
```

## The Twist

The longest path might **not pass through the root**. We need to find the maximum path length anywhere in the tree, which could be through any node.

## Algorithm

### DFS with Height Tracking:
1. For each node, calculate the height of left and right subtrees
2. The diameter through this node = left_height + right_height
3. Track the maximum diameter seen
4. Return the height of this subtree (max(left_height, right_height) + 1)

### Recursive Approach:
1. Define a helper function that returns the height of the subtree
2. At each node:
   - Get heights of left and right subtrees
   - Update global max diameter if left + right > current max
   - Return max(left, right) + 1
3. Return the global max diameter

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 0543 Diameter of Binary Tree](https://leetcode.com/problems/diameter-of-binary-tree/)
