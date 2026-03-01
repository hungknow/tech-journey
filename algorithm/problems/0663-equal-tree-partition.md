# 0663 Equal Tree Partition

## Problem Description

Given the `root` of a binary tree, return `true` if you can partition the tree into two trees with equal sums of node values. Otherwise, return `false`.

A partition is done by removing an edge in the tree such that the tree is split into two non-empty parts.

### Example 1:
```
Input: root = [5,10,10,null,null,2,3]
Output: true
Explanation: The tree can be partitioned after removing the edge between nodes 5 and 10.
```

### Example 2:
```
Input: root = [1,2,10,null,null,2,20]
Output: false
```

## The Twist

We need to find if there exists an **edge whose removal** creates two trees with equal sums. This requires calculating subtree sums for all possible partitions.

## Algorithm

### Post-order Traversal with Hash Set:
1. Use a hash set to store all subtree sums
2. For each node:
   - Calculate subtree sum recursively
   - Add sum to the set
3. Calculate total sum of the tree
4. For each subtree sum, check if (total_sum - subtree_sum) == subtree_sum
5. Return true if any such partition exists

### Using Two Passes:
1. First pass: Calculate and store all subtree sums
2. Second pass: Check if any subtree sum equals half of total sum

## Complexity

- **Time**: O(n) - single traversal
- **Space**: O(n) - storing subtree sums

## Link

[LeetCode 0663 Equal Tree Partition](https://leetcode.com/problems/equal-tree-partition/)
