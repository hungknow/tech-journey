# 0748 Shortest Completing Word

## Problem Description

Given a string `licensePlate` and an array of strings `words`, find the shortest completing word in `words`.

A completing word is a word that contains all the letters in the license plate (case-insensitive). The frequency of letters in the completing word must be greater than or equal to the frequency in the license plate.

If there are multiple shortest completing words, return the first one.

### Example 1:
```
Input: licensePlate = "1s3 PSt", words = ["step","steps","stripe","stepple"]
Output: "steps"
Explanation: The shortest completing word is "steps" which contains all letters from the license plate.
```

### Example 2:
```
Input: licensePlate = "1s3 456", words = ["looks","pest","stew","show"]
Output: "pest"
```

## The Twist

Map stores the frequency of alphabetical characters in the target license plate to filter out invalid words.

## Hash Table Usage

- **Key**: `character` (from the license plate)
- **Value**: `required_count` (how many times this character appears in the license plate)

Algorithm:
1. Extract all alphabetical characters from the license plate (case-insensitive)
2. Count the frequency of each character
3. For each word in words:
   - Check if it contains all required characters with sufficient frequency
   - Track the shortest valid word
4. Return the shortest completing word

## Complexity

- **Time**: O(n * k) where n is number of words, k is average word length
- **Space**: O(1) - at most 26 characters (for lowercase letters)

## Link

[LeetCode 0748 Shortest Completing Word](https://leetcode.com/problems/shortest-completing-word/)
