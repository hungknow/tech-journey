# 0438 Find All Anagrams in a String

## Problem Description

Given two strings `s` and `p`, return an array of all the start indices of `p`'s anagrams in `s`. You may return the answer in any order.

An Anagram is a word or phrase formed by rearranging the letters of a different word or phrase, typically using all the original letters exactly once.

### Example 1:
```
Input: s = "cbaebabacd", p = "abc"
Output: [0,6]
Explanation:
- The substring starting at index 0 is "cba", which is an anagram of "abc".
- The substring starting at index 6 is "bac", which is an anagram of "abc".
```

### Example 2:
```
Input: s = "abab", p = "ab"
Output: [0,1,2]
Explanation:
- The substring starting at index 0 is "ab", which is an anagram of "ab".
- The substring starting at index 1 is "ba", which is an anagram of "ab".
- The substring starting at index 2 is "ab", which is an anagram of "ab".
```

## The Twist

**Fixed-size sliding window**. Unlike other sliding window problems where the window size varies, here the window size is always equal to the length of `p`.

## Hash Table Usage

- **Key**: `character` (from string p)
- **Value**: `frequency` (how many times this character should appear)

Algorithm:
1. Build frequency map of characters in `p`
2. Use a fixed-size sliding window of length `len(p)` over `s`
3. Maintain a frequency map for the current window
4. Compare window map with target map (or use a counter for efficiency)
5. Record starting index when maps match

## Complexity

- **Time**: O(n) - single pass through the string
- **Space**: O(1) - at most 26 characters (for lowercase letters) in the map

## Link

[LeetCode 0438 Find All Anagrams in a String](https://leetcode.com/problems/find-all-anagrams-in-a-string/)
