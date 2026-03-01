# 0075 Sort Colors

## Problem Description

Given an array `nums` with `n` objects colored red, white, or blue, sort them **in-place** so that objects of the same color are adjacent, with the colors in the order red, white, and blue.

We will use the integers `0`, `1`, and `2` to represent red, white, and blue, respectively.

You must solve this problem without using the library's sort function.

### Example 1:
```
Input: nums = [2,0,2,1,1,0]
Output: [0,0,1,1,2,2]
```

### Example 2:
```
Input: nums = [2,0,1]
Output: [0,1,2]
```

## Solution Approach

This is a classic Dutch National Flag problem. We can solve it in a single pass using three pointers to partition the array into three sections: elements less than the pivot (0), elements equal to the pivot (1), and elements greater than the pivot (2).

## Algorithm

1. Initialize three pointers:
   - `low` = 0 (start of the array)
   - `mid` = 0 (current element)
   - `high` = n-1 (end of the array)
2. While `mid` <= `high`:
   - If `nums[mid]` == 0: swap `nums[low]` and `nums[mid]`, then increment both `low` and `mid`
   - If `nums[mid]` == 1: just increment `mid`
   - If `nums[mid]` == 2: swap `nums[mid]` and `nums[high]`, then decrement `high` (don't increment `mid` as we need to check the swapped element)
3. The array is now sorted.

## Complexity

- **Time**: O(n) - single pass through the array
- **Space**: O(1) - in-place sorting with constant extra space

## Link

[LeetCode 0075 Sort Colors](https://leetcode.com/problems/sort-colors/)