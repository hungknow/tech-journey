# 0428 Serialize and Deserialize N-ary Tree

## Problem Description

Serialization is the process of converting a data structure or object into a sequence of bits so that it can be stored in a file or memory buffer, or transmitted across a network connection link to be reconstructed later in the same or another computer environment.

Design an algorithm to serialize and deserialize an N-ary tree. An N-ary tree is a rooted tree where each node has at most N children.

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

N-ary trees have **variable number of children** per node. We need to encode both the node values and the structure (which children belong to which parent).

## Algorithm

### Preorder DFS with Child Count:
1. **Serialize**:
   - Use preorder traversal
   - For each node: write value, then number of children
   - Recursively serialize all children
2. **Deserialize**:
   - Read value and child count
   - Create node
   - Recursively deserialize children based on count

### Using Special Delimiters:
1. **Serialize**:
   - Use preorder with special markers
   - Use delimiter to separate values
   - Use another delimiter to mark end of children
2. **Deserialize**:
   - Parse the string recursively
   - Build tree based on delimiters

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(n) - storing the serialized string and tree

## Link

[LeetCode 0428 Serialize and Deserialize N-ary Tree](https://leetcode.com/problems/serialize-and-deserialize-n-ary-tree/)
