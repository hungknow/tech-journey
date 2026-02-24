# 0523 Continuous Subarray Sum

## Problem Description

Given an integer array `nums` and an integer `k`, return `true` if `nums` has a continuous subarray of size at least two whose elements sum up to a multiple of `k`, or `false` otherwise.

An integer `x` is a multiple of `k` if there exists an integer `n` such that `x = n * k`. `0` is always a multiple of `k`.

### Example 1:
```
Input: nums = [23,2,4,6,7], k = 6
Output: true
Explanation: [2, 4] is a continuous subarray of size 2 whose elements sum up to 6.
```

### Example 2:
```
Input: nums = [23,2,6,4,7], k = 6
Output: true
Explanation: [23, 2, 6, 4, 7] is a continuous subarray of size 5 whose elements sum up to 42.
42 is a multiple of 6 because 42 = 7 * 6 and 7 is an integer.
```

### Example 3:
```
Input: nums = [23,2,6,4,7], k = 13
Output: false
```

## The Twist

Looking for **multiples of k**. The key insight is that if two prefix sums have the same remainder when divided by k, the subarray between them sums to a multiple of k.

## Hash Table Usage

- **Key**: `(prefix_sum % k)` (remainder of prefix sum divided by k)
- **Value**: `first_seen_index` (the earliest index where this remainder occurred)

Algorithm:
1. Initialize map with `0 -> -1` (remainder 0 before any element)
2. Track running prefix sum
3. For each position, calculate `current_sum % k`
4. If this remainder exists in map and distance >= 2, return true
5. Only store the first occurrence of each remainder to maximize subarray length

## Complexity

- **Time**: O(n) - single pass through the array
- **Space**: O(min(n, k)) - storing remainders (at most k unique remainders)

## Link

[LeetCode 0523 Continuous Subarray Sum](https://leetcode.com/problems/continuous-subarray-sum/)
