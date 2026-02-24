# 0246 Strobogrammatic Number

## Problem Description

A strobogrammatic number is a number that looks the same when rotated 180 degrees (looked at upside down).

Given a string `num` which represents an integer, return `true` if `num` is a strobogrammatic number.

### Example 1:
```
Input: num = "69"
Output: true
```

### Example 2:
```
Input: num = "88"
Output: true
```

### Example 3:
```
Input: num = "962"
Output: false
```

## The Twist

Validating **upside-down numbers**. Only certain digit pairs are valid when rotated 180 degrees.

## Hash Table Usage

- **Key**: `digit` (a character from the number)
- **Value**: `rotated_digit` (what this digit becomes when rotated 180 degrees)

Valid pairs: `{'0':'0', '1':'1', '6':'9', '8':'8', '9':'6'}`

Algorithm:
1. Create a map of valid strobogrammatic digit pairs
2. Use two pointers: left at start, right at end
3. While left <= right:
   - Check if `num[left]` maps to `num[right]`
   - If not, return false
   - Move pointers inward
4. If we complete the loop, return true

## Complexity

- **Time**: O(n) - single pass through the string
- **Space**: O(1) - constant size map (5 entries)

## Link

[LeetCode 0246 Strobogrammatic Number](https://leetcode.com/problems/strobogrammatic-number/)
