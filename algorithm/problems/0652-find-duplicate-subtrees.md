# 0652 Find Duplicate Subtrees

## Problem Description

Given the `root` of a binary tree, return all duplicate subtrees.

For each kind of duplicate subtrees, you only need to return the root node of any one of them.

Two trees are duplicate if they have the same structure with the same node values.

### Example 1:
```
Input: root = [1,2,3,4,null,2,4,null,null,4]
Output: [[2,4],[4]]
```

### Example 2:
```
Input: root = [2,1,1]
Output: [[1]]
```

## Example 3:
```
Input: root = [2,2,2,3,null,3,null]
Output: [[2,3],[3]]
```

## The Twist

We need to find **all duplicate subtrees** and return their roots. We can use serialization or a unique identifier for each subtree to detect duplicates.

## Algorithm

### Post-order Traversal with Hash Map:
1. Use a hash map to count subtree signatures
2. For each node:
   - Get signatures of left and right subtrees
   - Create current node's signature: (left_sig, val, right_sig)
   - Increment count for this signature
3. Return the signature
4. After traversal, return all nodes whose signature count > 1

### Using String Serialization:
1. Serialize each subtree to a string (e.g., preorder with null markers)
2. Use a hash map to count occurrences of each serialization
3. Return roots of subtrees with count > 1

## Complexity

- **Time**: O(n²) - each node's serialization may be O(n)
- **Space**: O(n²) - storing all serializations

## Link

[LeetCode 0652 Find Duplicate Subtrees](https://leetcode.com/problems/find-duplicate-subtrees/)
