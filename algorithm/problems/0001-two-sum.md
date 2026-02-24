# 0001 Two Sum

## Problem Description

Given an array of integers `nums` and an integer `target`, return indices of the two numbers such that they add up to `target`.

You may assume that each input would have **exactly one solution**, and you may not use the same element twice.

You can return the answer in any order.

### Example 1:
```
Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].
```

### Example 2:
```
Input: nums = [3,2,4], target = 6
Output: [1,2]
```

### Example 3:
```
Input: nums = [3,3], target = 6
Output: [0,1]
```

## The Twist

The twist is returning **indices** instead of a boolean. This means we need to track where each number appears, not just whether it exists.

## Hash Table Usage

- **Key**: `number` (the value from the array)
- **Value**: `index` (the position where the number was found)

For each number `num` at index `i`, we check if `target - num` exists in the map. If it does, we've found our pair. If not, we store `num -> i` in the map for future lookups.

## Complexity

- **Time**: O(n) - single pass through the array
- **Space**: O(n) - storing up to n elements in the hash table

## Link

[LeetCode 0001 Two Sum](https://leetcode.com/problems/two-sum/)
