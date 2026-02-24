# 0030 Substring with Concatenation of All Words

## Problem Description

You are given a string `s` and an array of strings `words`. All the strings of `words` are of the same length.

A concatenated substring in `s` is a substring that contains all the strings of `words` in any order and without any intervening characters.

Return the starting indices of all the concatenated substrings in `s`. You can return the answer in any order.

### Example 1:
```
Input: s = "barfoothefoobarman", words = ["foo","bar"]
Output: [0,9]
Explanation: 
- Substring starting at index 0 is "barfoo". It is the concatenation of ["bar","foo"].
- Substring starting at index 9 is "foobar". It is the concatenation of ["foo","bar"].
```

### Example 2:
```
Input: s = "wordgoodgoodgoodbestword", words = ["word","good","best","word"]
Output: []
```

### Example 3:
```
Input: s = "barfoofoobarthefoobarman", words = ["bar","foo","the"]
Output: [6,9,12]
```

## The Twist

Matching **multi-character words** instead of single letters. We need to find substrings that are concatenations of all words in any order.

## Hash Table Usage

Two frequency maps are used:
1. **Target map**: `word -> required_count` for all words in the input array
2. **Window map**: `word -> current_count` for words inside the current sliding window

Algorithm:
1. Build frequency map of all words
2. For each starting position (0 to word_length - 1):
   - Slide a window through the string in word_length steps
   - Extract words of fixed length from the window
   - Maintain window frequency map
   - If window map matches target map, record starting index

## Complexity

- **Time**: O((m + n) * k) where m is string length, n is number of words, k is word length
- **Space**: O(n * k) - storing words and their frequencies

## Link

[LeetCode 0030 Substring with Concatenation of All Words](https://leetcode.com/problems/substring-with-concatenation-of-all-words/)
