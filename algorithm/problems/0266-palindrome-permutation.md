# 0266 Palindrome Permutation

## Problem Description

Given a string `s`, return `true` if a permutation of the string could form a palindrome and `false` otherwise.

### Example 1:
```
Input: s = "code"
Output: false
```

### Example 2:
```
Input: s = "aab"
Output: true
```

### Example 3:
```
Input: s = "carerac"
Output: true
```

## The Twist

A valid palindrome can only have **one odd-counted character** (for odd-length strings) or none (for even-length strings). We need to verify this property.

## Hash Table Usage

- **Key**: `character` (from the string)
- **Value**: `frequency` (how many times this character appears)

Algorithm:
1. Count the frequency of each character
2. Count how many characters have odd frequencies
3. Return true if odd_count <= 1, otherwise false

Optimization: Use a set to toggle characters (add if not present, remove if present). The final set size should be <= 1.

## Complexity

- **Time**: O(n) - single pass through the string
- **Space**: O(1) - at most 26 characters (for lowercase letters) or 256 (for ASCII)

## Link

[LeetCode 0266 Palindrome Permutation](https://leetcode.com/problems/palindrome-permutation/)
