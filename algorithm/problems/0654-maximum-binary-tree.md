# 0654 Maximum Binary Tree

## Problem Description

You are given an integer array `nums` with no duplicates. Construct a maximum binary tree.

A maximum binary tree is defined as follows:
- The root is the maximum number in the array.
- The left subtree is the maximum tree constructed from the subarray to the left of the maximum number.
- The right subtree is the maximum tree constructed from the subarray to the right of the maximum number.

### Example 1:
```
Input: nums = [3,2,1,6,0,5]
Output: [6,3,5,null,2,0,null,null,1]
```

### Example 2:
```
Input: nums = [3,2,1]
Output: [3,null,2,null,1]
```

## The Twist

We need to construct a **Cartesian tree** from the array where the root is always the maximum element, and subtrees are recursively constructed from the remaining subarrays.

## Algorithm

### Recursive Construction:
1. Find the maximum element and its index
2. Create a node with that value
3. Recursively construct left subtree from elements before the max
4. Recursively construct right subtree from elements after the max
5. Return the node

### Using Stack (O(n)):
1. Use a stack to maintain decreasing elements
2. For each element, pop from stack while it's greater than current
3. Set the last popped element's right to current
4. Push current onto stack
5. Build the tree from stack relationships

## Complexity

- **Time**: O(n²) naive, O(n) with stack
- **Space**: O(n) - storing the tree

## Link

[LeetCode 0654 Maximum Binary Tree](https://leetcode.com/problems/maximum-binary-tree/)
