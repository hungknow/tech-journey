# 0325 Maximum Size Subarray Sum Equals k

## Problem Description

Given an integer array `nums` and an integer `k`, return the maximum length of a subarray that sums to `k`. If there is no such subarray, return `0`.

### Example 1:
```
Input: nums = [1,-1,5,-2,3], k = 3
Output: 4
Explanation: The subarray [1, -1, 5, -2] sums to 3 and is the longest.
```

### Example 2:
```
Input: nums = [-2,-1,2,1], k = 1
Output: 2
Explanation: The subarray [-1, 2] sums to 1 and is the longest.
```

### Example 3:
```
Input: nums = [1,2,3], k = 3
Output: 2
Explanation: The subarray [1, 2] sums to 3 and is the longest.
```

## The Twist

You need the **longest** subarray, not just any subarray. This means we need to track the first occurrence of each prefix sum to maximize the distance when we find a matching complement.

## Hash Table Usage

- **Key**: `prefix_sum` (cumulative sum up to current index)
- **Value**: `first_seen_index` (the earliest index where this prefix sum occurred)

Algorithm:
1. Initialize map with `0 -> -1` (prefix sum 0 before any element)
2. Track running prefix sum
3. For each position, check if `current_sum - k` exists in map
4. If yes, calculate length: `current_index - map[current_sum - k]`
5. Only store the first occurrence of each prefix sum to maximize length

## Complexity

- **Time**: O(n) - single pass through the array
- **Space**: O(n) - storing prefix sums and their first indices

## Link

[LeetCode 0325 Maximum Size Subarray Sum Equals k](https://leetcode.com/problems/maximum-size-subarray-sum-equals-k/)
