# 0965 Univalued Binary Tree

## Problem Description

A binary tree is **univalued** if all nodes in the subtree rooted at that node have the same value.

Given the `root` of a binary tree, return `true` if the entire tree is univalued, or `false` otherwise.

### Example 1:
```
Input: root = [1,1,1,1,1,null,1]
Output: true
```

### Example 2:
```
Input: root = [2,2,2,5,2]
Output: false
```

## The Example 3:
```
Input: root = []
Output: true
```

## The Twist

We need to check if **all nodes in the tree have the same value**. This requires checking each subtree recursively.

## Algorithm

### Recursive DFS:
1. If root is null, return true
2. If left child exists and is not univalued, return false
3. If right child exists and is not univalued, return false
4. If both children exist and have different values, return false
5. Return true (all conditions passed)

### Using Post-order:
1. Check if left subtree is univalued
2. Check if right subtree is univalued
3. Check if all three values (root, left, right) are the same
4. Return true only if all conditions pass

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 0965 Univalued Binary Tree](https://leetcode.com/problems/univalued-binary-tree/)
