# 0969 Pancake Sorting

## Problem Description

Given an array of integers `arr`, sort the array by performing a series of pancake flips.

A pancake flip is performed with the following steps:
1. Choose an integer `k` where `1 <= k <= arr.length`.
2. Reverse the sub-array `arr[0...k-1]` (0-indexed).

For example, if `arr = [3,2,1,4]` and we performed a pancake flip with `k = 3`, we reverse the sub-array `[3,2,1]`, so `arr` becomes `[1,2,3,4]` after the flip.

Return an array of the k-values corresponding to a sequence of pancake flips that sort `arr`. Any valid answer that sorts the array within `10 * arr.length` flips will be judged as correct.

### Example 1:
```
Input: arr = [3,2,4,1]
Output: [4,2,4,3]
```

### Example 2:
```
Input: arr = [1,2,3]
Output: []
```

## Solution Approach

The pancake sorting algorithm works by repeatedly moving the largest unsorted element to its correct position. For each step:
1. Find the largest unsorted element.
2. Flip it to the front of the array.
3. Flip it to its correct position at the end of the unsorted portion.

## Algorithm

1. Initialize an empty result list to store the flip operations.
2. For `i` from `n` down to 1 (where `n` is the length of the array):
   - Find the index of the element that should be at position `i-1` (the largest unsorted element).
   - If this element is already at position `i-1`, continue to the next iteration.
   - If the element is not at the beginning of the array:
     - Flip the array to bring this element to the front (add its index+1 to the result).
   - Flip the array to move this element to its correct position (add `i` to the result).
3. Return the result list.

## Why This Works

By moving the largest unsorted element to its correct position in each iteration, we gradually build up the sorted array from the end. Each element is moved to its correct position with at most two flips.

## Complexity

- **Time**: O(n²) - for each of the n elements, we might search through the unsorted portion
- **Space**: O(n) - for storing the flip operations (the result)

## Link

[LeetCode 0969 Pancake Sorting](https://leetcode.com/problems/pancake-sorting/)