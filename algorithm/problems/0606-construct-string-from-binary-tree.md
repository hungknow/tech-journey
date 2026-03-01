# 0606 Construct String from Binary Tree

## Problem Description

Given the `root` of a binary tree, construct a string consisting of parenthesis and integers from a binary tree with the preorder traversal way, and return it.

Omit all the empty parenthesis pairs that do not affect the one-to-one mapping relationship between the string and the original binary tree.

### Example 1:
```
Input: root = [1,2,3,4]
Output: "1(2(4))(3)"
```

### Example 2:
```
Input: root = [1,2,3,null,4]
Output: "1(2()(4))(3)"
```

## The Twist

We need to create a **string representation** of the tree using parentheses to show parent-child relationships. Empty parentheses pairs should be omitted for leaf nodes.

## Algorithm

### Preorder Traversal:
1. Start with an empty string
2. Perform preorder traversal
3. For each node:
   - Append node's value to the string
   - If node has any children, append '('
   - Recursively process left child (if exists)
   - Recursively process right child (if exists)
   - If node had children, append ')'
4. Return the constructed string

## Complexity

- **Time**: O(n) - single traversal of the tree
- **Space**: O(n) - storing the result string

## Link

[LeetCode 0606 Construct String from Binary Tree](https://leetcode.com/problems/construct-string-from-binary-tree/)
