# 1523 Count Odd Numbers in an Interval Range

## Problem Description

Given two non-negative integers `low` and `high`, return the number of odd numbers between `low` and `high` (inclusive).

### Example 1:
```
Input: low = 3, high = 7
Output: 3
Explanation: The odd numbers between 3 and 7 are [3,5,7].
```

### Example 2:
```
Input: low = 0, high = 10
Output: 5
Explanation: The odd numbers between 0 and 10 are [1,3,5,7,9].
```

## Solution Approach

We need to count the number of odd numbers in a given range. Instead of iterating through all numbers, we can use a mathematical formula to calculate this directly.

## Algorithm

1. Calculate the total number of integers in the range: `high - low + 1`
2. If the count is even, exactly half of them are odd
3. If the count is odd, then:
   - If `low` is odd, there are `(count + 1) / 2` odd numbers
   - If `low` is even, there are `(count - 1) / 2` odd numbers
4. Return the result

## Why This Works

This approach leverages the pattern of odd and even numbers in a sequence. By using mathematical properties, we can directly compute the count without iteration.

## Complexity

- **Time**: O(1) - constant time regardless of input size
- **Space**: O(1) - constant extra space

## Link

[LeetCode 1523 Count Odd Numbers in an Interval Range](https://leetcode.com/problems/count-odd-numbers-in-an-interval-range/)