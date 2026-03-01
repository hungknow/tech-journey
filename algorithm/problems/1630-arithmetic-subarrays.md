# 1630 Arithmetic Subarrays

## Problem Description

A sequence of numbers is called arithmetic if it consists of at least two elements, and the difference between consecutive elements is the same.

Given an array of integers `nums` and a 2D array of queries `queries`, where each query is a pair of indices `[l, r]`, return a boolean array `answer` where `answer[i]` is `true` if the subarray `nums[l..r]` is arithmetic, and `false` otherwise.

### Example 1:
```
Input: nums = [4,6,5,9,3,7], queries = [[0,2],[2,3]]
Output: [false,true]
Explanation: 
- The subarray [4,6,5] is not arithmetic (differences are 2, -1)
- The subarray [6,5,9] is arithmetic (differences are -1, 4)
```

### Example 2:
```
Input: nums = [-12,-9,-3,-12,-6,15,20,-25,-20,-15,-10], queries = [[0,1],[6,9]]
Output: [false,false]
```

## Solution Approach

For each query, we need to check if the subarray forms an arithmetic sequence. We can do this by:
1. Extracting the subarray
2. Finding the common difference
3. Verifying that all consecutive elements have this difference

## Algorithm

1. Initialize an empty answer array
2. For each query [l, r]:
   - If the subarray has less than 2 elements, append true
   - Find the minimum and maximum values in the subarray
   - Calculate the common difference d = (max - min) / (r - l)
   - If d is 0, check if all elements are the same
   - Otherwise, check if each element fits the arithmetic pattern
3. Return the answer array

## Why This Works

An arithmetic sequence has a fixed common difference. By checking that all elements follow this pattern, we verify the arithmetic property.

## Complexity

- **Time**: O(m * n) where m is the number of queries and n is the average subarray length
- **Space**: O(m) for the answer array

## Link

[LeetCode 1630 Arithmetic Subarrays](https://leetcode.com/problems/arithmetic-subarrays/)