# 1680 Concatenation of Consecutive Binary Numbers

## Problem Description

Given a positive integer `n`, return the concatenated binary representation of all integers from 1 to n, in order, modulo 10^9 + 7.

### Example 1:
```
Input: n = 1
Output: 1
Explanation: "1" in binary is "1"
```

### Example 2:
```
Input: n = 3
Output: 27
Explanation: 
1 in binary is "1"
2 in binary is "10"
3 in binary is "11"
Concatenated: "1" + "10" + "11" = "11011"
"11011" in decimal is 27
```

## Solution Approach

We need to concatenate the binary representations of numbers from 1 to n and return the decimal value. Instead of actually concatenating strings, we can use bit manipulation to efficiently compute the result.

## Algorithm

1. Initialize result = 0
2. For each number i from 1 to n:
   - Find the number of bits in i (let's call it shift)
   - Left shift result by shift positions (result <<= shift)
   - Add i to result (result += i)
   - Take modulo 10^9 + 7
3. Return result

## Why This Works

When we concatenate binary numbers, we're essentially shifting the current result left by the number of bits in the new number and then adding the new number. This is equivalent to string concatenation but much more efficient.

## Complexity

- **Time**: O(n) - one pass through numbers 1 to n
- **Space**: O(1) - constant extra space

## Link

[LeetCode 1680 Concatenation of Consecutive Binary Numbers](https://leetcode.com/problems/concatenation-of-consecutive-binary-numbers/)