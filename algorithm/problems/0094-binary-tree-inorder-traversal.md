# 0094 Binary Tree Inorder Traversal

## Problem Description

Given the `root` of a binary tree, return the inorder traversal of its nodes' values.

### Example 1:
```
Input: root = [1,null,2,3]
Output: [1,3,2]
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

Inorder traversal visits nodes in the order: **left subtree → root → right subtree**. This produces a sorted order for BSTs. The challenge is to implement this efficiently, possibly using Morris Traversal for O(1) space.

## Algorithm

### Recursive Approach:
1. If root is null, return empty list
2. Recursively traverse left subtree
3. Visit root (add to result)
4. Recursively traverse right subtree

### Iterative Approach (using stack):
1. Use a stack to track nodes
2. While stack is not empty or current node is not null:
   - Go as left as possible, pushing nodes onto stack
   - Pop node, add to result
   - Move to right subtree

### Morris Traversal (O(1) space):
1. While current node is not null:
   - If current has no left child: add current to result, move to right
   - Else: find the rightmost node in left subtree
     - If its right is null: link it to current, move to left
     - Else: remove link, add current to result, move to right

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(h) for recursive/stack, O(1) for Morris Traversal

## Link

[LeetCode 0094 Binary Tree Inorder Traversal](https://leetcode.com/problems/binary-tree-inorder-traversal/)
