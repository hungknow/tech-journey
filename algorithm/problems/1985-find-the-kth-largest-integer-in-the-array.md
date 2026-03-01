# 1985 Find the Kth Largest Integer in the Array

## Problem Description

You are given an integer array `nums` and an integer `k`. Return the kth largest integer in the array.

### Example 1:
```
Input: nums = [3,2,1,5,6,4], k = 2
Output: 5
Explanation: 
The 2nd largest integer is 5.
```

### Example 2:
```
Input: nums = [3,2,3,1,2,4,5,5,6], k = 4
Output: 4
Explanation: 
The 4th largest integer is 4.
```

## Solution Approach

We need to find the kth largest integer in the array. This can be solved using quickselect or a min-heap.

## Algorithm (Quickselect)

1. Implement quickselect to find the kth largest element:
   - Choose a pivot.
   - Partition the array into three parts: less than pivot, equal to pivot, greater than pivot.
   - Recursively select the appropriate partition.
2. Return the kth largest element.

## Alternative Algorithm (Min-Heap)

1. Create a min-heap of size k.
2. Iterate through the array:
   - If the heap has fewer than k elements, add the current element.
   - If the heap has k elements and the current element is larger than the smallest element, replace the smallest.
3. Return the smallest element in the heap.

## Why This Works

Quickselect efficiently finds the kth largest element in average O(n) time. The min-heap approach is also efficient and easier to implement.

## Complexity

- **Time**: O(n) on average for quickselect, O(n log k) for heap approach
- **Space**: O(1) for quickselect (in-place), O(k) for heap approach

## Link

[LeetCode 1985 Find the Kth Largest Integer in the Array](https://leetcode.com/problems/find-the-kth-largest-integer-in-the-array/)