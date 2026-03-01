# 0897 Increasing Order Search Tree

## Problem Description

Given the `root` of a binary search tree, rearrange the tree in in-order so that the leftmost node in the tree is now the root of the tree, and every node has no left child and only one right child.

### Example 1:
```
Input: root = [5,3,6,2,4,null,8,1,null,null,null,7,9]
Output: [1,null,2,null,3,null,4,null,5,null,6,null,7,null,8,null,9]
```

### Example 2:
```
Input: root = [5,1,7]
Output: [1,null,5,null,7]
```

## The Twist

We need to flatten the BST into a **right-skewed tree** where each node only has a right child. This is essentially creating a linked list from inorder traversal.

## Algorithm

### Inorder Traversal with Re-linking:
1. Perform inorder traversal
2. Keep track of `prev` node
3. For each node:
   - Set prev.right = current
   - Set current.left = null
   - Update prev = current
4. Return the first node (leftmost) as new root

### Recursive Approach:
1. Recursively flatten left subtree, get new left root
2. Recursively flatten right subtree, get new right root
3. If left root exists:
   - Find the rightmost node of left root
   - Connect it to current node
   - Set current.left = null
4. Connect current to right root
5. Return left root (or current if no left root)

## Complexity

- **Time**: O(n) - single traversal
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 0897 Increasing Order Search Tree](https://leetcode.com/problems/increasing-order-search-tree/)
