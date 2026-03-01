# 0179 Largest Number

## Problem Description

Given a list of non-negative integers `nums`, arrange them such that they form the largest number and return it.

Since the result may be very large, so you need to return a string instead of an integer.

### Example 1:
```
Input: nums = [10,2]
Output: "210"
```

### Example 2:
```
Input: nums = [3,30,34,5,9]
Output: "9534330"
```

## Solution Approach

The key insight is to define a custom comparator for sorting. For two numbers a and b, we should place a before b if the concatenation ab is greater than ba.

## Algorithm

1. Convert all integers to strings.
2. Sort the strings using a custom comparator:
   - For strings a and b, compare a+b with b+a.
   - If a+b > b+a, then a should come before b.
   - Otherwise, b should come before a.
3. Join the sorted strings.
4. Handle the edge case where the result might be "000...0" (e.g., input [0,0]), in which case we should return "0".

## Complexity

- **Time**: O(n log n) - dominated by the sorting step
- **Space**: O(n) - for storing the string representations

## Link

[LeetCode 0179 Largest Number](https://leetcode.com/problems/largest-number/)