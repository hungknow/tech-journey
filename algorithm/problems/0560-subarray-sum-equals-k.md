# 0560 Subarray Sum Equals K

## Problem Description

Given an integer array `nums` and an integer `k`, return the total number of subarrays whose sum equals to `k`.

### Example 1:
```
Input: nums = [1,1,1], k = 2
Output: 2
```

### Example 2:
```
Input: nums = [1,2,3], k = 3
Output: 2
```

## The Twist

You need the **total count** of subarrays, not the longest. This means we need to count how many times each prefix sum has occurred, not just track the first occurrence.

## Hash Table Usage

- **Key**: `prefix_sum` (cumulative sum up to current index)
- **Value**: `frequency` (how many times this prefix sum has occurred)

Algorithm:
1. Initialize map with `0 -> 1` (prefix sum 0 occurs once before any element)
2. Track running prefix sum
3. For each position, check how many times `current_sum - k` has occurred
4. Add that count to the result
5. Increment the frequency of `current_sum` in the map

## Complexity

- **Time**: O(n) - single pass through the array
- **Space**: O(n) - storing prefix sums and their frequencies

## Link

[LeetCode 0560 Subarray Sum Equals K](https://leetcode.com/problems/subarray-sum-equals-k/)
