# 2248 Intersection of Multiple Arrays

## Problem Description

You are given a 2D integer array `arrays` where `arrays[i]` is a sorted array in strictly increasing order.

Find the intersection of all the arrays, which is the set of distinct values that are present in each array.

### Example 1:
```
Input: arrays = [[3,1,2,4,6],[5,3,2,6,7]]
Output: [2,3,4,6]
Explanation: 
The intersection is [2,3,4,6].
```

### Example 2:
```
Input: arrays = [[1,2,3,4],[5,6,7,8]]
Output: []
Explanation: 
There is no common element between the two arrays.
```

## Solution Approach

We need to find the common elements across all arrays. This can be solved efficiently using a hash map or two-pointer approach.

## Algorithm

1. Use a hash map to count the frequency of each number across all arrays.
2. Collect all numbers that appear in all arrays.
3. Sort the result.
4. Return the sorted list of common numbers.

## Alternative Algorithm (Two Pointers)

1. Initialize pointers for each array at the start.
2. While both pointers are within bounds:
   - If the current elements are equal, add to result and advance both pointers.
   - If the first element is smaller, advance the first pointer.
   - Otherwise, advance the second pointer.
3. Return the result.

## Why This Works

Both approaches efficiently find the intersection of multiple sorted arrays without using excessive extra space.

## Complexity

- **Time**: O(n × m) where n is the total number of elements across all arrays and m is the number of arrays
- **Space**: O(n) - for the hash map or result list

## Link

[LeetCode 2248 Intersection of Multiple Arrays](https://leetcode.com/problems/intersection-of-multiple-arrays/)