# 0771 Jewels and Stones

## Problem Description

You're given strings `jewels` representing the types of stones that are jewels, and `stones` representing the stones you have. Each character in `stones` is a type of stone you have. You want to know how many of the stones you have are also jewels.

Letters are case sensitive.

### Example 1:
```
Input: jewels = "aA", stones = "aAAbbbb"
Output: 3
```

### Example 2:
```
Input: jewels = "z", stones = "ZZ"
Output: 0
```

## The Twist

A Hash Set stores the characters of the "Jewels" string for instant O(1) lookups while iterating through the "Stones" string.

## Hash Table Usage

- **Key**: `jewel_character` (a character from the jewels string)
- **Value**: `true` (or just use a set)

Algorithm:
1. Add all characters from `jewels` to a hash set
2. Iterate through `stones`:
   - For each character, check if it exists in the jewels set
   - If yes, increment the count
3. Return the total count

## Complexity

- **Time**: O(m + n) where m is length of jewels, n is length of stones
- **Space**: O(m) - storing all unique jewel characters

## Link

[LeetCode 0771 Jewels and Stones](https://leetcode.com/problems/jewels-and-stones/)
