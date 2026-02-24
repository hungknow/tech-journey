# 0734 Sentence Similarity

## Problem Description

Given two sentences `sentence1` and `sentence2` and an array of string pairs `similarPairs` where `similarPairs[i] = [xi, yi]` indicates that the two words `xi` and `yi` are similar.

Two sentences `sentence1` and `sentence2` are similar if:
1. They have the same length
2. For each index `i`, `sentence1[i]` and `sentence2[i]` are similar

Note that a word is always similar with itself, and similarity is not transitive.

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

Words are similar based on **pairs**. We need to validate if each corresponding word pair in the sentences are similar according to the given pairs.

## Hash Table Usage

- **Key**: `word` (a word from the sentences)
- **Value**: `Set(similar_words)` (all words that are similar to this word)

Algorithm:
1. Build a bidirectional similarity map from the pairs
2. Check if sentences have the same length
3. For each corresponding word pair:
   - If words are identical, continue
   - Otherwise, check if they are in each other's similarity sets
4. If all pairs pass, return true

## Complexity

- **Time**: O(n + p) where n is sentence length, p is number of similar pairs
- **Space**: O(p) - storing all similar pairs

## Link

[LeetCode 0734 Sentence Similarity](https://leetcode.com/problems/sentence-similarity/)
