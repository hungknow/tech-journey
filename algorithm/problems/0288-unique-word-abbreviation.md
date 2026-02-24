# 0288 Unique Word Abbreviation

## Problem Description

A string can be abbreviated by replacing any number of non-adjacent, non-empty substrings with their lengths. The lengths should not have leading zeros.

For example, "internationalization" can be abbreviated as "i18n" ("i" + 18 letters + "n"), or "it18n" ("it" + 18 letters + "n"), or "in18n" ("in" + 18 letters + "n"), etc.

Given a dictionary of words and a word, determine if its abbreviation is unique in the dictionary. A word's abbreviation is unique if no other word in the dictionary has the same abbreviation.

### Example 1:
```
Input: dictionary = ["deer","door","cake","card"], word = "dear"
Output: false
Explanation: "dear" has abbreviation "d2r", which is not unique because "door" also has abbreviation "d2r".
```

### Example 2:
```
Input: dictionary = ["deer","door","cake","card"], word = "cart"
Output: true
Explanation: "cart" has abbreviation "c2t", which is unique.
```

### Example 3:
```
Input: dictionary = ["deer","door","cake","card"], word = "cane"
Output: false
Explanation: "cane" has abbreviation "c2e", which is not unique because "cake" also has abbreviation "c2e".
```

## The Twist

Validating **custom abbreviations**. We need to ensure abbreviations don't overlap uniquely between different words.

## Hash Table Usage

- **Key**: `abbreviation` (the abbreviated form of the word)
- **Value**: `Set(original_words)` (all words that share this abbreviation)

Algorithm:
1. Build a map from abbreviations to sets of original words
2. For the query word, compute its abbreviation
3. Check if the abbreviation exists in the map:
   - If not, return true (unique)
   - If yes, check if the set contains only the query word
4. Return true if the set size is 1 and contains the query word, otherwise false

## Complexity

- **Time**: O(n) for initialization, O(1) for lookup
- **Space**: O(n) - storing all words and their abbreviations

## Link

[LeetCode 0288 Unique Word Abbreviation](https://leetcode.com/problems/unique-word-abbreviation/)
