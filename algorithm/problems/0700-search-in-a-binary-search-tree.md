# 0700 Search in a Binary Search Tree

## Problem Description

You are given the `root` of a binary search tree (BST) and an integer `val`.

Find the node in the BST that the node's value equals `val` and return the subtree rooted with that node. If such a node does not exist, return `null`.

### Example 1:
```
Input: root = [4,2,7,1,3], val = 2
Output: [2,1,3]
```

### Example 2:
```
Input: root = [4,2,7,1,3], val = 5
Output: []
```

## The Twist

Standard BST search - we leverage the **BST property** to efficiently navigate: go left for smaller values, right for larger values.

## Algorithm

### Recursive Approach:
1. If root is null or root.val == val, return root
2. If val < root.val, search left subtree
3. Else, search right subtree

### Iterative Approach:
1. While root is not null:
   - If root.val == val, return root
   - If val < root.val, root = root.left
   - Else, root = root.right
2. Return null (not found)

## Complexity

- **Time**: O(h) - h is the height of the tree (O(log n) for balanced, O(n) for skewed)
- **Space**: O(h) recursive, O(1) iterative

## Link

[LeetCode 0700 Search in a Binary Search Tree](https://leetcode.com/problems/search-in-a-binary-search-tree/)
