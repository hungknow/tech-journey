# 0219 Contains Duplicate II

## Problem Description

Given an integer array `nums` and an integer `k`, return `true` if there are two distinct indices `i` and `j` in the array such that `nums[i] == nums[j]` and `abs(i - j) <= k`.

### Example 1:
```
Input: nums = [1,2,3,1], k = 3
Output: true
```

### Example 2:
```
Input: nums = [1,0,1,1], k = 1
Output: true
```

### Example 3:
```
Input: nums = [1,2,3,1,2,3], k = 2
Output: false
```

## The Twist

Needs duplicates **within distance k**. We need to track not just whether a number exists, but also where it was last seen.

## Hash Table Usage

- **Key**: `number` (the value from the array)
- **Value**: `last_seen_index` (the most recent position where this number appeared)

Algorithm:
1. Create an empty hash map
2. Iterate through the array with index i:
   - If the number exists in the map and `i - last_seen_index <= k`, return true
   - Otherwise, update the map with `number -> i`
3. If we complete the loop, return false

## Complexity

- **Time**: O(n) - single pass through the array
- **Space**: O(min(n, k)) - storing at most k+1 elements (or n if k > n)

## Link

[LeetCode 0219 Contains Duplicate II](https://leetcode.com/problems/contains-duplicate-ii/)
