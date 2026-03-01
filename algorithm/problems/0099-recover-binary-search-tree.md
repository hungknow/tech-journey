# 0099 Recover Binary Search Tree

## Problem Description

You are given the `root` of a binary search tree (BST), where the values of exactly two nodes of the tree were swapped by mistake. Recover the tree without changing its structure.

### Example 1:
```
Input: root = [1,3,null,null,2]
Output: [3,1,null,null,2]
Explanation: 2 and 3 were swapped.
```

### Example 2:
```
Input: root = [3,1,4,null,null,2]
Output: [2,1,4,null,null,3]
Explanation: 2 and 3 were swapped.
```

## The Twist

Finding **two misplaced nodes** in a BST. In a valid BST, inorder traversal should produce sorted values. We need to identify the two nodes that violate this property and swap their values.

## Algorithm

### Inorder Traversal Approach:
1. Perform inorder traversal while tracking previous node
2. Find the first violation: node where `prev.val > curr.val` (first misplaced node)
3. Find the second violation: the next node where `prev.val > curr.val` (second misplaced node)
4. Swap the values of the two misplaced nodes

### Morris Traversal (O(1) space):
1. Use Morris inorder traversal to find the two violations
2. Track first, middle, and last nodes where BST property is violated
3. Swap values between first and last (or first and middle if only one violation pair)

## Complexity

- **Time**: O(n) - single traversal
- **Space**: O(h) for recursive/stack, O(1) for Morris Traversal

## Link

[LeetCode 0099 Recover Binary Search Tree](https://leetcode.com/problems/recover-binary-search-tree/)
