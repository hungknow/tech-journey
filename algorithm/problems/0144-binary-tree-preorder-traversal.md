# 0144 Binary Tree Preorder Traversal

## Problem Description

Given the `root` of a binary tree, return the preorder traversal of its nodes' values.

### Example 1:
```
Input: root = [1,null,2,3]
Output: [1,2,3]
```

### Example 2:
```
Input: root = []
Output: []
```

### Example 3:
```
Input: root = [1]
Output: [1]
```

## The Twist

Preorder traversal visits nodes in the order: **root → left subtree → right subtree**. This is useful for creating a copy of the tree or evaluating prefix expressions.

## Algorithm

### Recursive Approach:
1. If root is null, return empty list
2. Visit root (add to result)
3. Recursively traverse left subtree
4. Recursively traverse right subtree

### Iterative Approach (using stack):
1. Push root onto stack
2. While stack is not empty:
   - Pop node, add to result
   - Push right child first (so left is processed first)
   - Push left child

### Morris Traversal (O(1) space):
1. While current node is not null:
   - If current has no left child: add current to result, move to right
   - Else: find the rightmost node in left subtree
     - If its right is null: link it to current, add current to result, move to left
     - Else: remove link, move to right

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(h) for recursive/stack, O(1) for Morris Traversal

## Link

[LeetCode 0144 Binary Tree Preorder Traversal](https://leetcode.com/problems/binary-tree-preorder-traversal/)
