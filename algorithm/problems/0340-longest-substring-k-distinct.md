# 0340 Longest Substring with At Most K Distinct Characters

## Problem Description

Given a string `s` and an integer `k`, return the length of the longest substring that contains at most `k` distinct characters.

### Example 1:
```
Input: s = "eceba", k = 2
Output: 3
Explanation: The substring is "ece" with length 3.
```

### Example 2:
```
Input: s = "aa", k = 1
Output: 2
Explanation: The substring is "aa" with length 2.
```

## The Twist

Same as 0159, but the map size limit is **K** instead of 2. This is a generalization where K can be any positive integer.

## Hash Table Usage

- **Key**: `character` (the character from the string)
- **Value**: `frequency` (or `rightmost_index` - the most recent position of this character)

Algorithm:
1. Use two pointers: `left` and `right` for window boundaries
2. Expand `right` pointer, adding characters to the frequency map
3. When map size exceeds K, shrink from `left` until only K distinct characters remain
4. Track the maximum window size

## Complexity

- **Time**: O(n) - each character is visited at most twice
- **Space**: O(K) - at most K+1 characters in the map at any time

## Link

[LeetCode 0340 Longest Substring with At Most K Distinct Characters](https://leetcode.com/problems/longest-substring-with-at-most-k-distinct-characters/)
