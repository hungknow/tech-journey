# 0076 Minimum Window Substring

## Problem Description

Given two strings `s` and `t`, return the minimum window substring of `s` such that every character in `t` (including duplicates) is included in the window. If there is no such substring, return the empty string `""`.

A substring is a contiguous sequence of characters within the string.

### Example 1:
```
Input: s = "ADOBECODEBANC", t = "ABC"
Output: "BANC"
Explanation: The minimum window substring "BANC" includes 'A', 'B', and 'C' from string t.
```

### Example 2:
```
Input: s = "a", t = "a"
Output: "a"
```

### Example 3:
```
Input: s = "a", t = "aa"
Output: ""
Explanation: Both 'a's from t must be included in the window.
```

## The Twist

Finding the **smallest window** containing all target characters. We need to expand and contract a sliding window while tracking character frequencies.

## Hash Table Usage

- **Key**: `character` (from string t)
- **Value**: `required_count` (how many times this character is needed)

Algorithm:
1. Build frequency map of characters in `t`
2. Use two pointers: `left` and `right` for window boundaries
3. Expand `right` pointer, decreasing required counts for characters found
4. When all required characters are satisfied (formed == required), try to contract from `left`
5. Track the minimum valid window found

## Complexity

- **Time**: O(n) - each character is visited at most twice
- **Space**: O(k) where k is the number of unique characters in `t`

## Link

[LeetCode 0076 Minimum Window Substring](https://leetcode.com/problems/minimum-window-substring/)
