# 0637 Average of Levels in Binary Tree

## Problem Description

Given the `root` of a binary tree, return the average value of the nodes on each level in the form of an array. Answers within 10-5 of the actual answer will be accepted.

### Example 1:
```
Input: root = [3,9,20,null,null,15,7]
Output: [3.00000,14.50000,11.00000]
Explanation: The average value of nodes on level 0 is 3, on level 1 is 14.5, and on level 2 is 11.
```

### Example 2:
```
Input: root = [3,9,20,15,7]
Output: [3.00000,14.50000,11.00000]
```

## The Twist

We need to **calculate averages for each level** of the tree. This requires BFS to process nodes level by level.

## Algorithm

### BFS Level Order Traversal:
1. Use BFS to traverse the tree level by level
2. For each level:
   - Calculate the sum of all node values
   - Calculate the average: sum / count
   - Add average to result
3. Return the list of averages

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(w) - queue width for BFS

## Link

[LeetCode 0637 Average of Levels in Binary Tree](https://leetcode.com/problems/average-of-levels-in-binary-tree/)
