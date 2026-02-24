# 0249 Group Shifted Strings

## Problem Description

We can shift a string by shifting each of its letters to its successive letter. For example, "abc" can be shifted to "bcd".

Given an array of strings `strings`, group all strings that belong to the same shifting sequence. You may return the answer in any order.

### Example 1:
```
Input: strings = ["abc","bcd","acef","xyz","az","ba","a","z"]
Output: [["acef"],["a","z"],["abc","bcd"],["xyz"],["az","ba"]]
```

### Example 2:
```
Input: strings = ["a"]
Output: [["a"]]
```

## The Twist

Words can be **shifted alphabetically**. Two strings belong to the same group if one can be transformed into the other by shifting each character by the same amount.

## Hash Table Usage

- **Key**: `relative_distance` between characters (e.g., "1-1" for "abc")
- **Value**: `[list_of_strings]` (all strings with this pattern)

Algorithm:
1. For each string, compute its key by calculating the relative distance between consecutive characters
2. For "abc": b-a=1, c-b=1 → key "1-1"
3. For "bcd": c-b=1, d-c=1 → key "1-1" (same as "abc")
4. For "az": z-a=25 → key "25" (wrapping handled)
5. Use the key to group strings in the hash map

## Complexity

- **Time**: O(n * k log k) where n is number of strings, k is average string length
- **Space**: O(n * k) - storing all strings in the map

## Link

[LeetCode 0249 Group Shifted Strings](https://leetcode.com/problems/group-shifted-strings/)
