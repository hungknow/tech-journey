# 1588 Sum of All Odd Length Subarrays

## Problem Description

Given an array of positive integers `arr`, return the sum of all possible odd-length subarrays of `arr`.

A subarray is a contiguous subsequence of the array.

### Example 1:
```
Input: arr = [1,4,2,5,3]
Output: 58
Explanation: The odd-length subarrays of arr and their sums are:
[1] = 1
[4] = 4
[2] = 2
[5] = 5
[3] = 3
[1,4,2] = 7
[4,2,5] = 11
[2,5,3] = 10
[1,4,2,5,3] = 15
If we add all these together we get 1 + 4 + 2 + 5 + 3 + 7 + 11 + 10 + 15 = 58
```

### Example 2:
```
Input: arr = [1,2]
Output: 3
Explanation: There are only 2 odd-length subarrays: [1] and [2]. Their sum is 3.
```

## Solution Approach

We need to find the sum of all odd-length subarrays. Instead of generating all subarrays, we can use a mathematical approach to calculate how many times each element appears in odd-length subarrays.

## Algorithm

1. Initialize result to 0
2. For each element at index i:
   - Calculate how many subarrays include this element
   - Calculate how many of these subarrays have odd length
   - Multiply the element value by the count of odd-length subarrays it appears in
   - Add this to the result
3. Return the result

## Why This Works

Each element at index i appears in (i+1) * (n-i) subarrays total. The number of odd-length subarrays containing this element is the total number of subarrays divided by 2 (rounded up).

## Complexity

- **Time**: O(n) - one pass through the array
- **Space**: O(1) - constant extra space

## Link

[LeetCode 1588 Sum of All Odd Length Subarrays](https://leetcode.com/problems/sum-of-all-odd-length-subarrays/)