# 0594 Longest Harmonious Subsequence

## Problem Description

We define a harmonious array as an array where the difference between its maximum value and its minimum value is exactly 1.

Given an integer array `nums`, return the length of its longest harmonious subsequence among all its possible subsequences.

### Example 1:
```
Input: nums = [1,3,2,2,5,2,3,7]
Output: 5
Explanation: The longest harmonious subsequence is [3,2,2,2,3].
```

### Example 2:
```
Input: nums = [1,2,3,4]
Output: 2
```

### Example 3:
```
Input: nums = [1,1,1,1]
Output: 0
```

## The Twist

A harmonious subsequence consists of numbers that differ by at most 1. We need to find the maximum count of adjacent numbers (differing by 1).

## Hash Table Usage

- **Key**: `number` (the value from the array)
- **Value**: `frequency` (how many times this number appears)

Algorithm:
1. Count the frequency of each number
2. Iterate through the map:
   - For each number `num`, check if `num + 1` exists
   - If yes, calculate the length: `freq[num] + freq[num + 1]`
   - Track the maximum length
3. Return the maximum length (or 0 if no harmonious subsequence exists)

## Complexity

- **Time**: O(n) - single pass to build frequency map, single pass to find maximum
- **Space**: O(n) - storing unique numbers with their frequencies

## Link

[LeetCode 0594 Longest Harmonious Subsequence](https://leetcode.com/problems/longest-harmonious-subsequence/)
