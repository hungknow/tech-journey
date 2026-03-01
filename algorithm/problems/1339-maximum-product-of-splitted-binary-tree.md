# 1339 Maximum Product of Splitted Binary Tree

## Problem Description

Given the `root` of a binary tree, split the binary tree into two subtrees by removing one edge. Return the maximum product of the number of nodes in the two subtrees.

Since the answer can be large, return it modulo `10^9 + 7`.

### Example 1:
```
Input: root = [1,2,3,4,5,6]
Output: 110
Explanation: Remove the edge 3-4 to get two subtrees with products 36 (4*9) and 40 (5*8). The maximum product is 1440.
```

### Example 2:
```
Input: root = [1,null,2,3,4,null,null,5]
Output: 90
```

### Example 3:
```
Input: root = [1,2,3]
Output: 2
```

## The Twist

We need to find the **maximum product** of node counts when splitting the tree by removing one edge. This requires calculating the sum of all nodes and the sum of nodes in each subtree for every possible split.

## Algorithm

### Post-order DFS with Total Sum Tracking:
1. Calculate the total sum of all node values
2. For each edge in the tree:
   - Calculate the sum of the subtree that would be created by removing that edge
   - Calculate the product: subtree_sum * (total_sum - subtree_sum)
   - Track the maximum product
3. Return the maximum product modulo 10^9 + 7

### Using Hash Map for Subtree Sums:
1. Use a hash map to store subtree sums (memoization)
2. For each edge, calculate the subtree sum using the map
3. Calculate the product and track the maximum

## Complexity

- **Time**: O(n) - single traversal
- **Space**: O(n) - storing subtree sums

## Link

[LeetCode 1339 Maximum Product of Splitted Binary Tree](https://leetcode.com/problems/maximum-product-of-splitted-binary-tree/)
