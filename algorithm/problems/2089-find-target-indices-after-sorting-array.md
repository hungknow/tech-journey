# 2089 Find Target Indices After Sorting Array

## Problem Description

Given an integer array `nums`, sort the array in non-decreasing order.

Return the indices of the target value after sorting. The indices should be zero-based.

### Example 1:
```
Input: nums = [1,2,5,2,3], target = 2
Output: [1,2]
Explanation: 
After sorting: [1,2,2,3,5]
The indices of value 2 are 1 and 2.
```

### Example 2:
```
Input: nums = [1,2,3,4,5], target = 3
Output: [2,3]
Explanation: 
After sorting: [1,2,3,4,5]
The indices of value 3 are 2 and 3.
```

### Example 3:
```
Input: nums = [1,2,3,4,5], target = 6
Output: []
Explanation: 
After sorting: [1,2,3,4,5]
No element equals 6, so no indices are returned.
```

## Solution Approach

We need to find the indices of the target value in the sorted array. This can be solved efficiently using binary search.

## Algorithm

1. Sort the array in non-decreasing order.
2. For each element at index `i`:
   - If `nums[i] == target`, add `i` to the result list.
3. Return the result list.

## Alternative Algorithm (Counting Sort)

1. Find the minimum and maximum values in the array.
2. Create a count array of size (max - min + 1).
3. Count the frequency of each value.
4. Compute prefix sums of the count array.
5. For each value from min to target:
   - The indices of this value are from `prefixSum[value-1] + 1` to `prefixSum[value]`.
6. Return the collected indices.

## Why This Works

By sorting and using binary search or counting sort, we efficiently find all occurrences of the target value.

## Complexity

- **Time**: O(n log n) for sorting and binary search, O(n + m) for counting sort where m is the range of values
- **Space**: O(n) for the result list or count array

## Link

[LeetCode 2089 Find Target Indices After Sorting Array](https://leetcode.com/problems/find-target-indices-after-sorting-array/)