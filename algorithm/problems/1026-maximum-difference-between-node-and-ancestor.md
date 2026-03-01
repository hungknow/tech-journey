# 1026 Maximum Difference Between Node and Ancestor

## Problem Description

Given the `root` of a binary tree, find the maximum value `v` for which there exist different nodes `a` and `b` where `v = |a.val - b.val|` and node `a` is an ancestor of node `b`.

A node `a` is an ancestor of node `b` if either:
- Node `a` is the same node as node `b`, or
- Any child of `a` is an ancestor of node `b`.

### Example 1:
```
Input: root = [8,3,10,1,6,null,14,13,null,7]
Output: 7
Explanation: The ancestor node with value 7 has the maximum difference with node 13.
```

### Example 2:
```
Input: root = [1,null,2,null,0]
Output: 2
```

## The Twist

We need to find the **maximum difference** between any node and its ancestor. This requires tracking the minimum and maximum values along each path.

## Algorithm

### DFS with Min/Max Tracking:
1. Define a helper function that returns (min, max) for a subtree
2. For each node:
   - Get min/max from left subtree
   - Get min/max from right subtree
   - Calculate current min/max including node.val
   - Return (current_min, current_max)
3. For each node, calculate the maximum difference:
   - max_diff = max(node.val - min_left, node.val - min_right, max_left - node.val, max_right - node.val)
4. Track the global maximum difference

### Post-order Approach:
1. Perform post-order traversal
2. For each node, calculate the min and max in its subtree
3. Update global max difference using node's value and subtree min/max

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 1026 Maximum Difference Between Node and Ancestor](https://leetcode.com/problems/maximum-difference-between-node-and-ancestor/)
