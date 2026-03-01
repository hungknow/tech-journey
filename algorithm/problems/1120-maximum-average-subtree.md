# 1120 Maximum Average Subtree

## Problem Description

Given the `root` of a binary tree, return the maximum average value of any subtree in the tree.

The average value of a subtree is the sum of all node values in the subtree divided by the number of nodes in the subtree.

### Example 1:
```
Input: root = [1,3,-1,-1]
Output: 1.00000
Explanation: The subtree rooted at node 3 has the maximum average (3 / 3 = 1).
```

### Example 2:
```
Input: root = [1,-1,2,-1]
Output: 1.00000
Explanation: The subtree rooted at node 2 has the maximum average (2 / 2 = 1).
```

## The Twist

We need to find the **maximum average** across all subtrees. This requires calculating both the sum and count of nodes for each subtree.

## Algorithm

### Post-order DFS with Tracking:
1. For each node, calculate (sum, count) of its subtree
2. Calculate average = sum / count
3. Track the maximum average seen
4. Return the maximum average

### Using Global Variables:
1. Define a helper that returns (sum, count) for a subtree
2. For each node:
   - Get (left_sum, left_count) from left subtree
   - Get (right_sum, right_count) from right subtree
   - Calculate (sum, count) for current node
   - Update global max average
3. Return the maximum average

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 1120 Maximum Average Subtree](https://leetcode.com/problems/maximum-average-subtree/)
