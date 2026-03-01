# 0814 Binary Tree Pruning

## Problem Description

Given the `root` of a binary tree and two integers `low` and `high`, trim the tree so that all node values are in the inclusive range `[low, high]`.

Trimming the tree should not change the relative structure of the remaining nodes. (i.e., any node's original child should remain its child after trimming).

Return the root of the trimmed binary tree.

### Example 1:
```
Input: root = [1,0,2], low = 1, high = 2
Output: [1,null,2]
```

### Example 2:
```
Input: root = [3,0,4,null,2,null,null,1], low = 1, high = 3
Output: [3,null,4,null,2]
```

### Example 3:
```
Input: root = [1], low = 1, high = 2
Output: [1]
```

## The Twist

We need to **remove nodes outside the range** while maintaining the tree structure. If a node is removed, its entire subtree should be removed.

## Algorithm

### Recursive Pruning:
1. If root is null, return null
2. If root.val < low, return prune(root.right) (entire left subtree is out of range)
3. If root.val > high, return prune(root.left) (entire right subtree is out of range)
4. Otherwise:
   - Recursively prune left child
   - Recursively prune right child
   - Return root (with pruned children)

## Complexity

- **Time**: O(n) - each node visited at most once
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 0814 Binary Tree Pruning](https://leetcode.com/problems/binary-tree-pruning/)
