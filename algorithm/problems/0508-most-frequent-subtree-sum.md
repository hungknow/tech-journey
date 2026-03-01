# 0508 Most Frequent Subtree Sum

## Problem Description

Given the `root` of a binary tree, return the most frequent subtree sum. If there is a tie, return all the values with the highest frequency in any order.

A subtree sum of a node is defined as the sum of all the node values formed by the subtree rooted at that node (including the node itself).

### Example 1:
```
Input: root = [5,2,-3]
Output: [2,-3,4]
Explanation:
- The sum of the subtree rooted at node 5 is 5
- The sum of the subtree rooted at node 2 is 2
- The sum of the subtree rooted at node -3 is -3
- The sum of the subtree rooted at node -3 is 4 (2 + 2 + (-3))
All sums occur twice, so return [2,-3,4] in any order.
```

### Example 2:
```
Input: root = [5,2,-5]
Output: [2]
```

## The Twist

We need to calculate **subtree sums** for all nodes and find the most frequent ones. This requires post-order traversal to compute sums bottom-up.

## Algorithm

### Post-order DFS with Hash Map:
1. Use a hash map to count subtree sums
2. For each node:
   - Calculate sum of left subtree recursively
   - Calculate sum of right subtree recursively
   - Subtree sum = left_sum + right_sum + node.val
   - Increment count for this sum in the map
3. Find the maximum frequency in the map
4. Return all sums with maximum frequency

## Complexity

- **Time**: O(n) - single traversal
- **Space**: O(n) - hash map for storing sums

## Link

[LeetCode 0508 Most Frequent Subtree Sum](https://leetcode.com/problems/most-frequent-subtree-sum/)
