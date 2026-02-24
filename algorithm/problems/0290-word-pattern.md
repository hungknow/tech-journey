# 0290 Word Pattern

## Problem Description

Given a `pattern` and a string `s`, find if `s` follows the same pattern.

Here follow means a full match, such that there is a bijection between a letter in `pattern` and a non-empty word in `s`.

### Example 1:
```
Input: pattern = "abba", s = "dog cat cat dog"
Output: true
```

### Example 2:
```
Input: pattern = "abba", s = "dog cat cat fish"
Output: false
```

### Example 3:
```
Input: pattern = "aaaa", s = "dog cat cat dog"
Output: false
```

## The Twist

Same logic as Isomorphic Strings, but mapping a `pattern_character -> whole_word` instead of character to character.

## Hash Table Usage

Two maps are used:
1. **Map 1**: `pattern_char -> word` (forward mapping)
2. **Map 2**: `word -> pattern_char` (reverse mapping for collision detection)

Algorithm:
1. Split the string `s` into words
2. Check if the number of words matches the pattern length
3. Iterate through pattern and words simultaneously
4. For each pair (pattern_char, word):
   - If pattern_char already maps to a different word, return false
   - If word is already mapped from a different pattern_char, return false
   - Otherwise, establish the mapping
5. If we complete the loop, return true

## Complexity

- **Time**: O(n) - single pass through the pattern
- **Space**: O(n) - storing mappings for each unique pattern character

## Link

[LeetCode 0290 Word Pattern](https://leetcode.com/problems/word-pattern/)
