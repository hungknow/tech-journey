# 0336 Palindrome Pairs

## Problem Description

Given a list of unique words, return all the pairs of the distinct indices `(i, j)` in the given list, so that the concatenation of the two words `words[i] + words[j]` is a palindrome.

### Example 1:
```
Input: words = ["abcd","dcba","lls","s","sssll"]
Output: [[0,1],[1,0],[3,2],[2,4]]
Explanation: The palindromes are "[dcbaabcd]", "[abcddcba]", "[slls]", "[llssssll]"
```

### Example 2:
```
Input: words = ["bat","tab","cat"]
Output: [[0,1],[1,0]]
```

### Example 3:
```
Input: words = ["a",""]
Output: [[0,1],[1,0]]
```

## The Twist

Map stores `reversed_word -> index`. You iterate through words, split them into prefixes/suffixes, and check the map to see if valid pairs can be formed.

## Hash Table Usage

- **Key**: `reversed_word` (the word reversed)
- **Value**: `index` (the original index of this word)

Algorithm:
1. Build a map from each word's reverse to its index
2. For each word, try all possible splits into prefix and suffix:
   - If prefix is a palindrome and reversed suffix exists in map, form a pair
   - If suffix is a palindrome and reversed prefix exists in map, form a pair
3. Avoid pairing a word with itself
4. Return all valid pairs

## Complexity

- **Time**: O(n * k²) where n is number of words, k is average word length
- **Space**: O(n * k) - storing all words and their reverses

## Link

[LeetCode 0336 Palindrome Pairs](https://leetcode.com/problems/palindrome-pairs/)
