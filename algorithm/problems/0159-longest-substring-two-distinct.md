# 0159 Longest Substring with At Most Two Distinct Characters

## Problem Description

Given a string `s`, return the length of the longest substring that contains at most two distinct characters.

### Example 1:
```
Input: s = "eceba"
Output: 3
Explanation: The substring is "ece" which its length is 3.
```

### Example 2:
```
Input: s = "ccaabbb"
Output: 5
Explanation: The substring is "aabbb" which its length is 5.
```

## The Twist

Constrained to exactly **two character types**. When a third distinct character is encountered, we must shrink the window until only two distinct characters remain.

## Hash Table Usage

- **Key**: `character` (the character from the string)
- **Value**: `frequency` (or `rightmost_index` - the most recent position of this character)

Algorithm:
1. Use two pointers: `left` and `right` for window boundaries
2. Expand `right` pointer, adding characters to the frequency map
3. When map size exceeds 2, shrink from `left` until only 2 distinct characters remain
4. Track the maximum window size

## Complexity

- **Time**: O(n) - each character is visited at most twice
- **Space**: O(1) - at most 3 characters in the map at any time

## Link

[LeetCode 0159 Longest Substring with At Most Two Distinct Characters](https://leetcode.com/problems/longest-substring-with-at-most-two-distinct-characters/)
