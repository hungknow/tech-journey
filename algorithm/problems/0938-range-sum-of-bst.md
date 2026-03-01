# 0938 Range Sum of BST

## Problem Description

Given the `root` node of a binary search tree and two integers `low` and `high`, return the sum of values of all nodes with a value in the inclusive range `[low, high]`.

### Example 1:
```
Input: root = [10,5,15,3,7,null,18], low = 7, high = 15
Output: 32
Explanation: Nodes 7, 10, and 15 are in the range [7, 15]. 7 + 10 + 15 = 32.
```

### Example 2:
```
Input: root = [10,5,15,3,7,13,18,1,null,6], low = 6, high = 10
Output: 23
```

## The Twist

We can leverage the **BST property** to prune the search space - skip entire subtrees that are outside the range.

## Algorithm

### DFS with Pruning:
1. If root is null, return 0
2. Initialize sum = 0
3. If root.val >= low:
   - Add sum of left subtree (may contain values in range)
4. If root.val is within [low, high]:
   - Add root.val to sum
5. If root.val <= high:
   - Add sum of right subtree (may contain values in range)
6. Return sum

### Iterative Approach:
1. Use a stack for DFS
2. For each node, apply the same pruning logic

## Complexity

- **Time**: O(n) worst case, O(k + h) where k is nodes in range, h is height (with pruning)
- **Space**: O(h) - recursion stack or explicit stack

## Link

[LeetCode 0938 Range Sum of BST](https://leetcode.com/problems/range-sum-of-bst/)
