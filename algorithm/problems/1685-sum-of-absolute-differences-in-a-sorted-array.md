# 1685 Sum of Absolute Differences in a Sorted Array

## Problem Description

Given an integer array `nums` sorted in non-decreasing order, return the sum of the absolute differences between all pairs of elements in the array.

### Example 1:
```
Input: nums = [1,3,6]
Output: 18
Explanation: The pairs and their differences are:
(1,3) -> 2
(1,6) -> 5
(3,6) -> 3
All pairs sum to 2 + 5 + 3 = 10.
The absolute differences are:
|1-3| = 2
|1-6| = 5
|3-1| = 2
|3-6| = 3
|6-1| = 5
|6-3| = 3
All absolute differences sum to 2 + 5 + 2 + 3 + 5 + 3 = 18.
```

### Example 2:
```
Input: nums = [1,1,3]
Output: 4
Explanation: The absolute differences are:
|1-1| = 0
|1-1| = 0
|1-3| = 2
|1-1| = 0
|1-3| = 2
|3-1| = 2
All absolute differences sum to 0 + 0 + 2 + 0 + 2 + 2 = 4.
```

## Solution Approach

Instead of calculating all pairs, we can use the sorted property to compute the sum efficiently. For each element at index `i`, the sum of absolute differences with all previous elements can be calculated using a prefix sum.

## Algorithm

1. Initialize `result` = 0 and `prefixSum` = 0.
2. For `i` from 0 to n-1:
   - The sum of absolute differences between `nums[i]` and all previous elements is:
     `nums[i] * i - prefixSum`.
   - Add this to `result`.
   - Update `prefixSum` by adding `nums[i]`.
3. Multiply `result` by 2 (since we've only counted each pair once).
4. Return `result`.

## Why This Works

Since the array is sorted, for each element `nums[i]`, all previous elements are less than or equal to it. The sum of absolute differences is simply the sum of `(nums[i] - nums[j])` for all `j < i`, which can be computed as `nums[i] * i - prefixSum`.

## Complexity

- **Time**: O(n) - single pass through the array
- **Space**: O(1) - constant extra space

## Link

[LeetCode 1685 Sum of Absolute Differences in a Sorted Array](https://leetcode.com/problems/sum-of-absolute-differences-in-a-sorted-array/)