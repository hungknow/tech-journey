# 0431 Encode N-ary Tree to Binary Tree

## Problem Description

Given the `root` of an N-ary tree, encode it to a binary tree and return the `root` of the binary tree.

N-ary tree input serialization is represented in their level order traversal, and each group of children is separated by the null value.

Binary tree input serialization is represented in their level order traversal, and null values are used to represent no node connection.

### Example 1:
```
Input: root = [1,null,3,2,4,null,5,6]
Output: [1,null,3,2,4,null,5,6]
```

### Example 2:
```
Input: root = [1,null,2,3,4,5,null,null,6,7,null,8,null,9,10,null,null,11,null,12,null,13,null,null,14]
Output: [1,null,2,3,4,5,null,null,6,7,null,8,null,9,10,null,null,11,null,12,null,13,null,null,14]
```

## The Twist

We need to **convert N-ary to binary tree** while preserving the ability to decode back. The encoding should be reversible.

## Algorithm

### Encoding (N-ary → Binary):
1. Use BFS to traverse the N-ary tree
2. For each node:
   - Set its left child to the first child (if any)
   - Set its right child to the next sibling (if any)
3. Build the binary tree structure

### Decoding (Binary → N-ary):
1. Use BFS to traverse the binary tree
2. For each node:
   - The left child represents the first child in N-ary
   - The right child represents the next sibling in N-ary
3. Reconstruct the N-ary tree

## Complexity

- **Time**: O(n) - single traversal
- **Space**: O(n) - storing the tree

## Link

[LeetCode 0431 Encode N-ary Tree to Binary Tree](https://leetcode.com/problems/encode-n-ary-tree-to-binary-tree/)
