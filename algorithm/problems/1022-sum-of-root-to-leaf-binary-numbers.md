# 1022 Sum of Root To Leaf Binary Numbers

## Problem Description

You are given the `root` of a binary tree where each node has a value `0` or `1`. Each root-to-leaf path represents a binary number starting with the most significant bit.

Return the sum of all root-to-leaf numbers.

### Example 1:
```
Input: root = [1,0,1,0,1,0,0,1]
Output: 22
Explanation: (100) + (101) + (110) + (111) + (100) + (101) = 22
```

### Example 2:
```
Input: root = [1,0,0]
Output: 4
```

### Example 3:
```
Input: root = []
Output: 0
```

## The Twist

We need to **calculate binary numbers** from root-to-leaf paths and sum them all. Each path from root to a leaf represents a binary number.

## Algorithm

### DFS with Number Building:
1. Use DFS to traverse all root-to-leaf paths
2. For each path, build the binary number:
   - Start with 0
   - For each node: number = number * 2 + node.val
3. Add each number to the total sum
4. Return the total sum

### Recursive with Accumulator:
1. Define a helper function that returns sum of all paths from a node
2. For each node:
   - If leaf, return its value
   - Otherwise, recursively sum paths from left and right children
   - Return (left_sum * 2 + node.val * 2^left_depth) + right_sum * 2^right_depth)

## Complexity

- **Time**: O(n) - each node visited once
- **Space**: O(h) - recursion stack depth

## Link

[LeetCode 1022 Sum of Root To Leaf Binary Numbers](https://leetcode.com/problems/sum-of-root-to-leaf-binary-numbers/)
