# 0217 Contains Duplicate

## Problem Description

Given an integer array `nums`, return `true` if any value appears at least twice in the array, and return `false` if every element is distinct.

### Example 1:
```
Input: nums = [1,2,3,1]
Output: true
```

### Example 2:
```
Input: nums = [1,2,3,4]
Output: false
```

### Example 3:
```
Input: nums = [1,1,1,3,3,4,3,2,4,2]
Output: true
```

## The Twist

A simple duplicate detection problem. The twist is using a hash set for O(1) lookups instead of O(n²) nested loops.

## Hash Table Usage

- **Key**: `number` (the value from the array)
- **Value**: `true` (or just use a set)

Algorithm:
1. Create an empty hash set
2. Iterate through the array:
   - If the number is already in the set, return true
   - Otherwise, add it to the set
3. If we complete the loop, return false

## Complexity

- **Time**: O(n) - single pass through the array
- **Space**: O(n) - storing up to n elements in the set

## Link

[LeetCode 0217 Contains Duplicate](https://leetcode.com/problems/contains-duplicate/)
