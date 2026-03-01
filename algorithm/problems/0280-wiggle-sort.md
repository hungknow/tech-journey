# 0280 Wiggle Sort

## Problem Description

Given an integer array `nums`, reorder it such that `nums[0] <= nums[1] >= nums[2] <= nums[3]...`.

You may assume the input array always has a valid answer.

### Example 1:
```
Input: nums = [3,5,2,1,6,4]
Output: [3,5,1,6,2,4]
Explanation: [1,6,2,5,3,4] is also a valid answer.
```

### Example 2:
```
Input: nums = [6,6,5,6,3,8]
Output: [6,6,5,6,3,8]
```

## Solution Approach

The key insight is that we can achieve the wiggle pattern by ensuring that every element at an odd index is greater than or equal to its neighbors, and every element at an even index is less than or equal to its neighbors.

## Algorithm

1. Iterate through the array starting from index 1:
   - For odd indices (i is odd), ensure `nums[i] >= nums[i-1]`. If not, swap them.
   - For even indices (i is even), ensure `nums[i] <= nums[i-1]`. If not, swap them.
2. This single pass through the array will create the wiggle pattern.

## Why This Works

When we process each element, we only need to ensure it maintains the wiggle property with its immediate predecessor. By fixing each position as we go, we guarantee that the entire array follows the wiggle pattern.

## Complexity

- **Time**: O(n) - single pass through the array
- **Space**: O(1) - in-place swapping with constant extra space

## Link

[LeetCode 0280 Wiggle Sort](https://leetcode.com/problems/wiggle-sort/)