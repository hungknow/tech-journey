# 0589 N-ary Tree Preorder Traversal

## Problem Description

Given the `root` of an n-ary tree, return the preorder traversal of its nodes' values.

N-ary tree input serialization is represented in their level order traversal, and each group of children is separated by the null value.

### Example 1:
```
Input: root = [1,null,3,2,4,null,5,6]
Output: [1,3,5,6,2,4]
```

### Example 2:
```
Input: root = [1,null,2,3,4,5,null,null,6,7,null,8,null,9,10,null,null,11,null,12,null,13,null,null,14]
Output: [1,2,3,6,7,11,14,4,8,12,5,9,13,10]
```

## The Twist

N-ary trees have **multiple children** per node. Preorder visits root first, then all children from left to right.

## Algorithm

### Recursive Approach:
1. If root is null, return empty list
2. Add root value to result
3. For each child in order: recursively traverse child

### Iterative Approach (using stack):
1. Push root onto stack
2. While stack is not empty:
   - Pop node, add to result
   - Push children onto stack in reverse order (so leftmost is processed first)

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(h) for recursive, O(n) for iterative stack

## Link

[LeetCode 0589 N-ary Tree Preorder Traversal](https://leetcode.com/problems/n-ary-tree-preorder-traversal/)
