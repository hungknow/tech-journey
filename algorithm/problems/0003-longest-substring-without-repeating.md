# 0003 Longest Substring Without Repeating Characters

## Problem Description

Given a string `s`, find the length of the longest substring without repeating characters.

### Example 1:
```
Input: s = "abcabcbb"
Output: 3
Explanation: The answer is "abc", with the length of 3.
```

### Example 2:
```
Input: s = "bbbbb"
Output: 1
Explanation: The answer is "b", with the length of 1.
```

### Example 3:
```
Input: s = "pwwkew"
Output: 3
Explanation: The answer is "wke", with the length of 3.
```

## The Twist

Dynamic window without duplicates. We need to maintain a sliding window that expands and contracts to ensure no character appears more than once within the window.

## Hash Table Usage

- **Key**: `character` (the character from the string)
- **Value**: `last_seen_index` (the most recent position where this character appeared)

Algorithm:
1. Use two pointers: `left` and `right` for the window boundaries
2. Expand `right` pointer, adding characters to the window
3. When a duplicate is found (character exists in map and index >= left), move `left` to `last_seen_index + 1`
4. Update the character's last seen index
5. Track the maximum window size

## Complexity

- **Time**: O(n) - each character is visited at most twice
- **Space**: O(min(m, n)) where m is the character set size (e.g., 26 for lowercase letters)

## Link

[LeetCode 0003 Longest Substring Without Repeating Characters](https://leetcode.com/problems/longest-substring-without-repeating-characters/)
