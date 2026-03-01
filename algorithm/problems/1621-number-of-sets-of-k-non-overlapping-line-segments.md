# 1621 Number of Sets of K Non-Overlapping Line Segments

## Problem Description

Given `n` points on a line, where the i-th point is at position `i`, find the number of ways to draw `k` non-overlapping line segments such that each segment connects two points and no two segments share a common point.

Return the answer modulo 10^9 + 7.

### Example 1:
```
Input: n = 4, k = 2
Output: 5
Explanation: The 5 ways are:
(1,3) and (2,4)
(1,2) and (3,4)
(1,2) and (2,3)
(2,3) and (3,4)
(1,2) and (2,3) and (3,4)
```

### Example 2:
```
Input: n = 3, k = 1
Output: 3
Explanation: The 3 ways are:
(1,2)
(2,3)
(1,3)
```

## Solution Approach

This is a combinatorial problem that can be solved using dynamic programming. We need to count the number of ways to place k non-overlapping segments among n points.

## Algorithm

1. Use dynamic programming where dp[i][j] represents the number of ways to place j segments using the first i points
2. Initialize dp[0][0] = 1 (base case)
3. For each point i from 1 to n:
   - For each number of segments j from 0 to k:
     - Don't place a segment ending at i: dp[i][j] += dp[i-1][j]
     - Place a segment ending at i: dp[i][j] += dp[i-2][j-1] * (i-1)
4. Return dp[n][k] modulo 10^9 + 7

## Why This Works

The DP state captures the subproblem of placing segments up to a certain point. When we place a segment ending at point i, we need to choose a starting point from the previous points, which gives us the (i-1) multiplier.

## Complexity

- **Time**: O(n * k) - nested loops through n and k
- **Space**: O(n * k) - DP table

## Link

[LeetCode 1621 Number of Sets of K Non-Overlapping Line Segments](https://leetcode.com/problems/number-of-sets-of-k-non-overlapping-line-segments/)