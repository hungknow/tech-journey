# 0324 Wiggle Sort II

## Problem Description

Given an integer array `nums`, reorder it such that `nums[0] < nums[1] > nums[2] < nums[3]...`.

You may assume the input array always has a valid answer.

### Example 1:
```
Input: nums = [1,5,1,1,6,4]
Output: [1,6,1,5,1,4]
Explanation: [1,4,1,5,1,6] is also a valid answer.
```

### Example 2:
```
Input: nums = [1,3,2,2,3,1]
Output: [2,3,1,3,1,2]
```

## Solution Approach

This is a more complex version of Wiggle Sort. The key insight is to first find the median and then place elements larger than the median at odd indices and elements smaller than the median at even indices.

## Algorithm

1. Find the median of the array using quickselect (O(n) average time).
2. Create a virtual indexed array to help with placement:
   - For index `i`, the virtual index is `(1 + 2*i) % (n | 1)`
   - This maps indices in the order: 1, 3, 5, ..., 0, 2, 4, ...
3. Use three-way partitioning (Dutch National Flag) to place elements:
   - Elements greater than the median go to the first part (odd indices)
   - Elements equal to the median go to the middle
   - Elements less than the median go to the last part (even indices)
4. Iterate through the virtual indices and place elements accordingly.

## Why This Works

By placing larger elements at odd indices and smaller elements at even indices, we ensure the wiggle pattern `nums[0] < nums[1] > nums[2] < nums[3]...` is maintained.

## Complexity

- **Time**: O(n) on average - quickselect to find the median and a single pass for partitioning
- **Space**: O(1) - in-place rearrangement with constant extra space

## Link

[LeetCode 0324 Wiggle Sort II](https://leetcode.com/problems/wiggle-sort-ii/)