# 0572 Subtree of Another Tree

## Problem Description

Given the roots of two binary trees `root` and `subRoot`, return `true` if there is a subtree in `root` with the same structure and node values of `subRoot`. Otherwise, return `false`.

A subtree of a binary tree `tree` is a tree that consists of a node in `tree` and all of this node's descendants. The tree `tree` could also be considered as a subtree of itself.

### Example 1:
```
Input: root = [3,4,5,1,2], subRoot = [4,1,2]
Output: true
```

### Example 2:
```
Input: root = [3,4,5,1,2,null,null,null,null,null,0], subRoot = [4,1,2]
Output: false
```

## Example 3:
```
Input: root = [3,4,5,1,2], subRoot = [4,1,2]
Output: true
```

## The Twist

We need to check if `subRoot` exists as a **contiguous subtree** within `root`. Both structure and values must match exactly.

## Algorithm

### Recursive Comparison:
1. If `subRoot` is null, return true (empty tree is always a subtree)
2. If `root` is null, return false (can't match non-empty subtree)
3. If `root.val != subRoot.val`, return false (values don't match)
4. Recursively check:
   - Left subtree of root vs left subtree of subRoot
   - Right subtree of root vs right subtree of subRoot
5. Return true only if both subtrees match

### Using Serialization:
1. Serialize both trees (e.g., preorder with null markers)
2. Check if subRoot's serialization is a substring of root's serialization

## Complexity

- **Time**: O(m * n) - m is nodes in subRoot, n is nodes in root
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 0572 Subtree of Another Tree](https://leetcode.com/problems/subtree-of-another-tree/)
