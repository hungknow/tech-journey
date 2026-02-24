# 0387 First Unique Character in a String

## Problem Description

Given a string `s`, find the first non-repeating character in it and return its index. If it does not exist, return `-1`.

### Example 1:
```
Input: s = "leetcode"
Output: 0
```

### Example 2:
```
Input: s = "loveleetcode"
Output: 2
```

### Example 3:
```
Input: s = "aabb"
Output: -1
```

## The Twist

Finding the **first** character with a count of 1. We need to count frequencies first, then scan again to find the first unique character.

## Hash Table Usage

- **Key**: `character` (from the string)
- **Value**: `frequency` (how many times this character appears)

Algorithm:
1. Count the frequency of each character
2. Iterate through the string a second time:
   - Find the first character with a frequency of 1
   - Return its index
3. If no unique character is found, return -1

## Complexity

- **Time**: O(n) - two passes through the string
- **Space**: O(1) - at most 26 characters (for lowercase letters) or 256 (for ASCII)

## Link

[LeetCode 0387 First Unique Character in a String](https://leetcode.com/problems/first-unique-character-in-a-string/)
