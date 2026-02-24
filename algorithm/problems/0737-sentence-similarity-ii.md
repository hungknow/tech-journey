# 0737 Sentence Similarity II

## Problem Description

We can represent a sentence as an array of words, for example, the sentence `"I am happy with leetcode"` can be represented as `arr = ["I","am","happy","with","leetcode"]`.

Given two sentences `sentence1` and `sentence2` and an array of string pairs `similarPairs` where `similarPairs[i] = [xi, yi]` indicates that the two words `xi` and `yi` are similar.

Two sentences `sentence1` and `sentence2` are similar if:
1. They have the same length
2. For each index `i`, `sentence1[i]` and `sentence2[i]` are similar

Note that similarity is transitive (if a is similar to b and b is similar to c, then a is similar to c).

### Example 1:
```
Input: sentence1 = ["great","acting","skills"], sentence2 = ["fine","drama","talent"], similarPairs = [["great","fine"],["drama","acting"],["skills","talent"]]
Output: true
```

### Example 2:
```
Input: sentence1 = ["great"], sentence2 = ["great"], similarPairs = []
Output: true
```

### Example 3:
```
Input: sentence1 = ["great"], sentence2 = ["doubleplus","good"], similarPairs = [["great","doubleplus"]]
Output: false
```

## The Twist

Hash map `word -> integer_ID` to build a **Union-Find graph** of transitive word similarities.

## Hash Table Usage

- **Key**: `word` (a word from the sentences or similar pairs)
- **Value**: `unique_ID` (an integer identifier for Union-Find)

Algorithm:
1. Assign unique IDs to all words in similar pairs
2. Use Union-Find to connect similar words
3. Check if sentences have the same length
4. For each corresponding word pair:
   - If words are identical, continue
   - Otherwise, check if they belong to the same set in Union-Find
5. If all pairs pass, return true

## Complexity

- **Time**: O(n + p * α(p)) where n is sentence length, p is number of similar pairs, α is the inverse Ackermann function
- **Space**: O(p) - storing word mappings and Union-Find structures

## Link

[LeetCode 0737 Sentence Similarity II](https://leetcode.com/problems/sentence-similarity-ii/)
