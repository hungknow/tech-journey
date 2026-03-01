# 2785 Sort Vowels in a String

## Problem Description

Given a string `s`, sort the vowels in the string in non-decreasing order based on their ASCII codes.

The vowels are 'a', 'e', 'i', 'o', 'u', and 'y'. They can appear in both lower and upper cases.

Return the sorted string.

### Example 1:
```
Input: s = "lEetcOde"
Output: "ElEtcdO"
Explanation: 
The vowels in the string are 'e', 'o', 'e', 'o'.
Sorted vowels: 'e', 'o'.
The consonants are 'l', 't', 'c', 'd'.
```

### Example 2:
```
Input: s = "lYmpH"
Output: "YmpH"
Explanation: 
The vowels in the string are 'Y', 'm', 'H'.
Sorted vowels: 'Y', 'm'.
The consonants are 'l', 'p', 'H'.
```

## Solution Approach

We need to extract vowels and consonants, sort them separately, and then merge them back in the correct order.

## Algorithm

1. Create two lists: one for vowels and one for consonants.
2. Iterate through the string:
   - If the character is a vowel, add it to the vowels list.
   - Otherwise, add it to the consonants list.
3. Sort both lists in non-decreasing order.
4. Concatenate the sorted vowels and consonants.
5. Return the result.

## Why This Works

By separating vowels and consonants and sorting them independently, we achieve the desired order.

## Complexity

- **Time**: O(n log n) - sorting
- **Space**: O(n) - for storing the separated lists

## Link

[LeetCode 2785 Sort Vowels in a String](https://leetcode.com/problems/sort-vowels-in-a-string/)