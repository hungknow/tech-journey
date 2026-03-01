# 2740 Find the Value of the Partition

## Problem Description

You are given an integer array `nums` and an integer `k`. Find the value of the partition such that:
- The array is partitioned into `k` segments.
- Each element in the first segment is less than or equal to every element in the second segment.
- Each element in the second segment is greater than or equal to every element in the first segment.

Return the value of the partition.

### Example 1:
```
Input: nums = [1,3,2,4], k = 2
Output: 2
Explanation: 
Partition into [1,3] and [2,4].
The value is max([1,3]) = 3.
```

### Example 2:
```
Input: nums = [1,2,3,4,5], k = 3
Output: 4
Explanation: 
Partition into [1,2,3] and [4,5].
The value is max([4,5]) = 5.
```

## Solution Approach

We need to find the partition point where the left segment has k elements and all elements in the left segment are less than or equal to all elements in the right segment.

## Algorithm

1. Sort the array.
2. For each possible partition point `i` from 1 to n-k:
   - Count elements <= nums[i] in the left segment.
   - If count == k, we found a valid partition.
3. Return `nums[i]` as the partition value.

## Why This Works

By sorting and counting elements less than or equal to each partition point, we efficiently find the partition value.

## Complexity

- **Time**: O(n log n) - sorting and counting
- **Space**: O(1) - constant extra space

## Link

[LeetCode 2740 Find the Value of the Partition](https://leetcode.com/problems/find-the-value-of-the-partition/)