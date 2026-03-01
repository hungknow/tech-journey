# 2679 Sum in a Matrix

## Problem Description

You are given a square matrix `num` of size `n x n`. Each row is sorted in non-decreasing order.

Return the sum of the elements in the matrix.

### Example 1:
```
Input: num = [[5,1,9,2],[4,3,8]]
Output: 15
Explanation: 
The sum of all elements is 5 + 1 + 9 + 2 + 4 + 8 = 29.
```

### Example 2:
```
Input: num = [[1,2,3],[4,5],[6,7]]
Output: 13
Explanation: 
The sum of all elements is 1 + 2 + 4 + 5 + 6 + 7 = 25.
```

## Solution Approach

We need to sum all elements in the matrix. This is straightforward since the matrix is already sorted.

## Algorithm

1. Initialize `totalSum` = 0.
2. Iterate through all rows and columns:
   - Add each element to `totalSum`.
3. Return `totalSum`.

## Why This Works

Since the matrix is already sorted row-wise, we can simply iterate through all elements and accumulate their values.

## Complexity

- **Time**: O(n²) - visiting each element once
- **Space**: O(1) - constant extra space

## Link

[LeetCode 2679 Sum in a Matrix](https://leetcode.com/problems/sum-in-a-matrix/)