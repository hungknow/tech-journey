# 1608 Special Array With X Elements Greater Than or Equal X

## Problem Description

You are given an array `nums` of non-negative integers. `nums` is considered special if there exists a number `x` such that there are exactly `x` numbers in `nums` that are greater than or equal to `x`.

Notice that `x` does not have to be an element in `nums`.

Return `x` if the array is special, otherwise, return `-1`. It can be proven that if `nums` is special, the value for `x` is unique.

### Example 1:
```
Input: nums = [3,5]
Output: 2
Explanation: There are 2 numbers greater than or equal to 2 (3 and 5).
```

### Example 2:
```
Input: nums = [0,0]
Output: -1
Explanation: No numbers satisfy the condition for x.
```

### Example 3:
```
Input: nums = [0,4,3,0,4]
Output: 3
Explanation: There are 3 numbers greater than or equal to 3 (3, 4, and 4).
```

## Solution Approach

This is a variant of the H-Index problem. We need to find a value `x` such that exactly `x` numbers in the array are greater than or equal to `x`.

## Algorithm

1. Sort the array in descending order.
2. For `i` from 0 to n-1:
   - If `nums[i] >= i+1` and either `i == n-1` or `nums[i+1] < i+1`, then `x = i+1` is a valid solution.
3. If no such `x` is found, return -1.

## Alternative Algorithm (Counting Sort)

1. Find the maximum value in the array.
2. Create a count array of size `max + 1`.
3. Count the frequency of each number.
4. Compute the prefix sum from the end to get the count of numbers greater than or equal to each value.
5. For `x` from 0 to max:
   - If the count of numbers greater than or equal to `x` equals `x`, return `x`.
6. If no such `x` is found, return -1.

## Why This Works

After sorting in descending order, if `nums[i] >= i+1`, then there are at least `i+1` numbers greater than or equal to `i+1`. We need to ensure that `i+1` is the exact count, which is why we check the next element as well.

## Complexity

- **Time**: O(n log n) for sorting approach, O(n + m) for counting sort where m is the maximum value
- **Space**: O(1) for sorting approach, O(m) for counting sort

## Link

[LeetCode 1608 Special Array With X Elements Greater Than or Equal X](https://leetcode.com/problems/special-array-with-x-elements-greater-than-or-equal-x/)