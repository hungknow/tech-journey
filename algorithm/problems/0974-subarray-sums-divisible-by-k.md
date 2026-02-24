# 0974 Subarray Sums Divisible by K

## Problem Description

Given an integer array `nums` and an integer `k`, return the number of non-empty subarrays that have a sum divisible by `k`.

A subarray is a contiguous part of an array.

### Example 1:
```
Input: nums = [4,5,0,-2,-3,1], k = 5
Output: 7
Explanation: There are 7 subarrays with a sum divisible by k:
[4, 5, 0, -2, -3, 1], [5], [5, 0], [5, 0, -2, -3], [0], [0, -2, -3], [-2, -3]
```

### Example 2:
```
Input: nums = [5], k = 5
Output: 1
```

## The Twist

Similar to 0523 (Continuous Subarray Sum), but **counting occurrences** instead of just checking existence. We need to count how many subarrays have sums divisible by k.

## Hash Table Usage

- **Key**: `(prefix_sum % k)` (remainder of prefix sum divided by k)
- **Value**: `frequency` (how many times this remainder has occurred)

Algorithm:
1. Initialize map with `0 -> 1` (remainder 0 occurs once before any element)
2. Track running prefix sum
3. For each position, calculate `current_sum % k`
4. Add the frequency of this remainder to the result
5. Increment the frequency of this remainder in the map

Note: Handle negative remainders by adding k and taking modulo again.

## Complexity

- **Time**: O(n) - single pass through the array
- **Space**: O(k) - storing at most k unique remainders

## Link

[LeetCode 0974 Subarray Sums Divisible by K](https://leetcode.com/problems/subarray-sums-divisible-by-k/)
