# 0088 Merge Sorted Array

## Problem Description

You are given two integer arrays `nums1` and `nums2`, sorted in non-decreasing order, and two integers `m` and `n`, representing the number of elements in `nums1` and `nums2` respectively.

Merge `nums1` and `nums2` into a single array sorted in non-decreasing order.

The final sorted array should not be returned by the function, but instead be stored inside the array `nums1`. To accommodate this, `nums1` has a length of `m + n`, where the first `m` elements denote the elements that should be merged, and the last `n` elements are set to 0 and should be ignored. `nums2` has a length of `n`.

### Example 1:
```
Input: nums1 = [1,2,3,0,0,0], m = 3, nums2 = [2,5,6], n = 3
Output: [1,2,2,3,5,6]
Explanation: The arrays we are merging are [1,2,3] and [2,5,6].
```

### Example 2:
```
Input: nums1 = [1], m = 1, nums2 = [], n = 0
Output: [1]
Explanation: The arrays we are merging are [1] and [].
```

## Solution Approach

The key insight is to work from the end of the arrays backward. This way, we can place the largest elements at the end of `nums1` without overwriting elements we haven't processed yet.

## Algorithm

1. Initialize three pointers:
   - `p1` = m-1 (last element of the first part of nums1)
   - `p2` = n-1 (last element of nums2)
   - `p` = m+n-1 (last position of nums1)
2. While `p1` >= 0 and `p2` >= 0:
   - If `nums1[p1]` > `nums2[p2]`: place `nums1[p1]` at `nums1[p]`, then decrement both `p1` and `p`
   - Else: place `nums2[p2]` at `nums1[p]`, then decrement both `p2` and `p`
3. If there are remaining elements in `nums2` (p2 >= 0), copy them to the beginning of `nums1`.
4. The array is now merged and sorted.

## Complexity

- **Time**: O(m + n) - single pass through both arrays
- **Space**: O(1) - in-place merging with constant extra space

## Link

[LeetCode 0088 Merge Sorted Array](https://leetcode.com/problems/merge-sorted-array/)