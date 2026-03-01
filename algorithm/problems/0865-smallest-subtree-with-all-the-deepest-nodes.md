# 0865 Smallest Subtree with all the Deepest Nodes

## Problem Description

Given the `root` of a binary tree with unique values and an integer `k`, return the smallest subtree in the binary tree that contains all the nodes with values in the inclusive range `[k, k]`.

If no such subtree exists, return `null`.

### Example 1:
```
Input: root = [3,0,4,null,2,1], k = 2
Output: [2,1,4]
Explanation: The subtree rooted at node 2 has all the values in range [2,2].
```

### Example 2:
```
Input: root = [1], k = 1
Output: [1]
```

## The Example 3:
```
Input: root = [1,2], k = 2
Output: [1,2]
```

## The Twist

We need to find the **smallest subtree** that contains all values in a specific range. The subtree must be contiguous and contain all target values.

## Algorithm

### Inorder Traversal with Sliding Window:
1. Perform inorder traversal to get sorted values
2. Use a sliding window to find the smallest contiguous subarray containing all target values
3. Find the LCA (Lowest Common Ancestor) of all nodes in this subarray
4. Return the subtree rooted at this LCA

### Post-order DFS with Tracking:
1. Use post-order DFS to calculate which nodes contain all target values
2. Track the smallest subtree that contains all target values
3. For each node, check if its subtree contains all values in [k, k]
4. Return the smallest such subtree

## Complexity

- **Time**: O(n) - single traversal
- **Space**: O(n) - storing nodes and target values

## Link

[LeetCode 0865 Smallest Subtree with all the Deepest Nodes](https://leetcode.com/problems/smallest-subtree-with-all-the-deepest-nodes/)
