# 0409 Longest Palindrome

## Problem Description

Given a string `s` which consists of lowercase or uppercase letters, return the length of the longest palindrome that can be built with those letters.

Letters are case sensitive, for example, "Aa" is not considered a palindrome here.

### Example 1:
```
Input: s = "abccccdd"
Output: 7
Explanation: One longest palindrome that can be built is "dccaccd", whose length is 7.
```

### Example 2:
```
Input: s = "a"
Output: 1
```

### Example 3:
```
Input: s = "bb"
Output: 2
```

## The Twist

Building the longest palindrome from available characters. Even counts are fully added, odd counts are added as `count - 1`, with one center character allowed.

## Hash Table Usage

- **Key**: `character` (from the string)
- **Value**: `frequency` (how many times this character appears)

Algorithm:
1. Count the frequency of each character
2. Initialize result = 0, has_odd = false
3. For each frequency:
   - Add `freq - (freq % 2)` to result (even portion)
   - If `freq % 2 == 1`, set has_odd = true
4. If has_odd is true, add 1 to result (center character)
5. Return result

## Complexity

- **Time**: O(n) - single pass through the string
- **Space**: O(1) - at most 52 characters (26 lowercase + 26 uppercase)

## Link

[LeetCode 0409 Longest Palindrome](https://leetcode.com/problems/longest-palindrome/)
