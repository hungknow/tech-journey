# 0966 Vowel Spellchecker

## Problem Description

Given a `wordlist` and a `query`, return a list of words from the wordlist that match the query according to the following rules:

1. **Exact Match**: If the query matches a word exactly (case-insensitive), return that word.
2. **Capitalization Match**: If the query matches a word ignoring case, return the first such word.
3. **Vowel Match**: If the query matches a word after replacing vowels ('a', 'e', 'i', 'o', 'u') with any other vowel, return the first such word.

If no match is found, return an empty string.

### Example 1:
```
Input: wordlist = ["KiTe","kite","hare","Hare"], queries = ["kite","Kite","KiTe","Hare","HARE","Hear","hear","keti","keet","keto"]
Output: ["kite","KiTe","KiTe","Hare","hare","","","KiTe","","KiTe"]
```

### Example 2:
```
Input: wordlist = ["yellow"], queries = ["YellOw"]
Output: ["yellow"]
```

## The Twist

Resolves capitalization and vowel typos. Uses two maps: `lowercase_word -> original` and `devoweled_word -> original`, plus a Hash Set for exact matches.

## Hash Table Usage

Three data structures are used:
1. **Set**: `exact_words` (all words in lowercase for exact match)
2. **Map 1**: `lowercase_word -> original` (for capitalization match)
3. **Map 2**: `devoweled_word -> original` (for vowel match, where vowels are replaced with '*')

Algorithm:
1. Preprocess the wordlist:
   - Add lowercase versions to the exact set
   - Map lowercase words to their first original occurrence
   - Map devoweled words to their first original occurrence
2. For each query:
   - Check exact match (case-insensitive)
   - Check capitalization match
   - Check vowel match
3. Return the best match found, or empty string

## Complexity

- **Time**: O(n + q * l) where n is wordlist size, q is query count, l is average word length
- **Space**: O(n * l) - storing all words and their variations

## Link

[LeetCode 0966 Vowel Spellchecker](https://leetcode.com/problems/vowel-spellchecker/)
