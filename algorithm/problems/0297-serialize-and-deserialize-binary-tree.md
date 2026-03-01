# 0297 Serialize and Deserialize Binary Tree

## Problem Description

Serialization is the process of converting a data structure or object into a sequence of bits so that it can be stored in a file or memory buffer, or transmitted across a network connection link to be reconstructed later in the same or another computer environment.

Design an algorithm to serialize and deserialize a binary tree. There is no restriction on how your serialization/deserialization algorithm should work. You just need to ensure that a binary tree can be serialized to a string and this string can be deserialized to the original tree structure.

### Example 1:
```
Input: root = [1,2,3,null,null,4,5]
Output: [1,2,3,null,null,4,5]
```

### Example 2:
```
Input: root = []
Output: []
```

## The Twist

We need to design a **custom serialization format** that can represent the tree structure including null nodes. The format should be reversible (can reconstruct the original tree).

## Algorithm

### Level Order (BFS) Serialization:
1. **Serialize**:
   - Use BFS to traverse the tree level by level
   - Add null markers for missing children
   - Join values with delimiter (e.g., comma)
2. **Deserialize**:
   - Split the string by delimiter
   - Use BFS to reconstruct level by level
   - Create nodes for non-null values, skip nulls

### Preorder DFS Serialization:
1. **Serialize**:
   - Use preorder traversal (root, left, right)
   - Add null markers for null nodes
   - Join values with delimiter
2. **Deserialize**:
   - Use a queue to track tokens
   - Recursively build tree in preorder
   - Return null for null markers

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(n) - storing the serialized string and tree

## Link

[LeetCode 0297 Serialize and Deserialize Binary Tree](https://leetcode.com/problems/serialize-and-deserialize-binary-tree/)
