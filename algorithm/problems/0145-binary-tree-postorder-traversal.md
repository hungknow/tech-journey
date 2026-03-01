# 0145 Binary Tree Postorder Traversal

## Problem Description

Given the `root` of a binary tree, return the postorder traversal of its nodes' values.

### Example 1:
```
Input: root = [1,null,2,3]
Output: [3,2,1]
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

Postorder traversal visits nodes in the order: **left subtree → right subtree → root**. This is useful for deleting a tree or evaluating postfix expressions.

## Algorithm

### Recursive Approach:
1. If root is null, return empty list
2. Recursively traverse left subtree
3. Recursively traverse right subtree
4. Visit root (add to result)

### Iterative Approach (using two stacks):
1. Push root onto stack1
2. While stack1 is not empty:
   - Pop node from stack1, push to stack2
   - Push left child to stack1
   - Push right child to stack1
3. Pop all nodes from stack2 to get postorder

### Iterative Approach (single stack with visited flag):
1. Use stack with (node, visited) pairs
2. While stack is not empty:
   - If node is null, continue
   - If visited is true: add to result
   - Else: push (node, true), then push right, then push left

### Morris Traversal (O(1) space):
1. Use modified Morris traversal by reversing the right subtree after processing

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(h) for recursive/stack, O(1) for Morris Traversal

## Link

[LeetCode 0145 Binary Tree Postorder Traversal](https://leetcode.com/problems/binary-tree-postorder-traversal/)
