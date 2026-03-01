# 0538 Convert BST to Greater Tree

## Problem Description

Given the `root` of a Binary Search Tree (BST), convert it to a Greater Tree such that every key of the original BST is changed to the original key plus the sum of all keys greater than the original key in BST.

As a reminder, a binary search tree is a tree that satisfies these constraints:
- The left subtree of a node contains only nodes with keys less than the node's key.
- The right subtree of a node contains only nodes with keys greater than the node's key.
- Both the left and right subtrees must also be binary search trees.

### Example 1:
```
Input: root = [4,1,6,0,2,5,7,null,null,null,3,null,null,null,8]
Output: [30,36,21,36,35,26,15,null,null,null,33,null,null,null,8]
```

### Example 2:
```
Input: root = [0,null,1]
Output: [1,null,1]
```

## The Twist

We need to add the **sum of all greater values** to each node. Since it's a BST, we can use reverse inorder (right → root → left) to accumulate the sum.

## Algorithm

### Reverse Inorder Traversal:
1. Traverse in reverse inorder order: right → root → left
2. Maintain a running sum of all visited nodes
3. For each node:
   - Add running sum to node's value
   - Update running sum with the new value
4. Return the modified tree

## Complexity

- **Time**: O(n) - single traversal
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 0538 Convert BST to Greater Tree](https://leetcode.com/problems/convert-bst-to-greater-tree/)
