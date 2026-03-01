# 2191 Sort the Jumbled Numbers

## Problem Description

You are given an integer array `mapping` where `mapping[i] = j` means digit `i` should be mapped to digit `j`.

The mapped value of an integer is obtained by replacing each digit `i` with `mapping[i]`.

Given an integer array `nums`, sort the array based on the mapped values of the integers.

### Example 1:
```
Input: mapping = [8,9,4,0,3,2,1,5], nums = [991,338,38]
Output: [338,38,991]
Explanation: 
Original: [991,338,38]
Mapped: [131,333,18]
Sorted mapped values: [18,131,333]
Corresponding original numbers: [38,991,338]
```

### Example 2:
```
Input: mapping = [0,1,2,3,4,5,6], nums = [12,13,15,14,22,23]
Output: [12,13,14,15,22,23]
Explanation: 
Original: [12,13,15,14,22,23]
Mapped: [0,1,2,3,4,5,6]
Sorted mapped values: [0,1,2,3,4,5,6]
Corresponding original numbers: [12,13,15,14,22,23]
```

## Solution Approach

We need to sort the array based on the mapped values of the integers. This requires calculating the mapped value for each number and sorting accordingly.

## Algorithm

1. Create a helper function to calculate the mapped value of a number:
   - Convert the number to a string.
   - Replace each digit with its mapped value.
   - Convert back to an integer.
2. Sort the array using a custom comparator:
   - First compare by mapped value.
   - If mapped values are equal, compare by original value.
3. Return the sorted array.

## Why This Works

By calculating and comparing mapped values, we achieve the desired sorting based on the custom mapping.

## Complexity

- **Time**: O(n × d log n) where n is the number of elements and d is the average number of digits
- **Space**: O(n) - for storing the mapped values

## Link

[LeetCode 2191 Sort the Jumbled Numbers](https://leetcode.com/problems/sort-the-jumbled-numbers/)