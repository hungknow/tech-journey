# 0889 Construct Binary Tree from Preorder and Postorder Traversal

## Problem Description

Given two integer arrays, `preorder` and `postorder` where `preorder` is the preorder traversal of a binary tree with distinct values and `postorder` is the postorder traversal of the same tree, reconstruct and return the binary tree.

If there exist multiple answers, return any of them.

### Example 1:
```
Input: preorder = [1,2,4,5,3,6,7], postorder = [4,5,2,6,7,3,1]
Output: [1,2,3,4,5,6,7]
```

### Example 2:
```
Input: preorder = [1], postorder = [1]
Output: [1]
```

## The Twist

Constructing a tree from preorder and postorder is **ambiguous** for general binary trees (multiple valid trees possible). The first element of preorder is always the root, and the last element of postorder is always the root.

## Algorithm

### Recursive Approach:
1. First element of preorder is the root
2. Second element of preorder is the root of left subtree
3. Find this element in postorder - everything before it is left subtree
4. Recursively construct left and right subtrees
5. Return root

### Using Hash Map for O(1) lookup:
1. Build a map from postorder values to their indices
2. Use the map to quickly find the boundary between left and right subtrees

## Complexity

- **Time**: O(n²) naive, O(n) with hash map
- **Space**: O(n) - storing the tree and hash map

## Link

[LeetCode 0889 Construct Binary Tree from Preorder and Postorder Traversal](https://leetcode.com/problems/construct-binary-tree-from-preorder-and-postorder-traversal/)
