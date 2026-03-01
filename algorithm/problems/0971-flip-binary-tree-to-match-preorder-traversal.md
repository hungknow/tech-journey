# 0971 Flip Binary Tree To Match Preorder Traversal

## Problem Description

You are given the `root` of a binary tree with `n` nodes, where each node is uniquely assigned a value from `1` to `n`. You are also given a sequence of `n` values `voyage`, which is the desired preorder traversal of the binary tree.

Any node in the binary tree can be flipped by swapping its left and right subtrees.

Return a list of the values of all flipped nodes in any order. If it is impossible to flip nodes to match `voyage`, return `[-1]`.

### Example 1:
```
Input: root = [1,2], voyage = [2,1]
Output: [-1]
```

### Example 2:
```
Input: root = [1,2,3], voyage = [1,3,2]
Output: [1]
```

### Example 3:
```
Input: root = [1,2,3], voyage = [1,2,3]
Output: []
```

## The Twist

We can **flip nodes** (swap left and right children) to match a target preorder traversal. We need to find which nodes to flip, or determine if it's impossible.

## Algorithm

### DFS with Index Tracking:
1. Use a global index to track position in voyage array
2. For each node:
   - If node value doesn't match voyage[index], impossible → return [-1]
   - If left child exists and doesn't match voyage[index+1]:
     - Flip the node (swap children)
     - Add node value to flip list
   - Recursively traverse left and right subtrees
3. Return flip list

## Complexity

- **Time**: O(n) - single DFS traversal
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 0971 Flip Binary Tree To Match Preorder Traversal](https://leetcode.com/problems/flip-binary-tree-to-match-preorder-traversal/)
