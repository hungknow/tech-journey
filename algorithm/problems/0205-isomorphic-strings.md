# 0205 Isomorphic Strings

## Problem Description

Given two strings `s` and `t`, determine if they are isomorphic.

Two strings `s` and `t` are isomorphic if the characters in `s` can be replaced to get `t`.

All occurrences of a character must be replaced with another character while preserving the order of characters. No two characters may map to the same character, but a character may map to itself.

### Example 1:
```
Input: s = "egg", t = "add"
Output: true
```

### Example 2:
```
Input: s = "foo", t = "bar"
Output: false
```

### Example 3:
```
Input: s = "paper", t = "title"
Output: true
```

## The Twist

Enforcing a **1-to-1 character swap** between strings. We need to ensure each character maps to exactly one character and no two characters map to the same character.

## Hash Table Usage

Two maps (or arrays) are used:
1. **Map 1**: `char_from_s -> char_from_t` (forward mapping)
2. **Map 2**: `char_from_t -> char_from_s` (reverse mapping for collision detection)

Algorithm:
1. Iterate through both strings simultaneously
2. For each pair of characters (s_char, t_char):
   - If s_char already maps to a different t_char, return false
   - If t_char is already mapped from a different s_char, return false
   - Otherwise, establish the mapping
3. If we complete the loop, return true

## Complexity

- **Time**: O(n) - single pass through the strings
- **Space**: O(1) - at most 256 characters (for ASCII) in each map

## Link

[LeetCode 0205 Isomorphic Strings](https://leetcode.com/problems/isomorphic-strings/)
