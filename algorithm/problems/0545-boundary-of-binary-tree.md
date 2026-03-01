# 0545 Boundary of Binary Tree

## Problem Description

Given the `root` of a binary tree, return the values of its boundary in an anti-clockwise direction starting from the root.

The boundary of a binary tree is the set of nodes that are:
- The root node
- The left boundary (the leftmost path from root to the leftmost leaf)
- The right boundary (the rightmost path from root to the rightmost leaf)
- The leaves of the tree, excluding the root

### Example 1:
```
Input: root = [1,null,2,3,4]
Output: [1,3,4,2]
```

### Example 2:
```
Input: root = [1,2,3,4,5,6,null,null,7,8,9,10]
Output: [1,2,4,7,8,9,10,6,3]
```

## The Twist

We need to collect nodes from **three different traversals** while avoiding duplicates (nodes that appear in multiple boundaries).

## Algorithm

### Three-Step Approach:
1. **Left Boundary**: Traverse from root to leftmost leaf (always go left if possible)
2. **Leaves**: Collect all leaves (except root) using any traversal
3. **Right Boundary**: Traverse from root to rightmost leaf (always go right if possible)
4. **Combine**: Concatenate left boundary + leaves + right boundary (reverse)
5. **Remove Duplicates**: Ensure nodes aren't counted twice

## Complexity

- **Time**: O(n) - each node visited at most twice
- **Space**: O(n) - storing boundary nodes

## Link

[LeetCode 0545 Boundary of Binary Tree](https://leetcode.com/problems/boundary-of-binary-tree/)
